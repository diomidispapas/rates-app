//
//  FileReader.swift
//  RatesTests
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

final class FileReader {    
    func read(from path: String) -> Data? {
        let testBundle = Bundle(for: FileReader.self)
        let components = path.split(separator: ".")
        assert(components.count == 2)
        let resource = String(describing: components[0])
        let filetype = String(components[1])
        let filepath = testBundle.path(forResource: resource, ofType: filetype)
        let urlFilepath = URL(fileURLWithPath: filepath!)
        return try? Data(contentsOf: urlFilepath)
    }
}
