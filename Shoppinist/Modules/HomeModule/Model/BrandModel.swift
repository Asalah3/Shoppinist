//
//  BrandModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 01/06/2023.
//

import Foundation
struct BrandModel: Codable {
    let smartCollections: [SmartCollection]?
    enum CodingKeys: String, CodingKey {
        case smartCollections = "smart_collections"
    }
}

// MARK: - SmartCollection
struct SmartCollection: Codable {
    let id: Int?
    let handle, title: String?
    let updatedAt: String?
    let bodyHTML: String?
    let publishedAt: String?
    let sortOrder: String?
    let disjunctive: Bool?
    let rules: [Rule]?
    let publishedScope: String?
    let adminGraphqlAPIID: String?
    let image: Image?

    enum CodingKeys: String, CodingKey {
        case id, handle, title
        case updatedAt = "updated_at"
        case bodyHTML = "body_html"
        case publishedAt = "published_at"
        case sortOrder = "sort_order"
        case disjunctive, rules
        case publishedScope = "published_scope"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case image
    }
}

// MARK: - Image
struct Image: Codable {
    let createdAt: String?
    let width, height: Int?
    let src: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case width, height, src
    }
}

// MARK: - Rule
struct Rule: Codable {
    let column: String?
    let relation: String?
    let condition: String?
}
