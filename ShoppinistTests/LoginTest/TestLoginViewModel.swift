//
//  TestLoginViewModel.swift
//  ShoppinistTests
//
//  Created by Soha Ahmed Hamdy on 09/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist


final class TestLoginViewModel: XCTestCase {
    
    var loginViewModel: LoginViewModel?
    
    override func setUpWithError() throws {
        loginViewModel = LoginViewModel()
    }

    override func tearDownWithError() throws {
        loginViewModel = nil
    }

    
    
    func testCreateCustomer(){
        
        let expectation = expectation(description: "Waiting for the API Data")
        loginViewModel?.getAllCustomers()
        loginViewModel?.bindingLogin = { [weak self] in
                
            XCTAssertNotNil(self?.loginViewModel?.observableLogin)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
}

