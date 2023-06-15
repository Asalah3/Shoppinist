//
//  TestAddNewAddressViewModel.swift
//  ShoppinistTests
//
//  Created by Esraa AbdElfatah on 15/06/2023.
//

import XCTest
@testable import Shoppinist
class MockURLProtocol: URLProtocol {
    static var mockResponse: (data: Data?, response: URLResponse?, error: Error?)?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.mockResponse?.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            self.client?.urlProtocol(self, didReceive: MockURLProtocol.mockResponse!.response!, cacheStoragePolicy: .notAllowed)
            if let data = MockURLProtocol.mockResponse?.data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {
        
    }
}

class YourTestClass: XCTestCase {

    func testGetAddress() {
        // Arrange
        let mockData = """
            {
                "address": {
                    "id": 1,
                    "address1": "123 Main St",
                    "city": "San Francisco",
                    "province": "California",
                    "zip": "94105"
                }
            }
        """.data(using: .utf8)
        MockURLProtocol.mockResponse = (data: mockData, response: HTTPURLResponse(url: URL(string: "http://mockurl.com")!, statusCode: 200, httpVersion: nil, headerFields: nil), error: nil)
        URLProtocol.registerClass(MockURLProtocol.self)
        
        let expectation = self.expectation(description: "Completion handler called")
        
        // Act
        AddressNetworkServices.getAddress { (customerAddress, error) in
            

            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Cleanup
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }
}

