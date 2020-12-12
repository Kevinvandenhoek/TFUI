//
//  CGRect+Extension.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

import CoreGraphics

extension CGRect: TFVectorRepresentable {

    public var asVector: Vector { return [minX, minY, width, height] }
    
    public static func from(vector: Vector) -> CGRect {
        return CGRect(x: vector[0], y: vector[1], width: vector[2], height: vector[3])
    }
    
    static func * (lhs: CGRect, rhs: CGSize) -> CGRect {
        return CGRect(x: lhs.minX * rhs.width, y: lhs.minY * rhs.height, size: lhs.size * rhs)
    }
    
    var center: CGPoint { return CGPoint(x: midX, y: midY) }
    
    /// Returns a scaled CGRect, scaling relative to the center of the rectangle
    func scaled(by amount: CGFloat) -> CGRect {
        return .init(
            x: minX - (width * (amount - 1) * 0.5),
            y: minY - (height * (amount - 1) * 0.5),
            width: width * amount,
            height: height * amount
        )
    }
    
    var topLeft: CGPoint { CGPoint(x: minX, y: minY) }
    var topCenter: CGPoint { CGPoint(x: midX, y: minY) }
    var topRight: CGPoint { CGPoint(x: maxX, y: minY) }
    var bottomLeft: CGPoint { CGPoint(x: minX, y: maxY) }
    var bottomCenter: CGPoint { CGPoint(x: midX, y: maxY) }
    var bottomRight: CGPoint { CGPoint(x: maxX, y: maxY) }
    
    init(x: CGFloat, y: CGFloat, size: CGSize) {
        self.init(x: x, y: y, width: size.width, height: size.height)
    }
    
    init(x: CGFloat, y: CGFloat, size: CGFloat) {
        self.init(x: x, y: y, width: size, height: size)
    }
    
    /// Increases the width of the rect, from center origin
    func adding(width delta: CGFloat) -> CGRect {
        guard self.width.isNormal else { return self }
        return CGRect(x: minX - (delta / 2), y: minY, size: CGSize(width: width + delta, height: height))
    }
    
    func with(x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) -> CGRect {
        return CGRect(
            x: x ?? self.minX,
            y: y ?? self.minY,
            width: width ?? self.width,
            height: height ?? self.height
        )
    }
    
    func aspectFitted(in size: CGSize) -> CGRect {
        let widthMultiplier = size.width / width
        let heightMultiplier = size.height / height
        let newSize: CGSize = self.size * min(widthMultiplier, heightMultiplier)
        return CGRect(
            x: (newSize.width - size.width) / 2,
            y: (newSize.height - size.height) / 2,
            width: newSize.width,
            height: newSize.height
        )
    }
}
