//
//  TestSignViewModel.swift
//  ShoppinistTests
//
//  Created by Soha Ahmed Hamdy on 09/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist


final class TestSignUpViewModel: XCTestCase {

    var newCustomer : Customer?
    var signViewModel: SignViewModel?

    override func setUpWithError() throws {
        newCustomer = Customer()
        newCustomer?.first_name = "TestVM"
        newCustomer?.last_name = "TestVM"
        newCustomer?.email = "ITI@gmail.com"
        newCustomer?.note = "123456789"

        signViewModel = SignViewModel()

    }

    override func tearDownWithError() throws {
        newCustomer = nil
        signViewModel = nil

    }



    func testCreateCustomer(){

        let expectation = expectation(description: "Waiting for the API Data")
        signViewModel?.insertCustomer(customer: newCustomer ?? Customer())
        signViewModel?.bindingSignUp = { [weak self] in

            XCTAssertEqual(self?.signViewModel?.ObservableSignUp , 201)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }

}

