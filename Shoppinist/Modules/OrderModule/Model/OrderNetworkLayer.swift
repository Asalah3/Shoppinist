//
//  OrderNetworkLayer.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 07/06/2023.
//

import Foundation
protocol OrderNetworkProtocol{
    func createOrder(order: PostOrdersModel, complication:@escaping (Int) -> Void)
    func deleteOrder(orderID: Int, complication:@escaping (Int) -> Void)
    func getAllOrders( completionHandeler: @escaping ((OrdersModel?)) -> Void)
}
class OrderNetwork:OrderNetworkProtocol{
     func deleteOrder(orderID: Int, complication: @escaping (Int) -> Void) {
        let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/orders/\(orderID).json")
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
    
    func getAllOrders(completionHandeler: @escaping ((OrdersModel?)) -> Void) {
        let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/orders.json")
        guard let newUrl = url else {
            return
        }
        print("newUrl\(newUrl)")
        let request = URLRequest(url: newUrl)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request){ data ,response , error in
            do{
                let result = try JSONDecoder().decode(OrdersModel.self, from: data ?? Data())
                completionHandeler(result)
                print("success in getOrders")
            }catch let error{
                print(error.localizedDescription)
                print("error in getOrders")
                completionHandeler(nil)
            }
        }
        task.resume()
    }
    
    func createOrder(order: PostOrdersModel, complication:@escaping (Int) -> Void) {
        let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/orders.json")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpShouldHandleCookies = false
        do {
            let userDictionary = try? order.asDictionary()
            let bodyDictionary = try JSONSerialization.data(withJSONObject: userDictionary ?? [],options: .prettyPrinted)
            urlRequest.httpBody = bodyDictionary
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch let error {
            print(error.localizedDescription)
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if (data != nil && data?.count != 0){
                if let httpResponse = response as? HTTPURLResponse {
                    let response = String(data:data!,encoding: .utf8)
                    print("Inserted")
                    complication(httpResponse.statusCode)
                }
            }
        }.resume()
    }
}

