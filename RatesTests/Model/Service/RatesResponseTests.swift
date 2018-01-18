//
//  RatesResponseTests.swift
//  RatesTests
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import XCTest
@testable import Rates

class RatesResponseTests: XCTestCase {
    
    let ratesResponseData: Data = FileReader().read(from: "rates_response.json")!

    func testRatesResponseDecoding_withValidInputData_isNotNil() {
        let decoder = JSONDecoder()
        let ratesResponse = try? decoder.decode(RatesResponse.self, from: ratesResponseData)
        XCTAssertNotNil(ratesResponse)
    }
    
    func testRatesResponseDecoding_withValidInputData_hasValidBaseCurrency() {
        let decoder = JSONDecoder()
        let ratesResponse = try? decoder.decode(RatesResponse.self, from: ratesResponseData)
        let expectedBaseCurrency = Currency(code: "EUR")
        XCTAssertEqual(ratesResponse?.baseCurrency, expectedBaseCurrency)
    }
    
    func testRatesResponseDecoding_withValidInputData_hasNonNilRates() {
        let decoder = JSONDecoder()
        let ratesResponse = try? decoder.decode(RatesResponse.self, from: ratesResponseData)
        XCTAssertNotNil(ratesResponse?.rates)
    }
    
    func testRatesResponseDecoding_withValidInputData_hasCorrectNumberOfRates() {
        let decoder = JSONDecoder()
        let ratesResponse = try? decoder.decode(RatesResponse.self, from: ratesResponseData)
        XCTAssertEqual(ratesResponse?.rates.count, 31)
    }
}
