//
//  RatesTableViewModelTests.swift
//  RatesTests
//
//  Created by Diomidis Papas on 15/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import XCTest
@testable import Rates

class RatesTableViewModelTests: XCTestCase {
    
    private let currencies = [
        Currency(code: "EUR"),
        Currency(code: "USD"),
        Currency(code: "GBP")
    ]
    
    private let money = Money(amount: 100, currency: Currency(code: "EUR"))
    
    private let localClient = LocalClient(resource: Resources.rates, filepath: "rates_response.json")
    
    private lazy var typeErasedRemoteRequestExecutable: AnyRemoteRequestExecutable  = {
        return AnyRemoteRequestExecutable(remoteRequestExecutable: localClient)
    }()
    
    private lazy var exchanger: Exchanger = {
        return Exchanger(client: typeErasedRemoteRequestExecutable)
    }()
    
    private let firstIndexPath = IndexPath(row: 0, section: 0)

    func testRatesTableViewModel_validInitialization() {
        let viewModel = RatesTableViewModel(currencies: currencies, money: money, exchanger: exchanger)
        XCTAssertNotNil(viewModel)
    }
    
    func testRatesTableViewModel_hasValidNumberOfItems() {
        let viewModel = RatesTableViewModel(currencies: currencies, money: money, exchanger: exchanger)
        let expectedNumberOfItems = currencies.count
        XCTAssertEqual(viewModel.numberOfItems, expectedNumberOfItems)
    }
    
    func testRatesTableViewModel_hasValidDataSource_forBaseCurrency() {
        let viewModel = RatesTableViewModel(currencies: currencies, money: money, exchanger: exchanger)
        let dataSource: RateTableViewCellDataSource = viewModel.dataSource(for: firstIndexPath)

        XCTAssertEqual(dataSource.title, "EUR")
        XCTAssertEqual(dataSource.subtitle, "Euro")
        XCTAssertEqual(dataSource.rate, "100")
        XCTAssertEqual(dataSource.ratePlaceholder, "0")
        XCTAssertEqual(dataSource.rateUnderlineColor, .blue)
        XCTAssertEqual(dataSource.ratePlaceholderColor, .lightGray)
    }
    
    func testRatesTableViewModel_hasValidDataSource_forExchangeCurrencyWithValidAmount() {
        let viewModel = RatesTableViewModel(currencies: currencies, money: money, exchanger: exchanger)
        let secondIndexPath = IndexPath(row: 1, section: 0)
        let dataSource: RateTableViewCellDataSource = viewModel.dataSource(for: secondIndexPath)
        
        XCTAssertEqual(dataSource.title, "USD")
        XCTAssertEqual(dataSource.subtitle, "US Dollar")
        XCTAssertEqual(dataSource.rate, "117.53")
        XCTAssertEqual(dataSource.ratePlaceholder, "0")
        XCTAssertEqual(dataSource.rateUnderlineColor, .lightGray)
        XCTAssertEqual(dataSource.ratePlaceholderColor, .lightGray)
    }
    
    func testRatesTableViewModel_hasZeroRate_forExchangeCurrencyWithZeroAmount() {
        let zeroMoney = Money(amount: 0, currency: Currency(code: "EUR"))
        let viewModel = RatesTableViewModel(currencies: currencies, money: zeroMoney, exchanger: exchanger)
        let dataSource: RateTableViewCellDataSource = viewModel.dataSource(for: firstIndexPath)
        XCTAssertEqual(dataSource.rate, "0")
    }
    
    func testRatesTableViewModel_receivesDelegateCallback_forAmountUpdates() {
        let viewModel = RatesTableViewModel(currencies: currencies, money: money, exchanger: exchanger)
        let mockDelegate = MockRatesTableViewModelDelegate()
        viewModel.delegate = mockDelegate
        let delegateExpecation = expectation(description: #function)
        mockDelegate.callback = { [weak delegateExpecation] diff in
            delegateExpecation?.fulfill()
            delegateExpecation = nil
        }
        viewModel.update(with: "99", at: firstIndexPath)
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

final private class MockRatesTableViewModelDelegate: RatesTableViewModelDelegate {

    var callback: ((RatesTableViewDiff) -> Void)?
    
    func ratesTableViewModel(_: RatesTableViewModel, didRequestUpdateWith diff: RatesTableViewDiff) {
        callback?(diff)
    }
}
