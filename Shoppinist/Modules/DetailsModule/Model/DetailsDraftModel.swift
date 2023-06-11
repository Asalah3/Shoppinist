//
//  DetailsDraftModel.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 10/06/2023.
//

import Foundation

//// MARK: - AllDrafts
//class AllDraftss: Codable{
//    var draft_orders: [DrafOrders]?
//}
//// MARK: - Welcome
//struct Draftss: Codable {
//    var draft_order : DrafOrders?
//}
//
//// MARK: - DraftOrder
//class DrafOrders: Codable {
//    var id : Int?
//    var email: String?
//    var line_items : [LineItems]?
//    var customer: CustomerForDrafts?
//    var note: String?
//}
//
//
//// MARK: - Customer
//class customerrs : Codable{
//  var id : Int?
//  var email : String?
//  var created_at: String?
//  var updated_at : String?
// var first_name : String?
//
//}
//
//
//// MARK: - LineItem
//class LineItems: Codable {
//
//        var id: Int?
//        var product_id : Int?
//        var title : String?
//        var price : String?
//        var quantity : Int?
//        var sku : String?
//        var grams : Int?
//        var vendor : String?
//
//}
//
//class CustomerForDrafts: Codable {
//    var id: Int?
//    var email: String?
//    var acceptsMarketing: Bool?
//    var createdAt, updatedAt: Date?
//    var firstName, lastName: String?
//    var ordersCount: Int?
//    var state, totalSpent: String?
//    var lastOrderID: Int?
//    var note: String?
//    var verifiedEmail: Bool?
//    var taxExempt: Bool?
//    var tags, lastOrderName, currency: String?
//    var phone: String?
//    var acceptsMarketingUpdatedAt: Date?
//    var emailMarketingConsent: EmailMarketingConsent?
//
//
//}
//
//class EmailMarketingConsent: Codable {
//    var state, optInLevel: String?
//
//}

extension Encodable {
    func asDictionarys() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
