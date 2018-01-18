//
//  LoadingView.swift
//  Rates
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import UIKit

final class LoadingView: UIView {
    
    var loading = false {
        didSet {
            configure(for: loading)
        }
    }
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViewHierarchy()
        setupConstraints()
        setupDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private func buildViewHierarchy() {
        addSubview(activityIndicatorView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([            
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    private func setupDefaults() {
        backgroundColor = .white
    }
    
    private func configure(for loading: Bool) {
        switch loading {
        case true:
            activityIndicatorView.startAnimating()
        case false:
            activityIndicatorView.stopAnimating()
        }
    }
}
