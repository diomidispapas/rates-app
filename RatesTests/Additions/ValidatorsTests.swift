//
//  ValidatorsTests.swift
//  RatesTests
//
//  Created by Diomidis Papas on 15/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import XCTest
@testable import Rates

class ValidatorsTests: XCTestCase {
    
    func testIsDecimalWithPercisionTwoValidator_withSingleNumber_isValid() {
        XCTAssert(isDecimalWithPercisionTwo(text: "1"))
    }
    
    func testIsDecimalWithPercisionTwoValidator_withOneDecimalNumber_isValid() {
        XCTAssert(isDecimalWithPercisionTwo(text: "1.1"))
    }
    
    func testIsDecimalWithPercisionTwoValidator_withTowDecimalNumber_isValid() {
        XCTAssert(isDecimalWithPercisionTwo(text: "1.12"))
    }
    
    func testIsDecimalWithPercisionTwoValidator_withThreeDecimalNumber_isNotValid() {
        XCTAssert(!isDecimalWithPercisionTwo(text: "1.123"))
    }

    func testIsDecimalWithPercisionTwoValidator_withDecimalAndSingleDot_isValid() {
        XCTAssert(isDecimalWithPercisionTwo(text: ".1"))
    }
    
    func testIsDecimalWithPercisionTwoValidator_emptyString_isValid() {
        XCTAssert(isDecimalWithPercisionTwo(text: ""))
    }
    
    func testIsDecimalWithPercisionTwoValidator_dot_isValid() {
        XCTAssert(isDecimalWithPercisionTwo(text: "."))
    }
}
