//
//  TestOrderNetwork.swift
//  ShoppinistTests
//
//  Created by Asalah Sayed on 17/06/2023.
//

import XCTest
@testable import Shoppinist

final class TestOrderNetwork: XCTestCase {
    var remoteDataSource : AllOrderRemoteDataSourceProtocol?
    override func setUpWithError() throws {
        remoteDataSource = AllOrderRemoteDataSource()
    }

    override func tearDownWithError() throws {
        remoteDataSource = nil
    }
    func testFetchOrdersFromAPI(){
        let expectation = expectation(description: "Waiting for the API Data")
        remoteDataSource?.getAllOrders{ result in
            
            XCTAssertNotEqual(result?.orders?.count , 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }

}
