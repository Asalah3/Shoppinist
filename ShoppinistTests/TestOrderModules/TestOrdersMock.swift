//
//  TestOrdersMock.swift
//  ShoppinistTests
//
//  Created by Asalah Sayed on 18/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist

final class TestOrdersMock: XCTestCase {

    func testOrdersDataDecoding(){
        OrdersMock().getAllOrders {res in
            guard let result = res else{
                XCTFail()
                return
            }
            XCTAssertNotNil(result)
        }
    }

}
