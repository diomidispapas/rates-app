//
//  RatesResponse.swift
//  Rates
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

struct RatesResponse: Decodable {
    let updatedDate: Date
    let baseCurrency: Currency
    let rates: [ExchangeRate]
    
    private enum CodingKeys: String, CodingKey {
        case updatedDate = "date"
        case baseCurrency = "base"
        case rates
    }
    
    // MARK: Decodable
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let dateString = try container.decode(String.self, forKey: .updatedDate)
        let formatter = DateFormatter.yyyyMMdd
        if let date = formatter.date(from: dateString) {
            updatedDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .updatedDate,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
        
        let baseCurrencyString = try container.decode(String.self, forKey: .baseCurrency)
        let base = Currency(code: baseCurrencyString)
        baseCurrency = base        
        let ratesDictionary = try container.decode(Dictionary<String, Double>.self, forKey: .rates)
        rates = ratesDictionary.map({ (key, value) -> ExchangeRate in
            let currency = Currency(code: key)
            return ExchangeRate(currencyOne: base, currencyTwo: currency, rate: value)
        })
    }
}
