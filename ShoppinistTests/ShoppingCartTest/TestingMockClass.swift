//
//  TestingMockClass.swift
//  ShoppinistTests
//
//  Created by Esraa AbdElfatah on 21/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist

final class TestCartMock: XCTestCase{
    
    func testRootDataDecoding(){
        CartMock.getAllDraftOrders(){res, _  in
            guard let result = res else{
                XCTFail()
                return
            }
            XCTAssertNotEqual(result.draftOrders?.count,0)
        }
    }
}
