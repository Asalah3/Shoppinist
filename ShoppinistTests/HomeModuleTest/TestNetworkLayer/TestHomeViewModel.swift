//
//  TestHomeViewModel.swift
//  ShoppinistTests
//
//  Created by Asalah Sayed on 23/06/2023.
//

import XCTest
@testable import Shoppinist

final class TestHomeViewModel: XCTestCase {

    var homeViewModel: HomeViewModelProtocol?
    
    override func setUpWithError() throws {
        homeViewModel = HomeViewModel(HomeRemoteDataSource())
    }

    override func tearDownWithError() throws {
        homeViewModel = nil
    }

    func testgetAllBrands(){
        
        let expectation = expectation(description: "Waiting for the API Data")
        homeViewModel?.fetchHomeData(resourse: "")
        homeViewModel?.fetchBrandsToHomeViewController = { [weak self] in
            XCTAssertNotNil(self?.homeViewModel?.fetchHomeData)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
}
