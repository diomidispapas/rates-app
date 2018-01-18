//
//  Currency.swift
//  Rates
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import UIKit

struct Currency: Codable {
    let code: String
    
    private enum CodingKeys: String, CodingKey {
        case code = "base"
    }
}

extension Currency: Equatable {
    static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.code == rhs.code
    }
}

extension Currency: CustomStringConvertible {
    var description: String {
        return code
    }
}

extension Currency: Hashable {
    var hashValue: Int {
        return code.hashValue
    }
}

extension Currency {
    static let currencyNames: [String: String] = ["EUR": "Euro",
                                                  "THB": "Thai Baht",
                                                  "JPY": "Japanese Yen",
                                                  "DKK": "Danish Krone",
                                                  "AUD": "Australian Dollar",
                                                  "BGN": "Bulgarian Lev",
                                                  "BRL": "Brazilian Real",
                                                  "CAD": "Canadian Dollar",
                                                  "CHF": "Swiss Franc",
                                                  "CNY": "Chinese Yuan",
                                                  "CZK": "Czech Koruna",
                                                  "GBP": "British Pound",
                                                  "HKD": "Hong Kong Dollar",
                                                  "HRK": "Croatian Kuna",
                                                  "HUF": "Hungarian Forint",
                                                  "IDR": "Indonesian Rupiah",
                                                  "ILS": "Israeli New Shekel",
                                                  "INR": "Indian Rupee",
                                                  "KRW": "South Korean Won",
                                                  "MXN": "Mexican Peso",
                                                  "MYR": "Malaysian Ringgit",
                                                  "NOK": "Norwegian Krone",
                                                  "NZD": "New Zealand Dollar",
                                                  "PHP": "Philippine Peso",
                                                  "PLN": "Polish Zloty",
                                                  "RON": "Romanian Leu",
                                                  "RUB": "Russian Ruble",
                                                  "SEK": "Swedish Krona",
                                                  "SGD": "Singapore Dollar",
                                                  "TRY": "Turkish Lira",
                                                  "USD": "US Dollar",
                                                  "ZAR": "South African Rand"]
    
    var name: String? {        
        return Currency.currencyNames[code]
    }
}


