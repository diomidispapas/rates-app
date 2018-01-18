//
//  ErrorOptions.swift
//  Rates
//
//  Created by Diomidis Papas on 15/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

typealias ErrorOptionsAction = () -> Void

struct ErrorOptions {
    let title: String
    let message: String
    let actionTitle: String
    var action: ErrorOptionsAction?
    
    init(title: String = "Error", message: String = "Unexpected Error Occured", actionTitle: String = "Action", action: ErrorOptionsAction? = nil) {
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
}

extension ErrorOptions {
    static func `default`(action: @escaping ErrorOptionsAction) -> ErrorOptions {
        return ErrorOptions(title: "An error occured", message: "We are sorry, but an unexpected error occured, please try again", actionTitle: "Retry", action: action)
    }
    
    static func disconnected(action: @escaping ErrorOptionsAction) -> ErrorOptions {
        return ErrorOptions(title: "No internet connection", message: "It looks like you are not connected to the internet", actionTitle: "Retry", action: action)
    }
    
    static func `internal`(action: @escaping ErrorOptionsAction) -> ErrorOptions {
        return ErrorOptions(title: "Oops, ", message: "We are experiencing high demand right now, please try again later", actionTitle: "Retry", action: action)
    }
}
