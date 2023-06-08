//
//  DraftOrderNetworkService.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 06/06/2023.
//

import Foundation

protocol DraftNetworkProtocol{
    static func CreateDraft(product: Product,note: String, complication:@escaping (Int) -> Void)
    static func updateDraft(draft: Drafts, complication:@escaping (Int) -> Void)
    static func deleteDraft(draftID: Int, complication:@escaping (Int) -> Void)
    static func getAllDraftOrders( completionHandeler: @escaping ((AllDrafts?), Error?) -> Void)
}


class DraftNetwork:DraftNetworkProtocol{
    
    static func CreateDraft(product: Product, note: String, complication:@escaping (Int) -> Void) {
        let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/draft_orders.json")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        let userDictionary =  [
            "draft_order": [
                "note": note,
              "line_items": [
                [
                    "id": product.id ?? 0,
                    "title": product.title ?? "",
                    "quantity": 2,
                    "price": product.variants?[0].price ?? "20",
                    "sku": "\(product.id ?? 0)",
                    
                ]
              ],
              
              "applied_discount": [
                "description": "Custom discount",
                "value": "10.0",
                "title": "Custom",
                "amount": "10.00",
                "value_type": "fixed_amount"
              ],
              
              "customer": [
                "id": UserDefaults.standard.integer(forKey:"customerID"),
                
                "default_address": [
                  "default": true
                ]
              ]
            ]
          ]

        
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
                     print(response!)
                    complication(httpResponse.statusCode)
                    
                   }
            }
        }.resume()
    }
    
    
    static func updateDraft(draft: Drafts, complication: @escaping (Int) -> Void) {
        let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/draft_orders/\(draft.draftOrder?.id ?? 0).json")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "PUT"
        
        do {
            let userDictionary = try draft.asDictionary()
            urlRequest.httpShouldHandleCookies = false
            let bodyDictionary = try JSONSerialization.data(withJSONObject: userDictionary,options: .prettyPrinted)
            urlRequest.httpBody = bodyDictionary
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch let error {
            print("updated error\(error)")
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if (data != nil && data?.count != 0){
                if let httpResponse = response as? HTTPURLResponse {
                    let response = String(data:data!,encoding: .utf8)
                     print(response!)
                    complication(httpResponse.statusCode)
                    
                   }
            }
            
        }.resume()
       
    }
    

    
    static func deleteDraft(draftID: Int, complication: @escaping (Int) -> Void) {
        let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/draft_orders/\(draftID).json")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "DELETE"
        urlRequest.httpShouldHandleCookies = false
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if (data != nil && data?.count != 0){
                if let httpResponse = response as? HTTPURLResponse {
                    let response = String(data:data!,encoding: .utf8)
                     print(response!)
                    complication(httpResponse.statusCode)
                    
                   }
            }
            
        }.resume()
    }
    
    
    static func getAllDraftOrders(completionHandeler: @escaping ((AllDrafts?), Error?) -> Void) {
        let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/draft_orders.json")
        guard let newUrl = url else {
            return
        }
        print("newUrl\(newUrl)")
        let request = URLRequest(url: newUrl)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request){ data ,response , error in
            do{
                let result = try JSONDecoder().decode(AllDrafts.self, from: data ?? Data())
                completionHandeler(result, nil)
                print("success in getDrafts")
                print(result.draftOrders?.count ?? 0)


            }catch let error{
                print(error.localizedDescription)
                print("error in getDrafts")
                completionHandeler(nil, error)
            }
            
        }
        task.resume()
    }
    
    
    

    
}

