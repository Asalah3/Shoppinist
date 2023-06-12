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
    var productId: Int?
    override func setUpWithError() throws {
        productId = 8355030827300
    }

    override func tearDownWithError() throws {
        productId = nil
    }
    
    func testRootDataDecoding(){
        DetailsMock.fetchProductDetails(product_id: productId ?? 0) {res in
            guard let result = res else{
                XCTFail()
                return
            }
            XCTAssertNotNil(result)
        }
    }
}
