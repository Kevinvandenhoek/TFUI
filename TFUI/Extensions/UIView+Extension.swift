//
//  UIView+Extension.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

import UIKit
import EasyPeasy

public extension UIView {
    
    var width: CGFloat { bounds.width }
    var height: CGFloat { bounds.height }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    func fill(with view: UIView, insets: UIEdgeInsets = .zero) {
        self.setSubviews(view)
        view.easy.layout(Edges(insets))
    }
    
    func removeAllSubViews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
    
    /// Removes all existing subviews, replacing them with the given new subviews
    func setSubviews(_ subviews: UIView...) {
        removeAllSubViews()
        addSubviews(subviews)
    }
    
    /// Removes all existing subviews, replacing them with the given new subviews
    func setSubviews(_ subviews: [UIView]) {
        removeAllSubViews()
        addSubviews(subviews)
    }
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach({ addSubview($0) })
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach({ addSubview($0) })
    }
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
    
    /// Note that the blurRadius does not match directly with shadowRadius. It instead matches that of a Sketch radius blur setting
    func setShadow(color: UIColor = .black, opacity: CGFloat, blurRadius: CGFloat, offset: CGPoint = .zero) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: offset.x, height: offset.y)
        layer.shadowRadius = blurRadius / 2 // To match Sketch settings
        layer.shadowOpacity = Float(opacity)
    }
    
    func frame(in view: UIView) -> CGRect {
        return convert(bounds, to: view)
    }
    
    /// Recursively search for all subviews of a given type. Includes itself by default
    func findAllChildren<Type>(includeSelf: Bool = true) -> [Type] {
        var items: [Type] = []
        if includeSelf, let item = self as? Type { items.append(item) }
        for view in subviews {
            items += view.findAllChildren(includeSelf: false)
            if let item = view as? Type { items.append(item) }
        }
        return items
    }
    
    func findNearestParentOfType<View: UIView>() -> View? {
        var parent = superview
        while let current = parent {
            if let view = current as? View {
                return view
            } else {
                parent = parent?.superview
            }
        }
        return nil
    }
    
    var frameInWindow: CGRect? {
        guard let window = window else { return nil }
        if let presentation = layer.presentation(), let superlayer = presentation.superlayer {
            return superlayer.convert(presentation.frame, to: window.layer)
        } else {
            return superview?.convert(frame, to: window)
        }
    }
    
    var frameInViewController: CGRect? {
        guard let vcView = parentViewController?.view else { return nil }
        return superview?.convert(frame, to: vcView)
    }
    
    var tfSafeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return safeAreaInsets
        } else {
            return .only(top: UIApplication.shared.statusBarFrame.maxY)
        }
    }
}
