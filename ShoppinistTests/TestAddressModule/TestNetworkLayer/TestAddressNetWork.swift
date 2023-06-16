//
//  TestAddressNetWork.swift
//  ShoppinistTests
//
//  Created by Esraa AbdElfatah on 15/06/2023.
//

import XCTest
@testable import Shoppinist
final class TestAddressNetWork: XCTestCase {
    var newAddress:Address?
    override func setUpWithError() throws {
        newAddress = Address()
        newAddress?.id = 9157338038564
        newAddress?.address1 = "Mansoura"
        newAddress?.city = "Miser"
        newAddress?.country = " egypt"
        newAddress?.phone = "01094406437"
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testGetAddressApi(){
        let expection = expectation(description: "Waiting for the API Data")
        AddressNetworkServices.getAddress(){CustomerAddress, _  in
        guard let customerAdress = CustomerAddress else {
            XCTFail()
            expection.fulfill()
            return
        }
            XCTAssertEqual(customerAdress.addresses?[0].country, "Egypt"  ,"Api Failed")
        expection.fulfill()
    }
    waitForExpectations(timeout: 5)
    }
    func testDeleteAddressApi(){
        let expection = expectation(description: "Waiting for the API Data")
        AddressNetworkServices.deleteAddress(Address_Id: 9157338038564, Customer_Id:6931011928356 ){result in
            
            XCTAssertEqual(result , 404)
            expection.fulfill()
        }
        waitForExpectations(timeout: 5)
            
        }

   
  }




