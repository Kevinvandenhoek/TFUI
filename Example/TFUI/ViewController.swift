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
        view.addSubview(scrollView)
        scrollView.easy.layout(Edges())
        scrollView.backgroundColor = .orange
    }
}
