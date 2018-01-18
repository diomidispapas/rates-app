//
//  Validatable.swift
//  Rates
//
//  Created by Diomidis Papas on 14/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import UIKit

protocol Validatable {
    associatedtype T
    func validate(_ functions: [(T) -> Bool]) -> Bool
}

typealias Validator = (String) -> Bool
extension String: Validatable {
    func validate(_ functions: [Validator]) -> Bool {
        return functions.map { f in f(self) }
            .reduce(true) { $0 && $1 }
    }
}
