
//  DraftModel.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 06/06/2023.


import Foundation


// MARK: - AllDrafts
class AllDrafts: Codable{
    var draft_orders: [DrafOrder]?
}
// MARK: - Welcome
struct Drafts: Codable {
    var draft_order : DrafOrder?
}

// MARK: - DraftOrder
class DrafOrder: Codable {
    var id : Int?
    var email: String?
    var line_items : [LineItem]?
    var customer: CustomerForDraft?
    var note: String?
}


// MARK: - Customer
class customerr : Codable{
  var id : Int?
  var email : String?
  var created_at: String?
  var updated_at : String?
 var first_name : String?

}


// MARK: - LineItem
class LineItem: Codable {
        var id: Int?
        var product_id : Int?
        var title : String?
        var price : String?
        var quantity : Int?
        var sku : String?
        var grams : Int?
        var vendor : String?

}

class CustomerForDraft: Codable {
    var id: Int?
    var email: String?
    var acceptsMarketing: Bool?
    var createdAt, updatedAt: Date?
    var firstName, lastName: String?
    var ordersCount: Int?
    var state, totalSpent: String?
    var lastOrderID: Int?
    var note: String?
    var verifiedEmail: Bool?
    var taxExempt: Bool?
    var tags, lastOrderName, currency: String?
    var phone: String?
    var acceptsMarketingUpdatedAt: Date?
    var emailMarketingConsent: EmailMarketingConsent?


}

class EmailMarketingConsent: Codable {
    var state, optInLevel: String?

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
