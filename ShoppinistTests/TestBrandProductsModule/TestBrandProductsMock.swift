//
//  TestBrandProductsMock.swift
//  ShoppinistTests
//
//  Created by Asalah Sayed on 17/06/2023.
//

import XCTest
@testable import Shoppinist
final class TestBrandProductsMock: XCTestCase {

    func testBrandProductsDataDecoding(){
        BrandProductsMock().fetchBrandProducts(collection_id: "8355031417124") {res in
            guard let result = res else{
                XCTFail()
                return
            }
            XCTAssertNotNil(result)
        }
    }

}
