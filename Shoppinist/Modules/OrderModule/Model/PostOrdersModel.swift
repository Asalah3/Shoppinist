//
//  PostOrdersModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 07/06/2023.
//

import Foundation
// MARK: - PostOrdersModel
struct PostOrdersModel: Codable {
    let order: PostOrder
}

// MARK: - Order
struct PostOrder: Codable {
    let contactEmail: String?
    let currentTotalTax: String?
    let note: String?
    let confirmed: Bool?
    let customer: PostCustomer?
    let lineItems: [PostLineItem]?

    enum CodingKeys: String, CodingKey {
        case contactEmail = "contact_email"
        case currentTotalTax = "current_total_tax"
        case note, confirmed, customer
        case lineItems = "line_items"
    }
}

// MARK: - Customer
struct PostCustomer: Codable {
    let id: Int?
    let defaultAddress: DefaultAddress?

    enum CodingKeys: String, CodingKey {
        case id
        case defaultAddress = "default_address"
    }
}

// MARK: - DefaultAddress
struct DefaultAddress: Codable {
    let defaultAddressDefault: Bool?

    enum CodingKeys: String, CodingKey {
        case defaultAddressDefault = "default"
    }
}

// MARK: - LineItem
struct PostLineItem: Codable {
    let price: String?
    let quantity: Int?
    let title: String?
    let productID, variantID: Int?
    let taxLines: [PostTaxLine]?

    enum CodingKeys: String, CodingKey {
        case price, quantity, title
        case productID = "product_id"
        case variantID = "variant_id"
        case taxLines = "tax_lines"
    }
}

// MARK: - TaxLine
struct PostTaxLine: Codable {
    let price: String?
    let rate: Double?
    let title: String?
}
//extension Encodable {
//    func asDictionary() throws -> [String: Any] {
//        let data = try JSONEncoder().encode(self)
//        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
//            throw NSError()
//        }
//        return dictionary
//    }
//}
