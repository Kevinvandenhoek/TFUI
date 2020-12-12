//
//  TFInterpolatable.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

/// https://en.wikipedia.org/wiki/interpolation
public protocol TFInterpolatable {
    
    /// Returns a value which, depending on 'progress' moving from 0 to 1, gradually changes from the 'start' to 'end'. I.E. if you say 'start = 0', 'end = 5' and 'progress = 0.5' you will get 2.5
    static func interpolated(from start: Self, to end: Self, progress: CGFloat) -> Self
}
