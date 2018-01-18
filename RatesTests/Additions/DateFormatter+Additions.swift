//
//  DateFormatter+Additions.swift
//  RatesTests
//
//  Created by Diomidis Papas on 15/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import XCTest
@testable import Rates

class DateFormatterAdditionsTests: XCTestCase {
    
    func testyyyyMMddFormatted_withValidInput_isNotNil() {
        let formatter = DateFormatter.yyyyMMdd
        let dateString = "2017-12-15"
        let date = formatter.date(from: dateString)
        XCTAssertNotNil(date)
    }
    
    func testyyyyMMddFormatted_withInValidInput_isNil() {
        let formatter = DateFormatter.yyyyMMdd
        let dateString = "2017-12-15-15"
        let date = formatter.date(from: dateString)
        XCTAssertNil(date)
    }
    
    func testyyyyMMddFormatted_withValidInput_hasValidOutputDate() {
        let formatter = DateFormatter.yyyyMMdd
        let dateString = "2017-12-15"
        let date = formatter.date(from: dateString)
        
        // https://www.unixtimestamp.com/index.php
        // 1513296000 = 12/15/2017 @ 12:00am (UTC)
        let expectedDate = Date(timeIntervalSince1970: 1513296000)
        XCTAssertEqual(date, expectedDate)
    }
}

