//
//  TFVectorRepresentable.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

import CoreGraphics

// Objects that are representable as a 'vector' with n dimensions, which would be an array of floating points.
// Conformation to this protocol 'automatically' gives the given object a large number of mathematical operators, like multiplication, subtraction etc.
public protocol TFVectorRepresentable: TFInterpolatable {
    
    typealias Vector = [CGFloat]
    
    var asVector: Vector { get }
    static func from(vector: Vector) -> Self
}

// MARK: Operators
public extension TFVectorRepresentable {
    
    static func * (lhs: Self, rhs: CGFloat) -> Self {
        var resultVector: Vector = []
        for value in lhs.asVector {
            resultVector.append(value * rhs)
        }
        return .from(vector: resultVector)
    }
    
    static func *= (lhs: inout Self, rhs: CGFloat) {
        let newAmount = lhs * rhs
        lhs = newAmount
    }
    
    static func * (lhs: Self, rhs: Self) -> Self {
        var resultVector: Vector = []
        let otherVector = rhs.asVector
        for (index, value) in lhs.asVector.enumerated() {
            resultVector.append(value * (otherVector[safe: index] ?? 0))
        }
        return .from(vector: resultVector)
    }
    
    static func *= (lhs: inout Self, rhs: Self) {
        let newAmount = lhs * rhs
        lhs = newAmount
    }
    
    static func + (lhs: Self, rhs: Self) -> Self {
        var resultVector: Vector = []
        let otherVector = rhs.asVector
        for (index, value) in lhs.asVector.enumerated() {
            resultVector.append(value + (otherVector[safe: index] ?? 0))
        }
        return .from(vector: resultVector)
    }
    
    static func += (lhs: inout Self, rhs: Self) {
        let newAmount = lhs + rhs
        lhs = newAmount
    }
    
    static func - (lhs: Self, rhs: Self) -> Self {
        var resultVector: Vector = []
        let otherVector = rhs.asVector
        for (index, value) in lhs.asVector.enumerated() {
            resultVector.append(value - (otherVector[safe: index] ?? 0))
        }
        return .from(vector: resultVector)
    }
    
    static func -= (lhs: inout Self, rhs: Self) {
        let newAmount = lhs - rhs
        lhs = newAmount
    }
    
    static func / (lhs: Self, rhs: Self) -> Self {
        var resultVector: Vector = []
        let otherVector = rhs.asVector
        for (index, value) in lhs.asVector.enumerated() {
            let dividerValue: CGFloat = otherVector[safe: index] ?? 0
            resultVector.append(value / (dividerValue.isZero ? .leastNormalMagnitude : dividerValue))
        }
        return .from(vector: resultVector)
    }
    
    static func /= (lhs: inout Self, rhs: Self) {
        let newAmount = lhs / rhs
        lhs = newAmount
    }
}

// MARK: Public helper methods
public extension TFVectorRepresentable {
    
    var normalized: Self {
        let magnitude = self.magnitude
        guard magnitude.isNormal else { return self }
        let delta = 1 / magnitude
        return .from(vector: asVector.map({ $0 * delta }))
    }
    
    func delta(from other: Self) -> Self {
        return self - other
    }
    
    func distance(to other: Self) -> CGFloat {
        return delta(from: other).magnitude
    }
    
    /// Treating the VectorRepresentable as a vector, returning the length of the vector arrow if it were an arrow in space with n dimensions. This length can never be negative
    var magnitude: CGFloat { magnitude(of: asVector) }
    
    /// Treating the VectorRepresentable as a vector, returning the distance if movement occurs only parallel to axii
    var manhattanDistance: CGFloat { asVector.reduce(0, +) }
    
    /// Rounds all numbers in the object to the given decimals
    func rounded(decimals: Int) -> Self { Self.from(vector: self.asVector.map({ $0.rounded(decimals: decimals) })) }
}

// MARK: Interpolatable
public extension TFVectorRepresentable {
    
    /// Returns an new object with every number randomized separately
    // Naming must be slightly different from original Swift.CGFloat.random(in:) because otherwise recursion to this method will occur
    static func random(_ range: ClosedRange<CGFloat>) -> Self {
        let zero: Self = .from(vector: [])
        return .from(vector: zero.asVector.map({ _ in CGFloat.random(in: range) }))
    }
    
    static func interpolated(from start: Self, to end: Self, progress: CGFloat) -> Self {
        if let startFloat = start as? CGFloat, let endFloat = end as? CGFloat, let result = lerpedFloat(from: startFloat, to: endFloat, progress: progress) as? Self {
            return result // For performance it would be better to avoid the conversion from and to array (self.asVector) if it's a single value
        } else {
            let startVector = start.asVector
            let endVector = end.asVector
            var resultDimensions: Vector = []
            for (index, value) in startVector.enumerated() {
                let endValue = endVector[safe: index] ?? 0
                resultDimensions.append(lerpedFloat(from: value, to: endValue, progress: progress))
            }
            return .from(vector: resultDimensions)
        }
    }
    
    // Absolutely necessary for the 'lerped' function above, because using CGFloat.lerped over there will recursively call itself
    private static func lerpedFloat(from start: CGFloat, to end: CGFloat, progress: CGFloat) -> CGFloat {
        let fromAmount = (1 - progress) * start
        let toAmount = progress * end
        return fromAmount + toAmount
    }
}

// MARK: Private helper methods
private extension TFVectorRepresentable {
    
    func magnitude(of dimensions: Vector) -> CGFloat {
        guard dimensions.count != 1 else { return abs(dimensions.first ?? 0) } // Magnitude should always be positive, as sqrt also is
        var distance: CGFloat = 0
        dimensions.forEach { i in
            distance += pow(i, CGFloat(2))
        }
        return sqrt(distance)
    }
}
