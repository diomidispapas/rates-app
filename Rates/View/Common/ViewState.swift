//
//  ViewState.swift
//  Rates
//
//  Created by Diomidis Papas on 13/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import Foundation

enum ViewState<T> {
    case loading
    case loaded(T)
    case error(Error)
}
