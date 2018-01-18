//
//  Log.swift
//  Rates
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

public enum Log {
    case ln(_: String)
    case url(_: String)
    case urlRequest(_: URLRequest)
    case urlResponse(_: URLResponse)
    case error(_: NSError)
    case date(_: Date)
    case obj(_: Any)
    case other(_: Any)
}

// Using the postfix operation in order to basically enable/disable a Log.
postfix operator /

postfix public func / (target: Log?) {
    guard let target = target else { return }
    
    func log<T>(_ emoji: String, _ object: T) {
        #if DEBUG
            print(emoji + " " + String(describing: object))
        #endif
    }
    
    switch target {
    case .ln(let line):
        log("✏️", line)
        
    case .url(let url):
        log("🌏", url)
        
    case .urlRequest(let urlRequest):
        log("🌏👆", urlRequest)
        
    case .urlResponse(let urlResponse):
        log("🌏👇", urlResponse)
        
    case .error(let error):
        log("❗️", error)
        
    case .other(let any):
        log("⚪️", any)
        
    case .obj(let obj):
        log("◽️", obj)
        
    case .date(let date):
        log("🕒", date)
    }
}
