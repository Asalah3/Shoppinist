//
//  AddressModel.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 03/06/2023.
//

import Foundation

struct Customers : Codable {
    let customers : [Customer]
}

struct customer : Codable {
    let first_name, last_name, email, phone:  String?
    let id: Int?
    let verified_email: Bool?
    let addresses: [Address]?
}

struct Address: Codable {
    var id : Int?
    var address1, city, country, phone: String?
    var `default` :Bool?
}

struct CustomerAddress: Codable {
    var addresses: [Address]?
}

struct UpdateAddress: Codable {
    var address: Address
}

struct PutAddress: Codable {
    let customer: CustomerAddress?
}

