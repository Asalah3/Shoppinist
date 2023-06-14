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

// MARK: - Order
struct Order: Codable {
    let id: Int?
    let cartToken: String?
    let checkoutID: Int?
    let checkoutToken: String?
    let confirmed: Bool?
    let currency: String?
    let discountCodes: [DiscountCode]?
    let createdAt: String?
    let email: String?
    let name: String?
    let taxLines: [TaxLine]?
    let customer: Customer?
    let lineItems: [LineItem]?
    let shippingAddress: Address?
    let shippingLines: [ShippingLine]?

    enum CodingKeys: String, CodingKey {
        case id
        case cartToken = "cart_token"
        case checkoutID = "checkout_id"
        case checkoutToken = "checkout_token"
        case confirmed
        case createdAt = "created_at"
        case currency
        case discountCodes = "discount_codes"
        case email
        case name
        case taxLines = "tax_lines"
        case customer
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        case shippingLines = "shipping_lines"
    }
}

// MARK: - Address
struct OrderAddress: Codable {
    let firstName: String?
    let address1, phone, city, zip: String?
    let province, country: String?
    let lastName: String?
    let address2: String?
    let latitude, longitude: Double?
    let name, countryCode, provinceCode: String?
    let id, customerID: Int?
    let countryName: String?
    let addressDefault: Bool?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case address1, phone, city, zip, province, country
        case lastName = "last_name"
        case address2, latitude, longitude, name
        case countryCode = "country_code"
        case provinceCode = "province_code"
        case id
        case customerID = "customer_id"
        case countryName = "country_name"
        case addressDefault = "default"
    }
}
// MARK: - Customer
struct OrderCustomer: Codable {
    let id: Int?
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
    let phone, tags: String?
    let currency: String?
    let lastOrderName: String?
    let acceptsMarketingUpdatedAt: String?
    let adminGraphqlAPIID: String?
    let defaultAddress: OrderAddress?

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
        case phone, tags, currency
        case lastOrderName = "last_order_name"
        case acceptsMarketingUpdatedAt = "accepts_marketing_updated_at"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case defaultAddress = "default_address"
    }
}

// MARK: - DiscountCode
struct DiscountCode: Codable {
    let code, amount, type: String?
}

// MARK: - LineItem
struct OrderLineItem: Codable {
    let id: Int?
    let adminGraphqlAPIID: String?
    let fulfillableQuantity: Int?
    let fulfillmentService: String?
    let giftCard: Bool?
    let grams: Int?
    let name, price: String?
    let productExists: Bool?
    let productID: Int?
    let quantity: Int?
    let requiresShipping: Bool?
    let sku: String?
    let taxable: Bool?
    let title, totalDiscount: String?
    let variantID: Int?
    let variantInventoryManagement, variantTitle: String?
    let vendor: String?
    let taxLines: [TaxLine]?
    enum CodingKeys: String, CodingKey {
        case id
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case fulfillableQuantity = "fulfillable_quantity"
        case fulfillmentService = "fulfillment_service"
        case giftCard = "gift_card"
        case grams, name, price
        case productExists = "product_exists"
        case productID = "product_id"
        case quantity
        case requiresShipping = "requires_shipping"
        case sku, taxable, title
        case totalDiscount = "total_discount"
        case variantID = "variant_id"
        case variantInventoryManagement = "variant_inventory_management"
        case variantTitle = "variant_title"
        case vendor
        case taxLines = "tax_lines"
    }
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
