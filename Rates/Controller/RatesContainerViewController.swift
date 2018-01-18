//
//  RatesContainerViewController.swift
//  Rates
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import UIKit

final class RatesContainerViewController: UIViewController {
    
    private let viewModel: RatesContainerViewModel
    
    private var activeViewController: UIViewController? {
        didSet {
            remove(viewController: oldValue)
            activate(viewController: activeViewController)
        }
    }
    
    // MARK: Initialization
    
    init(viewModel: RatesContainerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private func setupDefaults() {
        view.backgroundColor = .white
        viewModel.delegate = self
        viewModel.fetchData()
    }
    
    private func handle(state: ViewState<([Currency], Money, Exchanger)>) {
        assert(Thread.isMainThread)
        switch state {
        case .loading:
            activeViewController = LoadingViewController(nibName: nil, bundle: nil)
            
        case let .loaded(currencies, money, exchanger):
            let ratesTableViewModel = RatesTableViewModel(currencies: currencies, money: money, exchanger: exchanger)
            let ratesTableViewController = RatesTableViewController(viewModel: ratesTableViewModel)
            let navigationController = UINavigationController(rootViewController: ratesTableViewController)
            activeViewController = navigationController
            
        case let .error(error):
            let options = errorOptions(for: error)
            activeViewController = ErrorViewController(options: options)
        }
    }
    
    private func activate(viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        addChildViewController(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        title = viewController.title
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func remove(viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    private func errorOptions(for error: Error) -> ErrorOptions {
        switch error {
        case URLError.badServerResponse:
            return ErrorOptions.internal(action: retry)
        case URLError.cannotConnectToHost, URLError.notConnectedToInternet:
            return ErrorOptions.disconnected(action: retry)
        default:
            return ErrorOptions.default(action: retry)
        }
    }
    
    private func retry() {
        viewModel.fetchData()
    }
}

extension RatesContainerViewController: RatesContainerViewModelDelegate {
    func ratesContainerViewModel(_: RatesContainerViewModel, didChange state: ViewState<([Currency], Money, Exchanger)>) {
        handle(state: state)
    }
}
