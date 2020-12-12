//
//  TFScrollView.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

import Foundation
import UIKit

open class TFScrollView: UIScrollView, UpdatableView {
    
    // MARK: Private properties
    private var containerView: TFViewContainer?
    private let isKeyboardAvoiding: Bool
    private var contentSizeObservation: NSKeyValueObservation?
    
    var viewModel: ViewModel? {
        didSet {
            renderViewModel()
            guard let viewModel = viewModel else { return }
            adjustContentForSafeAreaEdges = viewModel.adjustContentForSafeAreaEdges
            insets = viewModel.insets
            if #available(iOS 11.0, *) {
                contentInsetAdjustmentBehavior = .never
            }
        }
    }
    var adjustContentForSafeAreaEdges: TFInsetEdges = .all {
        didSet { setInsetsWithSafeAreaEdgesThatAreProvided() }
    }
    var insets: UIEdgeInsets = .zero {
        didSet { setInsetsWithSafeAreaEdgesThatAreProvided() }
    }
    open override var delaysContentTouches: Bool {
        didSet { didManuallySetDelaysContentTouches = true }
    }
    
    /// If the ViewModel.Content is set to elements, this is the stackview the elements are wrapped in
    var stackView: UIStackView? { containerView?.containedView as? UIStackView }
    
    private var didManuallySetDelaysContentTouches = false
    
    // MARK: Lifecycle
    required public init?(coder aDecoder: NSCoder) {
        self.isKeyboardAvoiding = false
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        self.isKeyboardAvoiding = false
        super.init(frame: frame)
        setup()
    }
    
    init(isKeyboardAvoiding: Bool, endsEditingWhenTapped: Bool = true) {
        self.isKeyboardAvoiding = isKeyboardAvoiding
        super.init(frame: .zero)
        setup()
        if endsEditingWhenTapped {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
            tap.cancelsTouchesInView = false
            addGestureRecognizer(tap)
        }
    }
    
    deinit {
        guard isKeyboardAvoiding else { return }
        NotificationCenter.default.removeObserver(self)
    }
    
    @available(iOS 11.0, *)
    open override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        setInsetsWithSafeAreaEdgesThatAreProvided()
    }
    
    func setupKeyboardAvoiding() {
        // TODO: Implement
//        NotificationCenter.default.addObserver(self, selector: #selector(tpKeyboardAvoiding_keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(tpKeyboardAvoiding_keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(tpKeyboardAvoiding_scrollToActiveTextField), name: UITextView.textDidBeginEditingNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(tpKeyboardAvoiding_scrollToActiveTextField), name: UITextField.textDidBeginEditingNotification, object: nil)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard isKeyboardAvoiding else { return }
//        tpKeyboardAvoiding_findFirstResponderBeneathView(self)?.resignFirstResponder()
    }
}

// MARK: Updatable
public extension TFScrollView {
    
    func update(with viewModel: ViewModel?) {
        self.viewModel = viewModel
    }
}

// MARK: Actions
@objc private extension TFScrollView {
    
    func didTapScrollView() {
        parentViewController?.view.endEditing(true)
    }
}

// MARK: Private update methods
private extension TFScrollView {
    
    func renderViewModel() {
        guard let viewModel = viewModel else {
            subviews.forEach({ $0.removeFromSuperview() })
            return
        }
        let containerView = TFViewContainer(with: makeView(for: viewModel))
        setup(with: containerView, axis: viewModel.axis)
        self.containerView = containerView
    }
    
    func setInsetsWithSafeAreaEdgesThatAreProvided() {
        guard let containerView = containerView else { return }
        containerView.insets = insets + tfSafeAreaInsets.filtered(by: adjustContentForSafeAreaEdges)
    }
    
    private func makeView(for viewModel: ViewModel) -> UIView {
        let stackView = UIStackView()
        stackView.axis = viewModel.axis
        stackView.spacing = 0
        stackView.set(elements: viewModel.views)
        return stackView
    }
}

// MARK: Private setup methods
private extension TFScrollView {
    
    func setup() {
        backgroundColor = .clear
        if isKeyboardAvoiding { setupKeyboardAvoiding() }
        contentSizeObservation = observe(\.contentSize, changeHandler: { [weak self] _, _ in
            guard let self = self, !self.didManuallySetDelaysContentTouches else { return }
            self.delaysContentTouches = self.canScrollVertically
            self.didManuallySetDelaysContentTouches = false
        })
    }
}

public extension TFScrollView {
    
    /**
     - parameter content: The view(s) to stack in the scrollView
     - parameter axis: The direction in which the scrollView will stack it's content. Content will be stretched across the perpendicular axis.
     - parameter insets: The insets of the content within the scrollView. These will be accumulated with the given safe area insets from edges included in adjustContentForSafeAreaEdges. Defaults to .pageDefault, which is what almost every page in the app uses.
     - parameter adjustContentForSafeAreaEdges: The safe area edges to which the content will adjust (with contentInset). Defaults to .all, which is generally what you want for a regular layout.
     */
    struct ViewModel: Equatable {
        let views: [UIStackView.Element]
        let axis: TFAxis
        let insets: UIEdgeInsets
        let adjustContentForSafeAreaEdges: TFInsetEdges
        
        init(views: [UIStackView.Element], axis: TFAxis = .vertical, insets: UIEdgeInsets = .zero, adjustContentForSafeAreaEdges: TFInsetEdges = .all) {
            self.views = views
            self.axis = axis
            self.insets = insets
            self.adjustContentForSafeAreaEdges = adjustContentForSafeAreaEdges
        }
    }
}
