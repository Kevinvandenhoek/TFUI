//
//  FloatingPoint+Extension.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

public extension FloatingPoint {
    
    /// Removes the minus sign if present
    var absoluteValue: Self { return abs(self) }
    
    // Randomly inverts +/-
    var randomInverted: Self { return self * (Bool.random() ? -1 : 1) }
    
    /// Ensures a number does not exceed given bounds
    func clamped(between min: Self?, and max: Self?) -> Self {
        if let max = max, let min = min {
            return Swift.max(min, Swift.min(max, self))
        } else if let max = max {
            return Swift.min(max, self)
        } else if let min = min {
            return Swift.max(min, self)
        } else {
            return self
        }
    }
    
    /// Ensures a number does not exceed given bounds
    func clamped(within closedRange: ClosedRange<Self>) -> Self {
        return Swift.max(closedRange.lowerBound, Swift.min(closedRange.upperBound, self))
    }
    
    /// Ensures a number does not exceed given bounds
    func clamped(within upperBound: Self) -> Self {
        return Swift.max(0, Swift.min(upperBound, self))
    }
    
    /// Returns the percentage of the number within the range as a value between 0 and 1
    func percentage(within range: ClosedRange<Self>) -> Self {
        return (self - range.lowerBound) / range.size
    }
    
    /// Modifies a number to a different range. I.E. input 0.5 with oldRange 0...1 to newRange 0...2 will return 1 (the input was 'halfway' in the oldRange, and is converted to 'halfway' in the newRange
    func mapped(from oldRange: ClosedRange<Self>, to newRange: ClosedRange<Self>) -> Self {
        return ((self - oldRange.lowerBound) / oldRange.size) * (newRange.size) + newRange.lowerBound
    }
    
    /// Rounds to the nearest multiple of the given step size
    func asMultiple(of stepSize: Self) -> Self {
        let delta = self.truncatingRemainder(dividingBy: stepSize)
        if delta > stepSize / 2 {
            return self + (stepSize - delta)
        } else {
            return self - delta
        }
    }
}
