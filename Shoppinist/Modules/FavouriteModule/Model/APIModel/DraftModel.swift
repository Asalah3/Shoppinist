
//  DraftModel.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 06/06/2023.


import Foundation


// MARK: - AllDrafts
struct AllDrafts: Codable {
    var draftOrders: [DraftOrder]?

    enum CodingKeys: String, CodingKey {
        case draftOrders = "draft_orders"
    }
}
// MARK: - Welcome
struct Drafts: Codable {
    var draftOrder: DraftOrder?

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

// MARK: - DraftOrder
struct DraftOrder: Codable {
    let id: Int?
    let note: String?
    let email: String?
    let taxesIncluded: Bool?
    var currency: String?
    let createdAt, updatedAt: String?
    var taxExempt: Bool?
    let name, status: String?
    var lineItems: [LineItem]?
    var appliedDiscount: AppliedDiscount?
    let taxLines: [TaxLine]?
    let tags: String?
    let totalPrice, subtotalPrice, totalTax: String?
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
    let description, value, title, amount: String?
    let valueType: String?

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
    let emailMarketingConsent: EmailMarketingConsent?

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
        case emailMarketingConsent = "email_marketing_consent"
    }
}

// MARK: - EmailMarketingConsent
struct EmailMarketingConsent: Codable {
    let state, optInLevel: String?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
    }
}

// MARK: - LineItem
struct LineItem: Codable {
    let id: Int?
    let variantID, productID: Int?
    let title: String?
    let variantTitle, sku, vendor: String?
    let quantity: Int?
    let requiresShipping, taxable, giftCard: Bool?
    let fulfillmentService: String?
    let grams: Int?
    let taxLines: [TaxLine]?
    let name: String?
    let custom: Bool?
    let price: String?

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
