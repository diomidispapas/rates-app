//
//  RatesContainerViewModel.swift
//  Rates
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

protocol RatesContainerViewModelDelegate: class {
    func ratesContainerViewModel(_ : RatesContainerViewModel, didChange state: ViewState<([Currency], Money, Exchanger)>)
}

final class RatesContainerViewModel {
    
    weak var delegate: RatesContainerViewModelDelegate?

    var state: ViewState<([Currency], Money, Exchanger)> = .loading {
        didSet {
            handle(state: state)
        }
    }
    
    private let exchanger: Exchanger
    
    // MARK: Initialization

    init(exchanger: Exchanger) {
        self.exchanger = exchanger
    }
    
    // MARK: Public
    
    func fetchData() {
        state = .loading
        exchanger.delegate = self
        exchanger.updateRates()
    }
    
    // MARK: Private

    private func handle(state: ViewState<([Currency], Money, Exchanger)>) {
        delegate?.ratesContainerViewModel(self, didChange: state)
    }
    
    private func handle(rates: [ExchangeRate]) {
        
        let rhsCurrencies = rates.map { $0.currencyOne }
        let lhsCurrencies = rates.map { $0.currencyTwo }
        let currencies = rhsCurrencies + lhsCurrencies 
        let uniqueCurrencies = Array(Set(currencies))
        
        guard let base = exchanger.baseCurrency else { fatalError() }
        let money = Money(amount: 100, currency: base)

        state = .loaded((uniqueCurrencies, money, exchanger))
    }
}

extension RatesContainerViewModel: ExchangerDelegate {
    func exchanger(_: Exchanger, didOccur error: Error) {
        state = .error(error)
    }
    
    func exchanger(_: Exchanger, didUpdate rates: [ExchangeRate]) {
        handle(rates: rates)
    }
}


