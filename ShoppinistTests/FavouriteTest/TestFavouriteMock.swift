//
//  TestFavouriteMock.swift
//  ShoppinistTests
//
//  Created by Soha Ahmed Hamdy on 18/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist

final class TestFavouriteMock: XCTestCase{
    
    func testRootDataDecoding(){
        FavouriteMock.getAllDraftOrders(){res, _  in
            guard let result = res else{
                XCTFail()
                return
            }
            XCTAssertNotEqual(result.draftOrders?.count,0)
        }
    }
}
