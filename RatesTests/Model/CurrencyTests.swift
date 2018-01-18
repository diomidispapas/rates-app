//
//  CurrencyTests.swift
//  RatesTests
//
//  Created by Diomidis Papas on 15/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import XCTest
@testable import Rates

class CurrencyTests: XCTestCase {
    
    private let euro = Currency(code: "EUR")
    private let usd = Currency(code: "USD")
    private let gbp = Currency(code: "GBP")
    
    func testCurrency_validInitialization() {
        let euro = Currency(code: "EUR")
        XCTAssertNotNil(euro)
    }
    
    func testCurrency_haveTheSameHashValue_whenHavingTheSameCode() {
        let euro = "EUR"
        let currency1 = Currency(code: euro)
        let currency2 = Currency(code: euro)
        XCTAssertEqual(currency1.hashValue, currency2.hashValue)
    }
    
    func testCurrency_areEqual_whenHavingTheSameCode() {
        let euro = "EUR"
        let currency1 = Currency(code: euro)
        let currency2 = Currency(code: euro)
        XCTAssertEqual(currency1, currency2)
    }
    
    func testCurrency_areNotEqual_whenHavingTheSameCode() {
        let euro = "EUR"
        let usd = "USD"
        let currency1 = Currency(code: euro)
        let currency2 = Currency(code: usd)
        XCTAssertNotEqual(currency1, currency2)
    }
    
    func testCurrency_hasValidName_whenNameExists() {
        let euro = "EUR"
        let currency1 = Currency(code: euro)
        let expectedName = "Euro"
        XCTAssertEqual(currency1.name, expectedName)
    }
}
