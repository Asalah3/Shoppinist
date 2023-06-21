//
//  ShoppingCartTest.swift
//  ShoppinistTests
//
//  Created by Esraa AbdElfatah on 21/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist


final class ShoppingCartTest: XCTestCase {
    
    var product: Product?
    
    override func setUpWithError() throws {
        product = Product(id: 8355030270244, title: "producttest", bodyHTML: "any String to test api result", vendor: nil, productType: "Shoes Test", handle: nil, status: "", publishedScope: "", tags: "", variants: nil, images: nil, image: nil)
    }

    override func tearDownWithError() throws {
        product = nil
    }

    
    func testCreateDraftOrder(){
        let expectation = expectation(description: "Waiting for the API Data")
        CartNetwork.CreateDraft(product: product!, note: "shoppingTest"){ result in
            
            XCTAssertEqual(result, 201)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func testGetAllDraftOrders(){
        let expectation = expectation(description: "Waiting for the API Data")
        CartNetwork.getAllDraftOrders(){ result, _ in
            
            XCTAssertNotEqual(result?.draftOrders?.count, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
}
