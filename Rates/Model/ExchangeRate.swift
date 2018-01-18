//
//  ExchangeRate.swift
//  Rates
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

struct ExchangeRate: Hashable {
    let currencyOne: Currency
    let currencyTwo: Currency
    let rate: Double
    
    var inverseRate: Double {
        return 1 / rate
    }
    
    var hashValue: Int {
        return currencyOne.hashValue ^ currencyTwo.hashValue ^ rate.hashValue
    }
}

extension ExchangeRate: Equatable {
    static func ==(lhs: ExchangeRate, rhs: ExchangeRate) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
