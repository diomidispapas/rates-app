//
//  Resourses.swift
//  Rates
//
//  Created by Diomidis Papas on 15/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

struct Resources {
    static let rates: Resource<RatesResponse> = {
        let urlRequest = URLRequest(url: URL(string: "https://revolut.duckdns.org/latest?base=EUR")!)
        return Resource<RatesResponse>(urlRequest: urlRequest)
    }()
}
