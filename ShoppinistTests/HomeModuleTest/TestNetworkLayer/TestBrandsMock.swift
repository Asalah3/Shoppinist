//
//  TestBrandsMock.swift
//  ShoppinistTests
//
//  Created by Asalah Sayed on 13/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist

final class TestBrandsMock: XCTestCase {

    func testRootDataDecoding(){
        BrandsMock().fetchBrands {res in
            guard let result = res else{
                XCTFail()
                return
            }
            XCTAssertNotNil(result)
        }
    }

}
