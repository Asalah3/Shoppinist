//
//  LoginedCustomerModel.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 02/06/2023.
//

import Foundation

class AllLoginedCustomers : Decodable{
    
    let customers : [LoginCustomer]
}

class LoginCustomer: Decodable {
    let id: Int?
    let email: String?
    let note:String?
    var first_name:String?
}
