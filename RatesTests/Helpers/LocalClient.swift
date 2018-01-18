//
//  LocalClient.swift
//  RatesTests
//
//  Created by Diomidis Papas on 15/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation
@testable import Rates

enum LocalClientError: Error {
    case failed
}

struct LocalClient<T>: RemoteRequestExecutable {
    
    let filepath: String
    
    // MARK: Initialization
    
    init(resource: Resource<T>, filepath: String) {
        self.resource = resource
        self.filepath = filepath
    }
    
    // MARK: RemoteRequestExecutable

    let resource: Resource<T>
    
    func execute(with completionHandler: @escaping (T?, Error?) -> Void) {
        if let data = FileReader().read(from: filepath) {
            completionHandler(resource.parse(data), nil)
        } else {
            completionHandler(nil, LocalClientError.failed)
        }
    }
}
