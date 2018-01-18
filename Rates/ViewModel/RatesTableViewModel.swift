//
//  RatesTableViewModel.swift
//  Rates
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import UIKit

typealias RatesTableViewDiff = [IndexPath]
protocol RatesTableViewModelDelegate: class {
    func ratesTableViewModel(_: RatesTableViewModel, didRequestUpdateWith diff: RatesTableViewDiff)
}

final class RatesTableViewModel {
    
    weak var delegate: RatesTableViewModelDelegate?

    let title = NSLocalizedString("Rates & conversions", comment: "Rates & conversions")

    private let exchanger: Exchanger

    private var money: Money {
        didSet {
            handle(money: money)
        }
    }
    
    private var currencies: [Currency]
    
    // MARK: Initialization
    
    init(currencies: [Currency], money: Money, exchanger: Exchanger) {
        self.currencies = currencies
        self.money = money
        self.exchanger = exchanger
        setupDefaults()
    }
    
    deinit {
        exchanger.stopUpdates()
    }
    
    // MARK: Public
    
    var numberOfItems: Int {
        return currencies.count
    }
    
    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    func dataSource(for indexPath: IndexPath) -> RateTableViewCellDataSource {
        let currency = currencies[indexPath.row]
        let title = currency.code
        let subtitle = currency.name
        let exchange = try? exchanger.exchange(money: money, in: currency)
        let formattedAmount =  (exchange != nil) ? numberFormatter.string(for: exchange!.amount) : nil
        let isFirstRow = (indexPath.row == 0)
        let rateUnderlineColor = isFirstRow ? UIColor.blue : UIColor.lightGray
        
        return RateTableViewCellDataSource(title: title, subtitle: subtitle, rate: formattedAmount, rateUnderlineColor: rateUnderlineColor, ratePlaceholder: "0", ratePlaceholderColor: .lightGray)
    }
    
    func delegate(for indexPath: IndexPath) -> RateTableViewCellDelegate {
        let isFirstRow = (indexPath.row == 0)
        return RateTableViewCellDelegate(isEditable: isFirstRow, inputValidators: [isDecimalWithPercisionTwo])
    }
    
    func moveRate(from originalIndex: Int, to destinationIndex: Int) {
        let rate = currencies.remove(at: originalIndex)
        currencies.insert(rate, at: destinationIndex)
    }
    
    func update(with amount: String, at indexPath: IndexPath) {
        let currency = currencies[indexPath.row]
        let validatedAmount = amount.count > 0 ? Double(amount)! : 0.0
        let moneyToExchange = Money(amount: validatedAmount, currency: currency)
        guard let baseCurrency = exchanger.baseCurrency else { fatalError() }
        money = try! exchanger.exchange(money: moneyToExchange, in: baseCurrency)
        Log.ln(money.description)/
    }
    
    // MARK: Private
    
    private func setupDefaults() {
        exchanger.delegate = self
        exchanger.startUpdates()
    }
    
    private func handle(rates: [ExchangeRate]) {
        delegate?.ratesTableViewModel(self, didRequestUpdateWith: indexPathsToUpdate)
    }
    
    private func handle(money: Money) {
        delegate?.ratesTableViewModel(self, didRequestUpdateWith: indexPathsToUpdate)
    }
    
    private var indexPathsToUpdate: [IndexPath] {
        var indexPaths = [IndexPath]()        
        for index in 1..<currencies.count {
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        return indexPaths
    }
}

extension RatesTableViewModel: ExchangerDelegate {
    func exchanger(_: Exchanger, didUpdate rates: [ExchangeRate]) {
        handle(rates: rates)
    }
}
