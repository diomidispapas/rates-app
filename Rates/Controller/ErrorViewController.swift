//
//  ErrorViewController.swift
//  Rates
//
//  Created by Diomidis Papas on 15/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import UIKit

final class ErrorViewController: UIViewController {
    
    private let options: ErrorOptions
    
    // MARK: Initialization
    
    init(options: ErrorOptions) {
        self.options = options
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    
    override func loadView() {
        view = ErrorView(options: options)
    }
}
