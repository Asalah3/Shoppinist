//
//  TestCategoriesMock.swift
//  ShoppinistTests
//
//  Created by Asalah Sayed on 17/06/2023.
//

import XCTest
@testable import Shoppinist

final class TestCategoriesMock: XCTestCase {
    func testCategoriesDataDecoding(){
        CategoriesMock().fetchCategoryProducts(collection_id: "447912968484") {res in
            guard let result = res else{
                XCTFail()
                return
            }
            XCTAssertNotNil(result)
        }
    }

}
