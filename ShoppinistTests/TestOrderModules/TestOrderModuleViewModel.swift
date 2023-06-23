//
//  TestOrderModuleViewModel.swift
//  ShoppinistTests
//
//  Created by Asalah Sayed on 23/06/2023.
//

import XCTest
@testable import Shoppinist
final class TestOrderModuleViewModel: XCTestCase {

    var allOrdersViewModel: AllOrdersViewModelProtocol?
    
    override func setUpWithError() throws {
        allOrdersViewModel = allOrdersViewModel(AllOrderRemoteDataSource())
    }

    override func tearDownWithError() throws {
        allOrdersViewModel = nil
    }

    func testgetAllOrders(){
        
        let expectation = expectation(description: "Waiting for the API Data")
        allOrdersViewModel?.fetchOrdersData(customerId: 6968619008292)
        allOrdersViewModel.fetchOrdersToAllOrdersViewController = { [weak self] in
            XCTAssertNotNil(self?.allOrdersViewModel?.fetchAllOrdersData)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }

}
