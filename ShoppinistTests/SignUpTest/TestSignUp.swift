//
//  TestSignUp.swift
//  ShoppinistTests
//
//  Created by Soha Ahmed Hamdy on 09/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist


final class TestSignUp: XCTestCase {
    var newCustomer : Customer?
    
    override func setUpWithError() throws {
        newCustomer = Customer()
        newCustomer?.first_name = "ITITestVM"
        newCustomer?.last_name = "ITITestVM"
        newCustomer?.email = "ITIIsmailia@gmail.com"
        newCustomer?.note = "123456789"
                
    }

    override func tearDownWithError() throws {
        newCustomer = nil
        
    }

    
    func testCreateCustomer(){
        let expectation = expectation(description: "Waiting for the API Data")
        SignUpNetworkService.customerRegister(newCustomer: newCustomer ?? Customer()){ result in
            
            XCTAssertEqual(result , 201)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
}
