//
//  AddressViewModel.swift
//  ShoppinistTests
//
//  Created by Esraa AbdElfatah on 15/06/2023.
//



import Foundation
import XCTest
@testable import Shoppinist


final class TestAddressViewModel: XCTestCase {
    
    var addressViewModel: AddressViewModel?
    
    override func setUpWithError() throws {
        addressViewModel = AddressViewModel()
    }

    override func tearDownWithError() throws {
        addressViewModel = nil
    }

    
    
    func testGetAddress(){
        
        let expectation = expectation(description: "Waiting for the API Data")
        addressViewModel?.getAddress()
        addressViewModel?.bindingGet = { [weak self] in
                
            XCTAssertNotNil(self?.addressViewModel?.ObservableGet)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    

    
    
}

