//
//  TestFavourite.swift
//  ShoppinistTests
//
//  Created by Soha Ahmed Hamdy on 12/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist


final class TestFavourites: XCTestCase {
    
    var product: Product?
    
    override func setUpWithError() throws {
        product = Product(id: 8355030270244, title: "producttest", bodyHTML: "any String to test api result", vendor: nil, productType: "Shoes Test", handle: nil, status: "", publishedScope: "", tags: "", variants: nil, images: nil, image: nil)
    }

    override func tearDownWithError() throws {
        product = nil
    }

    
    func testCreateDraftOrder(){
        let expectation = expectation(description: "Waiting for the API Data")
        DraftNetwork.CreateDraft(product: product!, note: "favouriteTest"){ result in
            
            XCTAssertEqual(result, 201)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func testGetAllDraftOrders(){
        let expectation = expectation(description: "Waiting for the API Data")
        DraftNetwork.getAllDraftOrders(){ result, _ in
            
            XCTAssertNotEqual(result?.draftOrders?.count, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
}
