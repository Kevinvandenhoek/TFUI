//
//  CGPoint+Extension.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

import CoreGraphics

extension CGPoint: TFVectorRepresentable {
    
    public var asVector: Self.Vector { [x, y] }
    
    public static func from(vector: Self.Vector) -> CGPoint {
        return CGPoint(
            x: vector[safe: 0] ?? 0,
            y: vector[safe: 1] ?? 0
        )
    }
}
