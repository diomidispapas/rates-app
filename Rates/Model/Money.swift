//
//  Money.swift
//  Rates
//
//  Created by Diomidis Papas on 14/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

struct Money {
    
    var money: (amount: NSDecimalNumber, currency: Currency)
    
    private static let decimalHandler = NSDecimalNumberHandler(roundingMode: .down, scale: 2, raiseOnExactness: true, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
    
    // MARK: Initialization
    
    init(amount: Double, currency: Currency) {
        money = (NSDecimalNumber(value: amount), currency)
    }

    // MARK: Accessors
    
    var amount: Double {
        return money.amount.rounding(accordingToBehavior: Money.decimalHandler).doubleValue
    }
    
    var currency: Currency {
        return money.currency
    }
}

extension Money: CustomStringConvertible {
    var description: String {
        let amount = money.amount.rounding(accordingToBehavior: Money.decimalHandler)
        return "\(amount) \(money.currency)"
    }
}

extension Money: Equatable {
    static func ==(lhs:Money, rhs:Money)->Bool{
        if lhs.money.amount.compare(rhs.money.amount) == .orderedSame &&
            lhs.currency == rhs.currency {
            return true
        }
        return false
    }
}
