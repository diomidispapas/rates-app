//
//  Exchanger.swift
//  Rates
//
//  Created by Diomidis Papas on 14/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

protocol ExchangerDelegate: class {
    func exchanger(_: Exchanger, didUpdate rates: [ExchangeRate])
    func exchanger(_: Exchanger, didOccur error: Error)
}

extension ExchangerDelegate {
    func exchanger(_: Exchanger, didOccur error: Error) { }
}

enum ExchangerError: Error {
    case exchangeRateNotExist
}

final class Exchanger {
    
    weak var delegate: ExchangerDelegate?
    
    private(set) var baseCurrency: Currency?
    
    private var exchangeRates: Set<ExchangeRate> = Set()
    
    private var timer = Timer()
    
    private var client: AnyRemoteRequestExecutable<RatesResponse>
    
    private let updateInterval = 1.0
    
    // MARK: Initialization

    init(client: AnyRemoteRequestExecutable<RatesResponse>) {
        self.client = client
    }
    
    deinit {
        timer.invalidate()
    }

    // MARK: Public
    
    func updateRates() {
        client.execute { [weak self] (response, error) in
            guard let `self` = self else { return }
            if let response = response {
                self.handle(ratesResponse: response)
            }
            
            if let error = error {
                self.handle(error: error)
            }
        }
    }
    
    func startUpdates() {
        updateRates()
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: { [weak self] _ in
            self?.updateRates()
        })
    }
    
    func stopUpdates() {
        timer.invalidate()
    }
    
    func exchange(money: Money, in currency: Currency) throws -> Money {
        let currentExchangeRates = exchangeRates.filter {
            return ($0.currencyOne == money.currency && $0.currencyTwo == currency) || ($0.currencyTwo == money.currency && $0.currencyOne == currency)
        }
        
        guard let currentExchangeRate = currentExchangeRates.first else {
            if money.currency == baseCurrency {
                return Money(amount: money.money.amount.doubleValue, currency: currency)
            } else {
                throw ExchangerError.exchangeRateNotExist
            }
        }
        
        if currentExchangeRate.currencyOne == money.currency {
            return Money(amount: money.money.amount.doubleValue * currentExchangeRate.rate, currency: currency)
        } else{
            return Money(amount: money.money.amount.doubleValue * currentExchangeRate.inverseRate, currency: currency)
        }
    }

    // MARK: Private
    
    private func handle(ratesResponse response: RatesResponse) {
        let rates = response.rates
        baseCurrency = response.baseCurrency
        exchangeRates = Set(rates)
        delegate?.exchanger(self, didUpdate: response.rates)
    }
    
    private func handle(error: Error) {
        delegate?.exchanger(self, didOccur: error)
    }
}
