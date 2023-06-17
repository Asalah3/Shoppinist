//
//  TestBrandProductsNetwork.swift
//  ShoppinistTests
//
//  Created by Asalah Sayed on 17/06/2023.
//

import XCTest
@testable import Shoppinist

final class TestBrandProductsNetwork: XCTestCase {

    var remoteDataSource : BrandProductsRemoteDataSourceProtocol?
    override func setUpWithError() throws {
        remoteDataSource = BrandProductsRemoteDataSource()
    }

    override func tearDownWithError() throws {
        remoteDataSource = nil
    }
    func testFetchBrandProductsFromAPI(){
        let expectation = expectation(description: "Waiting for the API Data")
        remoteDataSource?.fetchBrandProducts(collection_id: "447912804644"){ result in
            
            XCTAssertNotEqual(result?.products?.count , 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
}
