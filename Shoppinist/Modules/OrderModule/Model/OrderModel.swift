//
//  OrderModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 07/06/2023.
//

import Foundation
// MARK: - OrdersModel
struct OrdersModel: Codable {
    let orders: [Order]?
}
struct PostOrdersModel: Codable {
    let order: Order
}

// MARK: - Order
struct Order: Codable {
    let id: Int?
    let confirmed: Bool?
    let discountCodes: [DiscountCode]?
    let createdAt: String?
    let email: String?
    let name: String?
    let note: String?
    let taxLines: [TaxLine]?
    let customer: Customer?
    let lineItems: [LineItem]?
    let shippingAddress: Address?
    let shippingLines: [ShippingLine]?

    enum CodingKeys: String, CodingKey {
        case id
        case confirmed
        case createdAt = "created_at"
        case discountCodes = "discount_codes"
        case email
        case name, note
        case taxLines = "tax_lines"
        case customer
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        case shippingLines = "shipping_lines"
    }
}
// MARK: - DiscountCode
struct DiscountCode: Codable {
    let code, amount, type: String?
}

// MARK: - TaxLine
struct TaxLine: Codable {
    let price: String?
    let rate: Double?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case price
        case rate, title
    }
}
// MARK: - ShippingLine
struct ShippingLine: Codable {
    let id: Int?
    let code: String?
    let discountedPrice: String?
    let price: String?
    let source, title: String?
    let taxLines : [TaxLine]?

    enum CodingKeys: String, CodingKey {
        case id
        case code
        case discountedPrice = "discounted_price"
        case price
        case source, title
        case taxLines = "tax_lines"
    }
}
