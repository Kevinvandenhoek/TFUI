//
//  ViewController.swift
//  TFUI
//
//  Created by kevinvandenhoek@gmail.com on 12/12/2020.
//  Copyright (c) 2020 kevinvandenhoek@gmail.com. All rights reserved.
//

import UIKit
import EasyPeasy
import TFUI

class ViewController: UIViewController {
    
    let scrollView = TFScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.fill(with: scrollView)
        scrollView.insets = .all(20)
        scrollView.views = [
            .view(UILabel("title", size: 42)),
            .space(10),
            .view(UILabel("subtitle", size: 32)),
            .space(30),
            .view(UILabel(bodyText, size: 20)),
            .space(30),
            .view(UILabel(bodyText, size: 20))
        ]
    }
}

private extension ViewController {
    
    var bodyText: String {
        return "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    }
}

private extension UILabel {
    
    convenience init(_ text: String, size: CGFloat) {
        self.init()
        self.text = text
        self.font = .systemFont(ofSize: size)
        self.numberOfLines = 0
    }
}
