//
//  ClosedRange+Extension.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

public extension ClosedRange where Bound: FloatingPoint {
    
    var centerBound: Bound {
        return (lowerBound + upperBound) / 2
    }
    
    var size: Bound {
        return upperBound - lowerBound
    }
    
    func sample(at position: Bound) -> Bound {
        return lowerBound + (position * size)
    }
}

public extension ClosedRange where Bound == Int {
    
    var centerBound: Int {
        return (lowerBound + upperBound) / 2
    }
    
    var size: Int {
        return upperBound - lowerBound
    }
}
