//
//  CurrenyModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 09/06/2023.
//

import Foundation
// MARK: - CurrenyModel
struct CurrenyModel: Codable {
    let date, base: String
    let rates: Rates
}

// MARK: - Rates
struct Rates: Codable {
    let egp: String

    enum CodingKeys: String, CodingKey {
        case egp = "EGP"
    }
}
