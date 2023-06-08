////
////  CardModel.swift
////  Shoppinist
////
////  Created by Esraa AbdElfatah on 06/06/2023.
////
//
//import Foundation
//
//class ShoppingCart : Codable{
//    var draft_orders : [DrafOrder]?
//
//}
//
//class DraftOrderResponse : Codable {
//    var draft_order : DrafOrder?
//}
//
//class DrafOrder : Codable {
//    var id : Int?
//    var email: String?
//    var line_items : [LineItem]?
//    var customer: CustomerForDraft?
//}
//
//class LineItem : Codable {
//    var product_id : Int?
//    var title : String?
//    var price : String?
//    var quantity : Int?
//    var sku : String?
//    var grams : Int?
//    var vendor : String?
//
//
//
//}
//class customerr : Codable{
//
//    var id : Int?
//    var email : String?
//   var created_at: String?
// var updated_at : String?
//var first_name : String?
//
//}
//
//struct ShoppingCartPut : Codable{
//    var draft_order : DrafOrder?
//}
//
//
//class CustomerForDraft: Codable {
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
//
//extension Encodable {
//    func asDictionary() throws -> [String: Any] {
//        let data = try JSONEncoder().encode(self)
//        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
//            throw NSError()
//        }
//        return dictionary
//    }
//}
