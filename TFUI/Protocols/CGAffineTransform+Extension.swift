//
//  CGAffineTransform+Extension.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

import CoreGraphics

extension CGAffineTransform {
    
    static func scaled(by point: CGPoint) -> CGAffineTransform {
        return CGAffineTransform.identity.scaledBy(x: point.x, y: point.y)
    }
    
    static func scaled(x: CGFloat = 1, y: CGFloat = 1) -> CGAffineTransform {
        return CGAffineTransform.identity.scaledBy(x: x, y: y)
    }
    
    static func scaled(by amount: CGFloat) -> CGAffineTransform {
        return CGAffineTransform.identity.scaledBy(x: amount, y: amount)
    }
    
    func scaled(by point: CGPoint) -> CGAffineTransform {
        return self.scaledBy(x: point.x, y: point.y)
    }
    
    func scaled(x: CGFloat = 1, y: CGFloat = 1) -> CGAffineTransform {
        return self.scaledBy(x: x, y: y)
    }
    
    func scaled(by amount: CGFloat) -> CGAffineTransform {
        return self.scaledBy(x: amount, y: amount)
    }
    
    static func translated(by point: CGPoint) -> CGAffineTransform {
        return CGAffineTransform.identity.translatedBy(x: point.x, y: point.y)
    }
    
    static func translated(x: CGFloat = 0, y: CGFloat = 0) -> CGAffineTransform {
        return CGAffineTransform.identity.translatedBy(x: x, y: y)
    }
    
    func translated(by point: CGPoint) -> CGAffineTransform {
        return self.translatedBy(x: point.x, y: point.y)
    }
    
    func translated(x: CGFloat = 1, y: CGFloat = 1) -> CGAffineTransform {
        return self.translatedBy(x: x, y: y)
    }
    
    var rotation: Double {
        return atan2(Double(b), Double(a))
    }
    
    static func rotated(by radians: CGFloat) -> CGAffineTransform {
        return CGAffineTransform.identity.rotated(by: radians)
    }
    
    static func rotated(degrees: CGFloat) -> CGAffineTransform {
        return CGAffineTransform.identity.rotated(degrees: degrees)
    }
    
    func rotated(degrees: CGFloat) -> CGAffineTransform {
        return rotated(by: .pi * 2 * degrees / 360)
    }
}
