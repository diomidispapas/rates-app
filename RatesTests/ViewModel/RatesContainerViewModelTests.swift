//
//  RatesContainerViewModelTests.swift
//  RatesTests
//
//  Created by Diomidis Papas on 15/12/2017.
//  Copyright © 2017 Diomidis Papas. All rights reserved.
//

import XCTest
@testable import Rates

class RatesContainerViewModelTests: XCTestCase {
    
    private let localClient = LocalClient(resource: Resources.rates, filepath: "rates_response.json")
    
    private lazy var typeErasedRemoteRequestExecutable: AnyRemoteRequestExecutable  = {
        return AnyRemoteRequestExecutable(remoteRequestExecutable: localClient)
    }()
    
    private lazy var exchanger: Exchanger = {
        return Exchanger(client: typeErasedRemoteRequestExecutable)
    }()
    
    func testRatesContainerViewModel_validInitialization() {
        let viewModel = RatesContainerViewModel(exchanger: exchanger)
        XCTAssertNotNil(viewModel)
    }
    
    func testRatesContainerViewModel_receivesDelegateCallbacks_whenStateChanges() {
        let viewModel = RatesContainerViewModel(exchanger: exchanger)
        let mockDelegate = MockRatesContainerViewModelDelegate()
        let delegateExpecation = expectation(description: #function)
        mockDelegate.callback = { [weak delegateExpecation] state in
            delegateExpecation?.fulfill()
            delegateExpecation = nil
        }
        viewModel.delegate = mockDelegate
        viewModel.fetchData()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testRatesContainerViewModel_hasErrorStateWithError_whenServiceReturnsError() {
        let errorClient = ErrorClient(resource: Resources.rates, error: ErrorClientError.default)
        let typeErasedRemoteRequestExecutable = AnyRemoteRequestExecutable(remoteRequestExecutable: errorClient)
        let exchanger = Exchanger(client: typeErasedRemoteRequestExecutable)
        
        let viewModel = RatesContainerViewModel(exchanger: exchanger)
        let mockDelegate = MockRatesContainerViewModelDelegate()
        let delegateExpecation = expectation(description: #function)
        mockDelegate.callback = { [weak delegateExpecation] state in
            switch state {
            case .error(let error):
                XCTAssertNotNil(error)
                XCTAssert(true)
                delegateExpecation?.fulfill()
                delegateExpecation = nil
            case .loading:
                break
            case .loaded:
                XCTAssert(false)
            }
        }
        viewModel.delegate = mockDelegate
        viewModel.fetchData()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

final private class MockRatesContainerViewModelDelegate: RatesContainerViewModelDelegate {
    
    var callback: ((ViewState<([Currency], Money, Exchanger)>) -> Void)?

    func ratesContainerViewModel(_ : RatesContainerViewModel, didChange state: ViewState<([Currency], Money, Exchanger)>) {
        callback?(state)
    }
}


