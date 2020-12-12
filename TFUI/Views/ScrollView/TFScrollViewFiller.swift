//
//  TFScrollViewFiller.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

import UIKit
import EasyPeasy

/// Use this to fill the scrollview to at least fill it's available space, so that the contentview will never be smaller than the scrollview (minus the insets). This can be used to for example guarantee that a button at the bottom of the content in the scrollview will always be at least at the bottom of the scrollview, by placing a ScrollViewFiller in between the button and the other content
public final class TFScrollViewFiller: UIView {
    
    // MARK: Internal properties
    @IBInspectable var minimumHeight: CGFloat = 0 { didSet { handleUpdate() } }
    var maximumHeight: CGFloat? { didSet { handleUpdate() } }
    
    // MARK: Private properties
    private var sizeObservation: NSKeyValueObservation?
    private var insetObservation: NSKeyValueObservation?
    private var safeAreaInsetObservation: NSKeyValueObservation?
    private weak var scrollView: UIScrollView?
    private(set) var setHeight: CGFloat {
        didSet {
            easy.layout(Height(setHeight))
            scrollView?.layoutIfNeeded()
        }
    }
    
    // MARK: Lifecycle
    public required init?(coder aDecoder: NSCoder) {
        self.setHeight = minimumHeight
        super.init(coder: aDecoder)
    }
    
    public init(minimumHeight: CGFloat = 0, maximumHeight: CGFloat? = nil, containedView: UIView? = nil) {
        self.minimumHeight = minimumHeight
        self.maximumHeight = maximumHeight
        self.setHeight = minimumHeight
        super.init(frame: .zero)
        
        if let containedView = containedView {
            addSubview(containedView)
            containedView.easy.layout(Edges())
        }
    }
    
    // MARK: Internal methods
    public override func layoutSubviews() {
        super.layoutSubviews()

        guard let scrollView = getScrollView() else { return }
        self.scrollView = scrollView
        sizeObservation?.invalidate()
        sizeObservation = scrollView.observe(\.contentSize) { [weak self] _, _ in
            self?.handleUpdate()
        }
        insetObservation?.invalidate()
        insetObservation = scrollView.observe(\.contentInset) { [weak self] _, _ in
            self?.handleUpdate()
        }
        safeAreaInsetObservation?.invalidate()
        if #available(iOS 11.0, *) {
            safeAreaInsetObservation = scrollView.observe(\.safeAreaInsets) { [weak self] _, _ in
                self?.handleUpdate()
            }
        }
        handleUpdate()
    }
    
    deinit {
        sizeObservation?.invalidate()
        sizeObservation = nil
        insetObservation?.invalidate()
        insetObservation = nil
        safeAreaInsetObservation?.invalidate()
        safeAreaInsetObservation = nil
    }
}

// MARK: Private helper methods
private extension TFScrollViewFiller {
    
    func handleUpdate() {
        guard let scrollView = scrollView, scrollView.isTracking == false else { return }
        let fillers: [TFScrollViewFiller] = scrollView.findAllChildren()
        let currentHeight = scrollView.contentSize.height - fillers.map({ $0.setHeight }).reduce(0, +)
        let availableHeight = scrollView.visibleContentSize.height
        let deficit: CGFloat = availableHeight - currentHeight
        let preferredHeight = deficit / CGFloat(max(1, fillers.count))
        let maxExceeding = fillers.compactMap({ $0.maximumHeight }).map({ preferredHeight - $0 }).filter({ $0 > 0 })
        let additionalHeight = maxExceeding.reduce(0, +) / CGFloat(fillers.filter({ $0.maximumHeight == nil }).count)
        let newHeight: CGFloat = (preferredHeight + additionalHeight).clamped(between: minimumHeight, and: maximumHeight).rounded(.down)
        guard newHeight != setHeight else { return }
        setHeight = newHeight
    }

    func getScrollView() -> UIScrollView? {
        var parent = superview
        while parent != nil {
            if let scrollView = parent as? UIScrollView {
                return scrollView
            } else {
                parent = parent?.superview
            }
        }
        return nil
    }
}
