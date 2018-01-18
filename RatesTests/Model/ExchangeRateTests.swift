//
//  ExchangeRateTests.swift
//  RatesTests
//
//  Created by Diomidis Papas on 14/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

import XCTest
@testable import Rates

class ExchangeRateTests: XCTestCase {
    
    private let euro = Currency(code: "EUR")
    private let usd = Currency(code: "USD")
    private let gbp = Currency(code: "GBP")

    func testExchangeRate_validInitialization() {
        let eur_usd = ExchangeRate(currencyOne: euro, currencyTwo: usd, rate: 1.1167)
        XCTAssertNotNil(eur_usd)
    }
    
    func testExchangeRate_areEqual_whenHavingTheSameCurrencyAndSameRate() {
        let eur_usd = ExchangeRate(currencyOne: euro, currencyTwo: usd, rate: 1.13)
        let eur_usd2 = ExchangeRate(currencyOne: euro, currencyTwo: usd, rate: 1.13)
        XCTAssertEqual(eur_usd, eur_usd2)
    }
    
    func testExchangeRate_areNotEqual_whenHavingTheSameRateAndDifferentCurrency() {
        let eur_usd = ExchangeRate(currencyOne: euro, currencyTwo: usd, rate: 1.13)
        let eur_gbp = ExchangeRate(currencyOne: euro, currencyTwo: gbp, rate: 1.13)
        XCTAssertNotEqual(eur_usd, eur_gbp)
    }
    
    func testExchangeRate_areNotEqual_whenHavingTheSameCurrencyAndDifferentRate() {
        let eur_usd = ExchangeRate(currencyOne: euro, currencyTwo: usd, rate: 1.13)
        let eur_usd2 = ExchangeRate(currencyOne: euro, currencyTwo: usd, rate: 1.131)
        XCTAssertNotEqual(eur_usd, eur_usd2)
    }
    
    func testExchangeRate_isHavingCorrectInvertedRate() {
        let eur_usd = ExchangeRate(currencyOne: euro, currencyTwo: usd, rate: 1.21)
        let usd_eur_rate = eur_usd.inverseRate
        let expectedInvertedRate = 0.82
        XCTAssertEqual(usd_eur_rate, expectedInvertedRate, accuracy: 0.01)
    }
}
