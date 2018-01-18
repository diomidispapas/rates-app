//
//  TextAttributes.swift
//  Rates
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import UIKit

enum TextAttributes {
    
    struct label {
        
        static func subtitle(with color: UIColor = .black) -> [NSAttributedStringKey: Any] {
            return [.foregroundColor: color as Any, .font: UIFont.systemFont(ofSize: 25)]
        }
        
        static func body(with color: UIColor = .black) -> [NSAttributedStringKey: Any] {
            return [.foregroundColor: color as Any, .font: UIFont.systemFont(ofSize: 20)]
        }
        
        static func caption(with color: UIColor = .lightGray) -> [NSAttributedStringKey: Any] {
            return [.foregroundColor: color as Any, .font: UIFont.systemFont(ofSize: 16)]
        }
    }
    
    struct textField {
        
        static func body(with color: UIColor = .black, underlineColor: UIColor = .gray) -> [NSAttributedStringKey: Any] {
            return [.foregroundColor: color as Any,
                    .font: UIFont.systemFont(ofSize: 20),
                    .underlineStyle: 1,
                    .underlineColor: underlineColor as Any
            ]
        }
    }
}
