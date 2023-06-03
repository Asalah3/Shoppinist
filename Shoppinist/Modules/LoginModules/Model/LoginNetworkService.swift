//
//  LoginNetworkService.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 03/06/2023.
//

import Foundation
protocol LoginNetworkServiceProtocol{
    static func loadDataFromURL( completionHandeler: @escaping ((AllLoginedCustomers?), Error?) -> Void)
}
class LoginNetworkService : LoginNetworkServiceProtocol{
    static func loadDataFromURL(completionHandeler: @escaping ((AllLoginedCustomers?), Error?) -> Void) {
        let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/customers.json")
        guard let newUrl = url else {
            return
        }
        print("newUrl\(newUrl)")
        let request = URLRequest(url: newUrl)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request){ data ,response , error in
            do{
                let result = try JSONDecoder().decode(AllLoginedCustomers.self, from: data ?? Data())
                completionHandeler(result, nil)
                print("success in login")


            }catch let error{
                print(error.localizedDescription)
                print("error in login")
                completionHandeler(nil, error)
            }
            
        }
        task.resume()
    }
    
    
}
