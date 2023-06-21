//
//  AddressNetWorkServices.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 03/06/2023.
//

import Foundation

protocol AddressProtocol{
    
   static func CreateAddress(customerId: Int, address : Address,completion:@escaping (Int) -> Void)
    
    static func editAddress(customerId: Int,addressID: Int, address : [String: Any],completion:@escaping (Int) -> Void)
    
    static func deleteAddress(Address_Id : Int ,Customer_Id : Int ,complication:@escaping (Int) -> Void)
    
    static func updateAddress(customer_id : Int , address_id : Int , address : String,complication:@escaping (Int) -> Void)
    
    static func getAddress(completion: @escaping ((CustomerAddress)?, Error?) -> Void)
}

class AddressNetworkServices : AddressProtocol{
  

    static func CreateAddress(customerId: Int, address : Address,completion:@escaping (Int) -> Void) {
        let url = URL(string:"https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/customers/\(customerId).json")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "PUT"
        let AddressDictionary : [String : Any] = ["customer" : [ "addresses" : [["address1" : address.address1 ,"city" : address.city , "country" : address.country , "phone" : address.phone ]]]]
        urlRequest.httpShouldHandleCookies = false
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: AddressDictionary, options: .prettyPrinted)
            urlRequest.httpBody = requestBody
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
        } catch let error {
            print(error.localizedDescription)
        }
        URLSession.shared.dataTask(with: urlRequest) { (data , response, error) in
            if(data != nil && data?.count != 0) {
                let response = String(data: data! , encoding: .utf8)
            }
            
        }.resume()
    }
    
    static func editAddress(customerId: Int,addressID: Int, address : [String: Any],completion:@escaping (Int) -> Void) {
        let url = URL(string:"https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/customers/\(customerId)/addresses/\(addressID).json")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "PUT"
        urlRequest.httpShouldHandleCookies = false
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: address, options: .prettyPrinted)
            urlRequest.httpBody = requestBody
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
        } catch let error {
            print(error.localizedDescription)
        }
        URLSession.shared.dataTask(with: urlRequest) { (data , response, error) in
            if(data != nil && data?.count != 0) {
                let response = String(data: data! , encoding: .utf8)
            }
            
        }.resume()
    }
    
    
    
    static func updateAddress(customer_id : Int , address_id : Int , address : String,complication:@escaping (Int) -> Void) {

        let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/customers/\(customer_id)/addresses/\(address_id)/default")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "PUT"
        let userDictionary = ["customer_address" :
                                ["id": address_id ,"customer_id" : customer_id, "address1" :"\(address)" , "default": true]
        ]
        print(userDictionary)
        urlRequest.httpShouldHandleCookies = false
        do {
            
            let bodyDictionary = try JSONSerialization.data(withJSONObject: userDictionary,options: .prettyPrinted)
            urlRequest.httpBody = bodyDictionary
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch let error {
            print(error.localizedDescription)
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if (data != nil && data?.count != 0){
                if let httpResponse = response as? HTTPURLResponse {
                    let response = String(data:data!,encoding: .utf8)
                    complication(httpResponse.statusCode)
                    
                   }
            }
            
        }.resume()
        
    }
    
    static func deleteAddress(Address_Id: Int, Customer_Id: Int, complication: @escaping (Int) -> Void) {
        let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/customers/\(Customer_Id)/addresses/\(Address_Id).json")
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if (data != nil && data?.count != 0){
                if let httpResponse = response as? HTTPURLResponse {
                    let response = String(data:data!,encoding: .utf8)
                    complication(httpResponse.statusCode)
                    
                   }
                }
               }.resume()
    }
    
    static func getAddress(completion: @escaping ((CustomerAddress)?, Error?) -> Void){
        let id = UserDefaults.standard.integer(forKey:"customerID")
        let url =  URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/customers/\(id)/addresses.json")
        guard let url = url else { return }
        var request = URLRequest(url: url)
        request.httpShouldHandleCookies = false
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { data, response, error in

            if let error = error{
                completion(nil, error)
            }else{
                let json = try? JSONDecoder().decode(CustomerAddress.self, from: data!)
                completion(json, nil)
            }                
        }
        task.resume()
    }
    
    
}
