//
//  ReviewList.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 15/06/2023.
//

import Foundation

protocol ReviewListProtocol{
    static func getReviewList()-> [Review]
}

class ReviewList :ReviewListProtocol{
    
    static let myReviews: [Review] = [
        Review(image: "Soha", text: "very nice and perfect size", rate: 5.00),
        Review(image: "Esraa", text: "good trail", rate: 4.00),
        Review(image: "Asalah", text: "not good quality", rate: 2.00),
        Review(image: "Soha", text: "very nice", rate: 4.50),
        Review(image: "Esraa", text: "great", rate: 3.50),
        Review(image: "Asalah", text: "not the color", rate: 3.00)
    ]
    
    static func getReviewList() -> [Review]{
        return myReviews
    }
    
    
}
