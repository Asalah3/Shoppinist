//
//  SignCustomerModel.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 03/06/2023.
//

import Foundation

struct SignCustomer:Codable{
    var customers:[Customer]
}

struct Customer:Codable {
    var id:Int?
    var first_name:String?
    var last_name:String?
    var email:String?
    var note:String?
}
