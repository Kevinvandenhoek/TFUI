//
//  UIEdgeInsets+extension.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

import UIKit

public extension UIEdgeInsets {
    
    // MARK: Helper methods
    static func - (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: lhs.top - rhs.top,
            left: lhs.left - rhs.left,
            bottom: lhs.bottom - rhs.bottom,
            right: lhs.right - rhs.right
        )
    }
    
    static func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: lhs.top + rhs.top,
            left: lhs.left + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right: lhs.right + rhs.right
        )
    }
    
    /// returns new insets with top and bottom set to 0
    var onlyVertical: UIEdgeInsets { return UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0) }
    /// returns new insets with left and right set to 0
    var onlyHorizontal: UIEdgeInsets { return UIEdgeInsets(top: 0, left: left, bottom: 0, right: right) }
    
    func with(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> UIEdgeInsets {
        return UIEdgeInsets(top: top ?? self.top, left: left ?? self.left, bottom: bottom ?? self.bottom, right: right ?? self.right)
    }
    
    func with(horizontal: CGFloat? = nil, vertical: CGFloat? = nil) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: vertical ?? top,
            left: horizontal ?? left,
            bottom: vertical ?? bottom,
            right: horizontal ?? right
        )
    }
    
    func filtered(by edges: TFInsetEdges) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: edges.contains(.top) ? top : 0,
            left: edges.contains(.left) ? left : 0,
            bottom: edges.contains(.bottom) ? bottom : 0,
            right: edges.contains(.right) ? right : 0
        )
    }
    
    static func all(_ amount: CGFloat) -> UIEdgeInsets {
        return .init(
            top: amount,
            left: amount,
            bottom: amount,
            right: amount
        )
    }
    
    static func only(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> UIEdgeInsets {
        return .init(
            top: top,
            left: left,
            bottom: bottom,
            right: right
        )
    }
    
    static func only(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> UIEdgeInsets {
        return .init(
            top: vertical,
            left: horizontal,
            bottom: vertical,
            right: horizontal
        )
    }

    var horizontal: CGFloat { left + right } /// Cumulative insets over x axis
    var vertical: CGFloat { top + bottom } /// Cumulative insets over y axis
}

// MARK: VectorRepresentable
extension UIEdgeInsets: TFVectorRepresentable {

    public var asVector: Vector { return [top, left, bottom, right] }
    
    public static func from(vector: Vector) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: vector[0],
            left: vector[1],
            bottom: vector[2],
            right: vector[3]
        )
    }
}
