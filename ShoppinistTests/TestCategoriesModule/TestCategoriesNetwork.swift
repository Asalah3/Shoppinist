//
//  TestCategoriesNetwork.swift
//  ShoppinistTests
//
//  Created by Asalah Sayed on 17/06/2023.
//

import XCTest
@testable import Shoppinist

final class TestCategoriesNetwork: XCTestCase {
    var remoteDataSource : CategoriesRemoteDataSourceProtocol?
    override func setUpWithError() throws {
        remoteDataSource = CategoriesRemoteDataSource()
    }

    override func tearDownWithError() throws {
        remoteDataSource = nil
    }
    func testFetchMenCategoryProductsFromAPI(){
        let expectation = expectation(description: "Waiting for the API Data")
        remoteDataSource?.fetchCategoryProducts(collection_id: "447912870180"){ result in
            
            XCTAssertNotEqual(result?.products?.count , 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func testFetchWomenCategoryProductsFromAPI(){
        let expectation = expectation(description: "Waiting for the API Data")
        remoteDataSource?.fetchCategoryProducts(collection_id: "447912902948"){ result in
            
            XCTAssertNotEqual(result?.products?.count , 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func testFetchKidsCategoryProductsFromAPI(){
        let expectation = expectation(description: "Waiting for the API Data")
        remoteDataSource?.fetchCategoryProducts(collection_id: "447912935716"){ result in
            
            XCTAssertNotEqual(result?.products?.count , 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func testFetchSaleCategoryProductsFromAPI(){
        let expectation = expectation(description: "Waiting for the API Data")
        remoteDataSource?.fetchCategoryProducts(collection_id: "447912968484"){ result in
            
            XCTAssertNotEqual(result?.products?.count , 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
}
