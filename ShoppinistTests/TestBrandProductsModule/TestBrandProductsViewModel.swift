//
//  TestBrandProductsViewModel.swift
//  ShoppinistTests
//
//  Created by Asalah Sayed on 23/06/2023.
//

import XCTest
@testable import Shoppinist
final class TestBrandProductsViewModel: XCTestCase {

    var brandProductsViewModel: BrandProductsViewModelProtocol?
    
    override func setUpWithError() throws {
        brandProductsViewModel = BrandProductsViewModel(BrandProductsRemoteDataSource())
    }

    override func tearDownWithError() throws {
        brandProductsViewModel = nil
    }

    func testgetAllBrandProducts(){
        
        let expectation = expectation(description: "Waiting for the API Data")
        brandProductsViewModel?.fetchBrandProducts(collectionId :447912444196)
        brandProductsViewModel.fetchProductsToBrandProductsViewController = { [weak self] in
            XCTAssertNotNil(self?.brandProductsViewModel?.fetchProductsData)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
}
