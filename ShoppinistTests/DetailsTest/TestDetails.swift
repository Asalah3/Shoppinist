//
//  TestDetails.swift
//  ShoppinistTests
//
//  Created by Soha Ahmed Hamdy on 09/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist


final class TestDetails: XCTestCase {
    
    var productId : Int?
    
    override func setUpWithError() throws {
        productId = 8355030827300
    }

    override func tearDownWithError() throws {
        productId = nil
    }

    
    func testLoadCustomersFromAPI(){
        let expectation = expectation(description: "Waiting for the API Data")
        ProductDetailsDataSource.fetchProductDetails(product_id: productId ?? 0){ result in
            
            XCTAssertEqual(result?.product.id , self.productId)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
}
