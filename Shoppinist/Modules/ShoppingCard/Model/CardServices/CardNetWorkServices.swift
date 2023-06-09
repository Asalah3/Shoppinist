////
////  CardNetWorkServices.swift
////  Shoppinist
////
////  Created by Esraa AbdElfatah on 06/06/2023.
////
//
import Foundation

class CartNetwork {
    static var sharedInstance = CartNetwork()
    private init(){}
    
    func fetchUserCart (handlerComplition : @escaping (Drafts?)->Void) {
        let draftOrderID = UserDefaultsManager.sharedInstance.getUserCart() ?? 0
        print("draftOrderID \(draftOrderID)")
        print("email\(UserDefaultsManager.sharedInstance.getUserEmail())")
        print("id\(UserDefaultsManager.sharedInstance.getUserID())")
       let requestURL: NSURL = NSURL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/draft_orders/\(draftOrderID).json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            if let data = data {
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200 && statusCode < 300) {
                    print("Everyone is fine, file downloaded successfully.")
                    do{
                        let json = try JSONDecoder().decode(Drafts.self , from: data) as? Drafts
                        
                        //print(json)
                         handlerComplition(json)
                    }
                    catch{ print("erroMsg") }
                    handlerComplition(nil)
                } else  {
                    print("Failed: \(String(describing: response) )")
                    handlerComplition(nil)
                }
            }
        }
                task.resume()
    }
    
    
    func postCart(userCart: [String:Any], completionHandler:@escaping (Data?, URLResponse? , Error?)->()){
        guard let url = URL(string: URLService.draftCart()) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: userCart, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
            
        }.resume()
    }
    
      func CartfetchData(completionHandeler: @escaping ((AllDrafts?), Error?) -> Void) {
            let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/draft_orders.json")
            guard let newUrl = url else {
                return
            }
            print("newUrl\(newUrl)")
            let request = URLRequest(url: newUrl)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request){ data ,response , error in
                do{
                    let result = try JSONDecoder().decode(AllDrafts?.self, from: data ?? Data())
                    completionHandeler(result, nil)
                    print("success in getDrafts")
    
    
                }catch let error{
                    print(error.localizedDescription)
                    print("error in getDrafts")
                    completionHandeler(nil, error)
                }
    
            }
            task.resume()
        }
    
    func putCart(userCart: Drafts , completionHandler:@escaping (Data?, URLResponse? , Error?)->()){
        let cartId = UserDefaultsManager.sharedInstance.getUserCart()!
        guard let url = URL(string: URLService.putCart(lineId:cartId)) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: userCart.asDictionary(), options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }.resume()
    }
    
    func deleteCart(completion: @escaping ( Error?) -> ()){
       let draftOrderID = UserDefaults.standard.integer(forKey: "Cart_ID")
        let url = URLService.deleteCart(cartID: draftOrderID)
        guard let baseURL = URL(string : url ) else { return }
        var request = URLRequest(url: baseURL)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        request.httpShouldHandleCookies = false
        
        do{
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling DELETE")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print(response)
                    print("Error: HTTP request failed")
                    return
                }
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print("Draft order successfully deleted")
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
