//
//  Validators.swift
//  Rates
//
//  Created by Diomidis Papas on 14/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

func isDecimalWithPercisionTwo(text: String) -> Bool {
    return text.isValidDecimal(maximumFractionDigits: 2)
}
