//
//  TFSpacer.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

import Foundation
import UIKit
import EasyPeasy

open class TFSpacer: UIView, UpdatableView {
    
    // MARK: Lifecycle
    public convenience init(_ size: CGFloat) {
        self.init(frame: .zero)
        easy.layout(
            Size(size).with(.medium)
        )
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

public extension TFSpacer {
    
    func update(with viewModel: ViewModel?) {
        easy.clear()
        guard let viewModel = viewModel else { return  }
        switch viewModel {
        case .size(let amount):
            easy.layout(
                Size(amount).with(.medium)
            )
        }
    }
}

// MARK: Setup
private extension TFSpacer {
    
    func setup() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
}

public extension TFSpacer {
    
    enum ViewModel: Equatable {
        case size(_ amount: CGFloat)
    }
}
