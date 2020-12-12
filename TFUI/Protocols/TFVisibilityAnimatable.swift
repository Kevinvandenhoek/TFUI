//
//  TFVisibilityAnimatable.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

import Foundation
import UIKit

public protocol TFVisibilityAnimatable {
    
    func set(visible: Bool, animated: Bool)
}

public extension TFVisibilityAnimatable {
    
    func appearAnimated() {
        set(visible: false, animated: false)
        set(visible: true, animated: true)
    }
}

public extension TFVisibilityAnimatable where Self: UIView {
    
    func set(visible: Bool, animated: Bool) {
        subviews.set(visible: visible, animated: animated)
    }
}

extension Array: TFVisibilityAnimatable where Element: UIView {
    
    /// Performs an animation on all elements, which with random delays and values animates the alpha and transform. Be aware you will lose a custom transform / alpha value with this
    public func set(visible: Bool, animated: Bool) {
        visibilityAnimatableSubviews.forEach({ $0.set(visible: visible, animated: animated) })
        let doActions: (UIView) -> Void = { view in set(subview: view, visible: visible) }
        if animated {
            notVisibilityAnimatableSubviews.forEach({ view -> Void in
                UIView.animate(
                    withDuration: 0.5,
                    delay: delay(for: view),
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 0,
                    options: .allowUserInteraction,
                    animations: { doActions(view) }
                )
            })
        } else {
            notVisibilityAnimatableSubviews.forEach({ doActions($0) })
        }
    }
    
    private var notVisibilityAnimatableSubviews: [UIView] {
        return filter {
            if let viewContainer = $0 as? TFViewContainer {
                // ViewContainers are guaranteed to be VisibilityAnimatable, but if their contained view is not visibility animatable we don't want to treat it as such
                return viewContainer.containedView is TFVisibilityAnimatable == false
            } else {
                return $0 is TFVisibilityAnimatable == false
            }
        }
    }
    
    private var visibilityAnimatableSubviews: [TFVisibilityAnimatable] {
        return compactMap {
            if let viewContainer = $0 as? TFViewContainer {
                return viewContainer.containedView as? TFVisibilityAnimatable
            } else {
                return $0 as? TFVisibilityAnimatable
            }
        }
    }
    
    private func set(subview: UIView, visible: Bool) {
        if visible {
            subview.alpha = 1
            subview.transform = .identity
        } else {
            subview.alpha = 0
            let vcCenter: CGPoint = subview.parentViewController?.view.bounds.center ?? UIScreen.main.bounds.center
            let viewCenter: CGPoint = subview.frameInViewController?.center ?? vcCenter
            let offset: CGPoint = ((viewCenter - vcCenter) / vcCenter) + .random(-0.2...0.2)
            let relativeWidth: CGFloat = .interpolated(
                from: 1,
                to: 0,
                progress: subview.width / UIScreen.main.bounds.width
            )
            subview.transform = CGAffineTransform
                .scaled(by: 1.1)
                .rotated(by: .random(in: 0.05...0.15) * offset.x * relativeWidth)
                .translated(by: .random(40...80) * offset)
        }
    }
    
    private func delay(for view: UIView) -> Double {
        guard let frame = view.frameInWindow else { return 0.3 }
        let preferredDelay: CGFloat = frame.center.manhattanDistance / (UIScreen.main.bounds.bottomRight.manhattanDistance * 2)
        let delay: CGFloat = preferredDelay + .random(in: 0...0.1) - 0.2
        return Swift.max(0, Double(delay))
    }
}
