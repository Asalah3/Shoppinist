////
////  UserDefultManager.swift
////  Shoppinist
////
////  Created by Esraa AbdElfatah on 06/06/2023.
////
//
import Foundation
class UserDefaultsManager {
    
    static let sharedInstance = UserDefaultsManager()
    
    private init() {
        
    }
    func setUserCart(cartId: Int?){
        UserDefaults.standard.set(cartId, forKey: "Cart_ID")
    }
    func getUserCart()-> Int?{
        return UserDefaults.standard.integer(forKey: "Cart_ID")
    }
    
    func setCartState(cartState: Bool) {
        UserDefaults.standard.set(cartState, forKey: "Cart_State")
    }
    
    func getCartState() -> Bool{
        return UserDefaults.standard.bool(forKey: "Cart_State")
    }
    func setUserEmail(userEmail: String?){
        UserDefaults.standard.set(userEmail, forKey: "customerEmail")
    }
    
    func getUserEmail()-> String?{
        return UserDefaults.standard.string(forKey: "customerEmail")
    }
    func setUserID(customerID: Int?){
        UserDefaults.standard.set(customerID, forKey: "customerID")
    }
    
    func getUserID()-> Int?{
        return UserDefaults.standard.integer(forKey: "customerID")
    }
    
    func setUserCoupon(userCoupon: String){
        UserDefaults.standard.set(userCoupon, forKey: "Coupon")
    }
    
    func getUserCoupon()-> String{
        return UserDefaults.standard.string(forKey: "Coupon") ?? ""
    }
    
    func clearUserDefaults() {
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }
}
