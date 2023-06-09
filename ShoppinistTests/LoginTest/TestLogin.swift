//
//  TestLogin.swift
//  ShoppinistTests
//
//  Created by Soha Ahmed Hamdy on 09/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist


final class TestLogin: XCTestCase {
    func testLoadCustomersFromAPI(){
        let expectation = expectation(description: "Waiting for the API Data")
        LoginNetworkService.loadDataFromURL(){ result, _  in
            
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
}


