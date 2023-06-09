//
//  TestLoginMock.swift
//  ShoppinistTests
//
//  Created by Soha Ahmed Hamdy on 09/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist

final class TestLoginMock: XCTestCase{
    
    func testRootDataDecoding(){
        LoginMock.loadDataFromURL(){res, _  in
            guard let result = res else{
                XCTFail()
                return
            }
            XCTAssertNotEqual(result.customers.count,0)
        }
    }
}
