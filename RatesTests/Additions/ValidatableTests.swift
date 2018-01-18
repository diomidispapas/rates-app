//
//  ValidatableTests.swift
//  RatesTests
//
//  Created by Diomidis Papas on 15/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import XCTest
@testable import Rates

class ValidatableTests: XCTestCase {
    
    func testValidatable_withSingleValidationFunction_isInvoked() {
        func validator(text: String) -> Bool {
            XCTAssert(true)
            return true
        }
        _ = "one".validate([validator])
    }
    
    func testValidatable_withTwoValidationFunction_isInvokedWithTheExpectedOutcome() {
       
        func validator1(text: String) -> Bool {
            XCTAssert(true)
            return false
        }
        
        func validator2(text: String) -> Bool {
            XCTAssert(true)
            return true
        }
        
        let outcome = "one".validate([validator1, validator2])
        let excpectedOutcome = false
        XCTAssertEqual(outcome, excpectedOutcome)
    }
}

