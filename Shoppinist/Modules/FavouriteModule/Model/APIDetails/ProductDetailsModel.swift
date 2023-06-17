//
//  ProductDetailsModel.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 05/06/2023.
//

import Foundation

struct ProductDetailsModel: Codable {
    let product: Product
}

struct FavProductDetailsModel: Codable {
    let product: [Product]?
}


