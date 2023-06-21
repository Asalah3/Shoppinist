//
//  SignUpNetworkService.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 02/06/2023.
//

import Foundation

import Foundation


protocol SignUpNetworkServiceProtocol {
    static func  customerRegister(newCustomer:Customer,complication:@escaping (Int) -> Void)
}


class SignUpNetworkService : SignUpNetworkServiceProtocol{
    
    static func customerRegister(newCustomer: Customer, complication: @escaping (Int) -> Void) {
        
        let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/customers.json")
        guard let newUrl = url else {
            return
        }
        print(newUrl)
        var urlRequest = URLRequest(url: newUrl)
        urlRequest.httpMethod = "POST"
        let customerInfoDictionary = ["customer": ["first_name": newCustomer.first_name,
                                           "last_name" : newCustomer.last_name,
                                           "email": newCustomer.email,
                                           "note": newCustomer.note
                                          ]]
        urlRequest.httpShouldHandleCookies = false
        do {
            
            let httpBodyDictionary = try JSONSerialization.data(withJSONObject: customerInfoDictionary,options: .prettyPrinted)
            urlRequest.httpBody = httpBodyDictionary
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch let error {
            print(error.localizedDescription)
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if (data != nil && data?.count != 0){
                if let httpResponse = response as? HTTPURLResponse {
                    let response = String(data:data ?? Data(),encoding: .utf8)
                    complication(httpResponse.statusCode)
                    
                   }
            }
            
        }.resume()
    }
    
}


