//
//  TFViewContainer.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

import UIKit
import EasyPeasy

open class TFViewContainer: UIView {
    
    // MARK: Internal properties
    var overscrollInsets: UIEdgeInsets = .zero { didSet { updateAccumulatedInsets() } }
    var insets: UIEdgeInsets { didSet { updateAccumulatedInsets() } }
    var safeAreaInsetEdges: TFInsetEdges = .none { didSet { updateAccumulatedInsets() } }
    let containedView: UIView
    var alignment: Alignment {
        didSet { if alignment != oldValue { updateContainedConstraints() } }
    }
    
    // MARK: Private
    private var scrollObservation: NSKeyValueObservation?
    private var isHiddenObservation: NSKeyValueObservation?
    private var accumulatedInsets: UIEdgeInsets = .zero {
        didSet { if accumulatedInsets != oldValue { updateContainedConstraints() } }
    }
    
    // MARK: Lifecycle
    public required init(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    public init(with containedView: UIView, insets: UIEdgeInsets = .zero, safeAreaInsetEdges: TFInsetEdges = .none, alignment: Alignment = .stretch, backgroundColor: UIColor = .clear, hidesWhenContainedViewHides: Bool = true) {
        self.containedView = containedView
        self.insets = insets
        self.alignment = alignment
        super.init(frame: .zero)
        self.safeAreaInsetEdges = safeAreaInsetEdges
        self.backgroundColor = backgroundColor
        addSubview(containedView)
        updateAccumulatedInsets()
        updateContainedConstraints() // must be called manually for the initial state
        if hidesWhenContainedViewHides {
            isHiddenObservation = containedView.observe(\.isHidden, options: [.initial, .new]) { [weak self] _, isHiddenObservation in
                guard let self = self else { return }
                self.isHidden = isHiddenObservation.newValue == true
            }
        }
    }
    
    @available(iOS 11.0, *)
    open override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        updateAccumulatedInsets()
    }
    
    /// Enabling this for a given edge will make the view overflow that edge when the scrollView is pulling past the edge, creating a 'stretchy' effect when the user pulls past the edge of the scrollView
    open func setupOverScroll(with scrollView: UIScrollView?, edges: TFInsetEdges) {
        scrollObservation = scrollView?.observe(\.contentOffset, changeHandler: { [weak self] scrollView, _ in
            let overScroll = scrollView.overScroll
            self?.overscrollInsets = UIEdgeInsets
                .only(
                    top: min(overScroll.y, 0),
                    left: min(overScroll.x, 0),
                    bottom: min(-overScroll.y, 0),
                    right: min(-overScroll.x, 0)
                )
                .filtered(by: edges)
        })
        if scrollView == nil { overscrollInsets = .zero }
    }
}

// MARK: Private helpers
private extension TFViewContainer {
    
    func updateAccumulatedInsets() {
        accumulatedInsets = insets + overscrollInsets + tfSafeAreaInsets.filtered(by: safeAreaInsetEdges)
    }
    
    func updateContainedConstraints() {
        switch alignment {
        case .centerHorizontally:
            containedView.easy.layout(
                Top(accumulatedInsets.top),
                Bottom(accumulatedInsets.bottom),
                CenterX()
            )
        case .centerVertically:
            containedView.easy.layout(
                Left(accumulatedInsets.left),
                Right(accumulatedInsets.right),
                CenterY()
            )
        case .left, .right, .top, .bottom:
            containedView.easy.layout(
                (alignment == .left ? Right(<=accumulatedInsets.right) : Right(accumulatedInsets.right)),
                (alignment == .right ? Left(>=accumulatedInsets.left) : Left(accumulatedInsets.left)),
                (alignment == .top ? Bottom(<=accumulatedInsets.bottom) : Bottom(accumulatedInsets.bottom)),
                (alignment == .bottom ? Top(>=accumulatedInsets.top) : Top(accumulatedInsets.top))
            )
        case .stretch:
            containedView.easy.layout(Edges(accumulatedInsets))
        }
    }
}

public extension TFViewContainer {
    
    enum Alignment {
        case stretch
        case left
        case right
        case top
        case bottom
        case centerHorizontally
        case centerVertically
    }
}
