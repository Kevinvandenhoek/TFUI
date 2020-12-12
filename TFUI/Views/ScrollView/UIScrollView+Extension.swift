//
//  UIScrollView+Extension.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

import EasyPeasy

enum ScrollViewToScreenPosition {
    case top
    case center
    case bottom
}

extension UIScrollView {
    
    /// The amount of (display)pixels a scrollview can scroll, both horizontally as vertically
    var scrollableDistance: CGSize {
        return .init(
            width: contentSize.width - (bounds.width + contentInset.horizontal),
            height: contentSize.height - (bounds.height + contentInset.vertical)
        )
    }
    
    func scroll(distance: CGPoint, animated: Bool = true) {
        setContentOffset(contentOffset + distance, animated: animated)
    }
    
    func scrollTo(view: UIView, to screenPosition: ScrollViewToScreenPosition = .top, animated: Bool = true) {
        guard contentSize.height > visibleContentSize.height else { return }
        let yPos: CGFloat
        switch screenPosition {
        case .top:
            yPos = view.frame.minY - tfAdjustedContentInset.top
        case .center:
            yPos = view.frame.midY - (frame.height / 2)
        case .bottom:
            yPos = view.frame.maxY + tfAdjustedContentInset.bottom - frame.height
        }
        let overscroll = determineVerticalOverscroll(for: yPos)
        let safeYPos = yPos - overscroll // We dont want to scroll outside the scrolling bounds
        setContentOffset(CGPoint(x: contentOffset.x, y: safeYPos), animated: animated)
    }
    
    /// The y distance that is scrolled by the user, relative to the default position
    var scrolledOffset: CGFloat {
        let baseOffset = tfAdjustedContentInset.top
        return contentOffset.y + baseOffset
    }
    
    /// Will return negative y when pulling past top edge, and postive y when pulling past bottom edge
    var verticalOverScroll: CGFloat {
        return determineVerticalOverscroll(for: contentOffset.y)
    }
    
    /// Will return negative x when pulling past left edge, and postive x when pulling past right edge
    var horizontalOverScroll: CGFloat {
        return determineHorizontalOverscroll(for: contentOffset.x)
    }
    
    /// Will return negative y values when pulling past top edge, positive y when pulling past bottom edge, negative x when pulling past left edge, and postive x when pulling past right edge
    var overScroll: CGPoint {
        return CGPoint(x: horizontalOverScroll, y: verticalOverScroll)
    }
    
    /// The size that is available before the need of scrolling. This is the size of the scrollview minus the insets
    var visibleContentSize: CGSize {
        return CGSize(
            width: bounds.width - (tfAdjustedContentInset.left + tfAdjustedContentInset.right),
            height: bounds.height - (tfAdjustedContentInset.top + tfAdjustedContentInset.bottom)
        )
    }
    
    /// The currently visible center point in the contentView
    var centerPoint: CGPoint {
        return CGPoint(
            x: center.x + contentOffset.x,
            y: center.y + contentOffset.y
        )
    }
    
    /// Checks if the scrollview is scrolled to the bottom (returns true if it is not possible to scroll further down)
    var isAtBottom: Bool {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height
        let scrollOffset = contentOffset.y - (contentInset.top + contentInset.bottom)
        return scrollOffset + scrollViewHeight >= scrollContentSizeHeight
    }
    
    /// Returns the distance the user has to scroll to reach the bottom. Always a positive value, and will return 0 if the user is at or past the bottom.
    var distanceFromBottom: CGFloat {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height
        let scrollOffset = contentOffset.y - (contentInset.top + contentInset.bottom)
        return -min(0, (scrollOffset + scrollViewHeight) - scrollContentSizeHeight)
    }
    
    /// Checks if the scrollview is scrolled top
    var isAtTop: Bool {
        return (contentOffset.y + contentInset.top).rounded(.toNearestOrEven) <= 0
    }
    
    /// Checks if the scrollview has enough content to scroll vertically (contentSize.height is larger than the height of the scrollview)
    var canScrollVertically: Bool {
        let scrollViewHeight = frame.size.height
        let scrollContentSizeHeight = contentSize.height
        return scrollContentSizeHeight > scrollViewHeight
    }
    
    /// Adds the given contentView to the scrollView and sets constraint to produce the expected behaviour around a given axis
    func setup(with contentView: UIView, axis: TFAxis) {
        addSubview(contentView)
        switch axis {
        case .vertical:
            contentView.easy.layout(Edges(), CenterX(), Width(*1).like(self, .width))
        case .horizontal:
            contentView.easy.layout(Edges(), CenterY(), Height(*1).like(self, .height))
        @unknown default:
            assertionFailure()
        }
    }
    
    func setScrollIndicatorsHidden(_ hidden: Bool) {
        showsVerticalScrollIndicator = !hidden
        showsHorizontalScrollIndicator = !hidden
    }
}

// MARK: Helper methods
private extension UIScrollView {
    
    func determineVerticalOverscroll(for contentOffset: CGFloat) -> CGFloat {
        let yOverscrollTop = min(0, tfAdjustedContentInset.top + contentOffset)
        let yOverscrollBottom = max(0, (height - contentSize.height - (tfAdjustedContentInset.bottom + tfAdjustedContentInset.top)) + (contentOffset))
        return yOverscrollTop + yOverscrollBottom
    }
    
    func determineHorizontalOverscroll(for contentOffset: CGFloat) -> CGFloat {
        let xOverscrollLeft = min(0, tfAdjustedContentInset.left + contentOffset)
        let xOverscrollRight = max(0, (width - max(contentSize.width, width) - (tfAdjustedContentInset.left + tfAdjustedContentInset.right)) + contentOffset)
        return xOverscrollLeft + xOverscrollRight
    }
    
    private var tfAdjustedContentInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        } else {
            // TODO: Test if this works
            return contentInset
        }
    }
}
