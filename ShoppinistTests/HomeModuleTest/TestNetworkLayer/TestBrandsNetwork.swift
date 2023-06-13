//
//  TestBrandsNetwork.swift
//  ShoppinistTests
//
//  Created by Asalah Sayed on 13/06/2023.
//

import XCTest
@testable import Shoppinist

final class TestBrandsNetwork: XCTestCase {

    var remoteDataSource : HomeRemoteDataSourceProtocol?
    override func setUpWithError() throws {
        remoteDataSource = HomeRemoteDataSource()
    }

    override func tearDownWithError() throws {
        remoteDataSource = nil
    }

    
    func testFetchBrandsFromAPI(){
        let expectation = expectation(description: "Waiting for the API Data")
        remoteDataSource?.fetchBrands{ result in
            
            XCTAssertNotEqual(result?.smartCollections?.count , 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }

}

