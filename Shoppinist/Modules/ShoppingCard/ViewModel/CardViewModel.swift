////
////  CardViewModel.swift
////  Shoppinist
////
////  Created by Esraa AbdElfatah on 06/06/2023.
////
//
//import Foundation
//class ShoppingCartViewModel {
//    var bindingCart : (()->()) = {}
//    var cartList :[LineItem]?{
//        didSet{
//            bindingCart()
//        }
//    }
//    var bindingCartt : (()->()) = {}
//    var cartResult :ShoppingCart?{
//        didSet{
//            bindingCartt()
//        }
//    }
//    var cartsUrl = "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/draft_orders.json"
//    
//    func getShoppingCart() {
//        CartNetwork.sharedInstance.fetchUserCart(handlerComplition: { result in
//            if let result = result {
//                self.cartList = result.draft_order?.line_items
//            }
//        })
//    }
//    
//    
//    
//    func postNewCart(userCart: [String:Any], completion: @escaping (Data?, HTTPURLResponse?, Error?) -> ()) {
//        CartNetwork.sharedInstance.postCart(userCart:userCart) { data, response, error in
//            guard error == nil else {
//                completion(nil, nil, error)
//                return
//            }
//            
//            guard let data = data else {
//                completion(nil, response as? HTTPURLResponse, error)
//                return
//            }
//            
//            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
//            _ = json["customer"] as? Dictionary<String,Any>
//            
//            completion(data, response as? HTTPURLResponse, nil)
//        }
//    }
//    
//    
//    func getAllDrafts(){
//        CartNetwork.sharedInstance.CartfetchData() { returnedDrafts ,_ in
//            self.cartResult = returnedDrafts
//        }
//    }
//    
//    
//    func putNewCart(userCart: ShoppingCartPut, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> ()) {
//        CartNetwork.sharedInstance.putCart(userCart:userCart) { data, response, error in
//            guard error == nil else {
//                completion(nil, nil, error)
//                return
//            }
//            
//            guard let data = data else {
//                completion(nil, response as? HTTPURLResponse, error)
//                return
//            }
//            
//            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
//            _ = json["customer"] as? Dictionary<String,Any>
//            
//            completion(data, response as? HTTPURLResponse, nil)
//        }
//    }
//    
//    
//    
//    func deleteCart(completion: @escaping (Error?) -> ()) {
//        CartNetwork.sharedInstance.deleteCart { error in
//            guard error == nil else {
//                print("draft order deleting error")
//                completion(error)
//                return
//            }
//            print("draft order deleted")
//            completion(nil)
//        }
//    }
//    
//    
//    
//}
//    
//    