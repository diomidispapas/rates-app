//
//  ErrorClient.swift
//  RatesTests
//
//  Created by Diomidis Papas on 15/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation
@testable import Rates

enum ErrorClientError: Error {
    case `default`
}

struct ErrorClient<T>: RemoteRequestExecutable {
    
    let error: Error
    
    // MARK: Initialization
    
    init(resource: Resource<T>, error: Error) {
        self.resource = resource
        self.error = error
    }
    
    // MARK: RemoteRequestExecutable
    
    let resource: Resource<T>
    
    func execute(with completionHandler: @escaping (T?, Error?) -> Void) {
        completionHandler(nil, self.error)
    }
}

