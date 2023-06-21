//
//  TestShoppingCartViewModel.swift
//  ShoppinistTests
//
//  Created by Esraa AbdElfatah on 21/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist


final class TestFavouriteViewModel: XCTestCase {
    
    var CartViewModel: ShoppingCartViewModel?
    
    override func setUpWithError() throws {
        CartViewModel = ShoppingCartViewModel()
    }

    override func tearDownWithError() throws {
        CartViewModel = nil
    }

    
    
    func testgetAllDrafts(){
        
        let expectation = expectation(description: "Waiting for the API Data")
        CartViewModel?.getAllDrafts()
        CartViewModel?.bindingAllDrafts = { [weak self] in
                
            XCTAssertNotNil(self?.CartViewModel?.observableAllDrafts)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func testDeletDraft(){
        
        let expectation = expectation(description: "Waiting for the API Data")
        CartViewModel?.delDraft(draftId: 1116759621924)
        CartViewModel?.bindingDraftDelete = { [weak self] in
                
            XCTAssertNotNil(self?.CartViewModel?.ObservableDraftDelete)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    
}

