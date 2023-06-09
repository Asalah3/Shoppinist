//
//  TestDetailsMock.swift
//  ShoppinistTests
//
//  Created by Soha Ahmed Hamdy on 09/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist

final class TestDetailsMock: XCTestCase{
    var mockDetails: DetailsMock?
    var productId: Int?
    override func setUpWithError() throws {
        mockDetails = DetailsMock()
        productId = 8355030827300
    }

    override func tearDownWithError() throws {
        mockDetails = nil
        productId = nil
    }
    
    func testRootDataDecoding(){
        mockDetails?.fetchProductDetails(product_id: productId ?? 0) {res in
            guard let result = res else{
                XCTFail()
                return
            }
            XCTAssertNotNil(result)
        }
    }
}
