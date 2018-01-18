//
//  MoneyTests.swift
//  RatesTests
//
//  Created by Diomidis Papas on 14/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import XCTest
@testable import Rates

class MoneyTests: XCTestCase {
    
    private let euro = Currency(code: "EUR")
    private let usd = Currency(code: "USD")
    private let gbp = Currency(code: "GBP")

    func testMoney_validInitialization() {
        let money = Money(amount: 100, currency: euro)
        XCTAssertNotNil(money)
    }
    
    func testMoney_areEqual_whenHavingTheSameAmountAndCurrency() {
        let money1 = Money(amount: 100, currency: euro)
        let money2 = Money(amount: 100, currency: euro)
        XCTAssertEqual(money1, money2)
    }
    
    func testMoney_areNotEqual_whenHavingTheSameAmountAndDifferentCurrency() {
        let money1 = Money(amount: 100, currency: euro)
        let money2 = Money(amount: 100, currency: usd)
        XCTAssertNotEqual(money1, money2)
    }
    
    func testMoney_areNotEqual_whenHavingDifferentAmountAndSameCurrency() {
        let money1 = Money(amount: 100, currency: euro)
        let money2 = Money(amount: 101, currency: euro)
        XCTAssertNotEqual(money1, money2)
    }
}
