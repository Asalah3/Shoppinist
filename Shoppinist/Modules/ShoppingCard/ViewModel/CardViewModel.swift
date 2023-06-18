////
////  CardViewModel.swift
////  Shoppinist
////
////  Created by Esraa AbdElfatah on 06/06/2023.
////
//
import Foundation
class ShoppingCartViewModel {
    var bindingCart : (()->()) = {}
    var cartList :[LineItem]?{
        didSet{
            bindingCart()
        }
    }
    var bindingCartt : (()->()) = {}
    var cartResult :AllDrafts?{
        didSet{
            bindingCartt()
        }
    }
    var cartsUrl = "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/draft_orders.json"
    
    func getShoppingCart() {
        CartNetwork.fetchUserCart{ result in
            guard let result = result else {return}
            self.cartList = result.draftOrder?.lineItems ?? [LineItem]()
            print("self.cartList = \(self.cartList?.count ?? 0)")
        }
    }
    
    
    
    func postNewCart(userCart: [String:Any], completion: @escaping (Data?, HTTPURLResponse?, Error?) -> ()) {
        CartNetwork.postCart(userCart:userCart) { data, response, error in
            guard error == nil else {
                completion(nil, nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, response as? HTTPURLResponse, error)
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
            _ = json["customer"] as? Dictionary<String,Any>
            
            completion(data, response as? HTTPURLResponse, nil)
        }
    }
    
    
    func getCart() {
        CartNetwork.CartfetchData(url: cartsUrl, handlerComplition:{ result in
            self.cartResult = result
//            print ("draft email\(result?.draft_order![1].email)")
        } )}
   

    func putNewCart(userCart: Drafts, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> ()) {
        CartNetwork.putCart(userCart:userCart) { data, response, error in
            guard error == nil else {
                completion(nil, nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, response as? HTTPURLResponse, error)
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,Any>
            _ = json["customer"] as? Dictionary<String,Any>
            
            completion(data, response as? HTTPURLResponse, nil)
        }
    }
    
    
    
    func deleteCart(completion: @escaping (Error?) -> ()) {
        CartNetwork.deleteCart { error in
            guard error == nil else {
                print("draft order deleting error")
                completion(error)
                return
            }
            print("draft order deleted")
            completion(nil)
        }
    }
    
    
    
}
    
