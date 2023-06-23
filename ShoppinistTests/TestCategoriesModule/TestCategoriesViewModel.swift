//
//  TestCategoriesViewModel.swift
//  ShoppinistTests
//
//  Created by Asalah Sayed on 23/06/2023.
//

import XCTest
@testable import Shoppinist

final class TestCategoriesViewModel: XCTestCase {

    var categoriesViewModel: CategoriesViewModelProtocol?
    
    override func setUpWithError() throws {
        categoriesViewModel = CategoriesViewModel(CategoriesRemoteDataSource())
    }

    override func tearDownWithError() throws {
        CategoriesViewModel = nil
    }

    func testgetAllCategoriesData(){
        
        let expectation = expectation(description: "Waiting for the API Data")
        CategoriesViewModel?.fetchCategoriesData(category: Categories.Men)
        CategoriesViewModel?.fetchProductsToCategoriesViewController = { [weak self] in
            XCTAssertNotNil(self?.CategoriesViewModel?.fetchCategoryData)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
}
