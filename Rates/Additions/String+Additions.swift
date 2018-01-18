//
//  String+Additions.swift
//  Rates
//
//  Created by Diomidis Papas on 14/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

extension String {
    
    private static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        return formatter
    }()
    
    func isValidDecimal(maximumFractionDigits: Int) -> Bool {
        
        guard self.isEmpty == false else {
            return true
        }
        
        if self.count == 1 && self == "." {
            return true
        }
        
        if (String.decimalFormatter.number(from: self) != nil) {
            
            let numberComponents = self.components(separatedBy: ".")
            let fractionDigits = numberComponents.count == 2 ? numberComponents.last ?? "" : ""
            return fractionDigits.count <= maximumFractionDigits
        }
        return false
    }
}
