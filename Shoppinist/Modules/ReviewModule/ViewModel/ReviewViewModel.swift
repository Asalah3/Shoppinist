//
//  ReviewViewModel.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 15/06/2023.
//

import Foundation

class ReviewViewModel{
    func getReviews() -> [Review]{
        return ReviewList.getReviewList()
    }
}
