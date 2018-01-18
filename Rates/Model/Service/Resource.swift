//
//  Resource.swift
//  Rates
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

struct Resource<A> {
    let urlRequest: URLRequest
    let parse: (Data) -> A?
}

extension Resource where A: Decodable  {
    init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
        self.parse = { data in
            let decoder = JSONDecoder()
            return try! decoder.decode(A.self, from: data)
        }
    }
}

