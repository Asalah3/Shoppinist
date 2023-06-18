//
//  TestFavouriteViewModel.swift
//  ShoppinistTests
//
//  Created by Soha Ahmed Hamdy on 18/06/2023.
//

import Foundation
import XCTest
@testable import Shoppinist


final class TestFavouriteViewModel: XCTestCase {
    
    var favouriteViewModel: DraftViewModel?
    
    override func setUpWithError() throws {
        favouriteViewModel = DraftViewModel()
    }

    override func tearDownWithError() throws {
        favouriteViewModel = nil
    }

    
    
    func testgetAllDrafts(){
        
        let expectation = expectation(description: "Waiting for the API Data")
        favouriteViewModel?.getAllDrafts()
        favouriteViewModel?.bindingAllDrafts = { [weak self] in
                
            XCTAssertNotNil(self?.favouriteViewModel?.observableAllDrafts)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func testDeletDraft(){
        
        let expectation = expectation(description: "Waiting for the API Data")
        favouriteViewModel?.delDraft(draftId: 1116759621924)
        favouriteViewModel?.bindingDraftDelete = { [weak self] in
                
            XCTAssertNotNil(self?.favouriteViewModel?.ObservableDraftDelete)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    
}

