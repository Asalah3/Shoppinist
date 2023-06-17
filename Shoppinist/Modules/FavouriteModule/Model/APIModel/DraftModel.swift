
//  DraftModel.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 06/06/2023.


import Foundation

// MARK: - AllDrafts
struct AllDrafts: Codable {
    var draftOrders: [DrafOrder]?

    enum CodingKeys: String, CodingKey {
        case draftOrders = "draft_orders"
    }
}
// MARK: - Welcome
struct Drafts: Codable {
    var draftOrder: DrafOrder?

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

// MARK: - DraftOrder
struct DrafOrder: Codable {
    var id: Int?
    var note: String?
    var email: String?
    var taxesIncluded: Bool?
    var currency: String?
    var createdAt, updatedAt: String?
    var taxExempt: Bool?
    var name, status: String?
    var lineItems: [LineItem]?
    var appliedDiscount: AppliedDiscount?
    var taxLines: [TaxLine]?
    var tags: String?
    var totalPrice, subtotalPrice, totalTax: String?
    var customer: DraftCustomer?

    enum CodingKeys: String, CodingKey {
        case id, note, email
        case taxesIncluded = "taxes_included"
        case currency
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxExempt = "tax_exempt"
        case name, status
        case lineItems = "line_items"
        case appliedDiscount = "applied_discount"
        case taxLines = "tax_lines"
        case tags
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case customer
    }
}

// MARK: - AppliedDiscount
struct AppliedDiscount: Codable {
    var description, value, title, amount: String?
    var valueType: String?

    enum CodingKeys: String, CodingKey {
        case description, value, title, amount
        case valueType = "value_type"
    }
}

// MARK: - Customer
struct DraftCustomer: Codable {
    var id: Int?
    let email: String?
    let acceptsMarketing: Bool?
    let createdAt, updatedAt: String?
    let firstName, lastName: String?
    let ordersCount: Int?
    let state, totalSpent: String?
    let lastOrderID: Int?
    let note: String?
    let verifiedEmail: Bool?
    let taxExempt: Bool?
    let tags, lastOrderName, currency: String?
    let phone: String?
    let acceptsMarketingUpdatedAt: String?
    

    enum CodingKeys: String, CodingKey {
        case id, email
        case acceptsMarketing = "accepts_marketing"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case ordersCount = "orders_count"
        case state
        case totalSpent = "total_spent"
        case lastOrderID = "last_order_id"
        case note
        case verifiedEmail = "verified_email"
        case taxExempt = "tax_exempt"
        case tags
        case lastOrderName = "last_order_name"
        case currency, phone
        case acceptsMarketingUpdatedAt = "accepts_marketing_updated_at"
    }
}


// MARK: - LineItem
struct LineItem: Codable {
    var id: Int?
    var variantID, productID: Int?
    var title: String?
    var variantTitle, sku, vendor: String?
    var quantity: Int?
    var requiresShipping, taxable, giftCard: Bool?
    var fulfillmentService: String?
    var grams: Int?
    var taxLines: [TaxLine]?
    var name: String?
    var custom: Bool?
    var price: String?
    var image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case variantID = "variant_id"
        case productID = "product_id"
        case title
        case variantTitle = "variant_title"
        case sku, vendor, quantity
        case requiresShipping = "requires_shipping"
        case taxable
        case giftCard = "gift_card"
        case fulfillmentService = "fulfillment_service"
        case grams
        case taxLines = "tax_lines"
        case name, custom, price
        case image
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
