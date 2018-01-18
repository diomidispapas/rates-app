//
//  ExchangerTests.swift
//  RatesTests
//
//  Created by Diomidis Papas on 15/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

import XCTest
@testable import Rates

class ExchangerTests: XCTestCase {
    
    private let euro = Currency(code: "EUR")
    private let usd = Currency(code: "USD")
    private let gbp = Currency(code: "GBP")
    
    private let localClient = LocalClient(resource: Resources.rates, filepath: "rates_response.json")
    
    func testExchanger_validInitialization() {
        let typeErasedRemoteRequestExecutable = AnyRemoteRequestExecutable(remoteRequestExecutable: localClient)
        let exchanger = Exchanger(client: typeErasedRemoteRequestExecutable)
        XCTAssertNotNil(exchanger)
    }
    
    func testExchanger_hasValidExchangeAmount_whenExchangeRateExists() {
        let typeErasedRemoteRequestExecutable = AnyRemoteRequestExecutable(remoteRequestExecutable: localClient)
        let exchanger = Exchanger(client: typeErasedRemoteRequestExecutable)
        exchanger.startUpdates()

        let euroMoney = Money(amount: 100, currency: euro)
        let usdMoney = try! exchanger.exchange(money: euroMoney, in: usd)

        let expectedUsdAmount: Double = 117.53
        XCTAssertEqual(usdMoney.amount, expectedUsdAmount)
    }
    
    func testExchanger_hasValidExchangeAmount_whenInvertedExchangeRateExists() {
        let typeErasedRemoteRequestExecutable = AnyRemoteRequestExecutable(remoteRequestExecutable: localClient)
        let exchanger = Exchanger(client: typeErasedRemoteRequestExecutable)
        exchanger.startUpdates()
        
        let usdMoney = Money(amount: 100, currency: usd)
        let euroMoney = try! exchanger.exchange(money: usdMoney, in: euro)
        
        let expectedEuroAmount: Double = 85.08
        XCTAssertEqual(euroMoney.amount, expectedEuroAmount)
    }

    func testExchanger_throwsError_whenExchangeRateDoesNotExist() {
        let typeErasedRemoteRequestExecutable = AnyRemoteRequestExecutable(remoteRequestExecutable: localClient)
        let exchanger = Exchanger(client: typeErasedRemoteRequestExecutable)
        exchanger.startUpdates()

        let gbpMoney = Money(amount: 100, currency: gbp)
        XCTAssertThrowsError(try exchanger.exchange(money: gbpMoney, in: usd))
    }
    
    func testExchanger_throwsError_whenExchangeRateDoesHasNoExchangeRates() {
        let typeErasedRemoteRequestExecutable = AnyRemoteRequestExecutable(remoteRequestExecutable: localClient)
        let exchanger = Exchanger(client: typeErasedRemoteRequestExecutable)        
        let gbpMoney = Money(amount: 100, currency: gbp)
        XCTAssertThrowsError(try exchanger.exchange(money: gbpMoney, in: usd))
    }
    
    func testExchanger_receivesDelegateCallbacks_whenUpdatingExchangeRates() {
        let typeErasedRemoteRequestExecutable = AnyRemoteRequestExecutable(remoteRequestExecutable: localClient)
        let exchanger = Exchanger(client: typeErasedRemoteRequestExecutable)
        let delegateExpecation = expectation(description: #function)
        let mockDelegate = MockExchangeDelegate()
        mockDelegate.callback = { [weak delegateExpecation] rates in
            XCTAssertNotNil(rates)
            XCTAssert(rates.count == 31)
            delegateExpecation?.fulfill()
        }
        exchanger.delegate = mockDelegate
        exchanger.startUpdates()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

final private class MockExchangeDelegate: ExchangerDelegate {
    
    var callback: (([ExchangeRate]) -> Void)?
    
    func exchanger(_: Exchanger, didUpdate rates: [ExchangeRate]) {
        callback?(rates)
    }
}

