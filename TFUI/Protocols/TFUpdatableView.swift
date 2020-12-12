//
//  TFUpdatableView.swift
//  TFUI
//
//  Created by Kevin van den Hoek on 12/12/2020.
//

import UIKit

public protocol UpdatableView: UIView, Updatable, AnyUpdatable, Instantiable {
    
}

public protocol AnyUpdatable {
    
    func updateWithObject(_ any: Any)
}

public extension UpdatableView {
    
    func updateWithObject(_ any: Any) {
        guard let viewModel = any as? ViewModel else { return }
        update(with: viewModel)
    }
}

public protocol Updatable: Reusable {
    
    associatedtype ViewModel: Equatable
    
    func update(with viewModel: ViewModel?)
}

public extension Updatable {
    
    func prepareForReuse() {
        update(with: nil)
    }
}

public protocol Instantiable {
    
    init()
}

public protocol Reusable {
    
    func prepareForReuse()
}
