//
//  LoginViewModel.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 03/06/2023.
//

// UserDefaults Keys
/*
 customerID
 customerFirsttName
 customerEmail
 */

import Foundation

class LoginViewModel{
    
    var bindingLogin:(()->()) = {}
    var observableLogin : AllLoginedCustomers? {
        didSet {
            bindingLogin()
        }
    }
    
    func getAllCustomers(){
        LoginNetworkService.loadDataFromURL { returnedCustomers,_ in
            self.observableLogin = returnedCustomers
        }
    }
    
    func checkCustomerAuth(customerEmail:String,customerPasssword:String)->String{
        var returnedValue = "Uncorrect Email or Password"
        
        if let observable = observableLogin {
            print(observable.customers.count)
            for i in 0..<(observable.customers.count){
                if customerEmail == observable.customers[i].email && customerPasssword == observable.customers[i].note{
                    returnedValue = "Login Success"
                    UserDefaults.standard.set(observable.customers[i].first_name, forKey: "customerFirsttName")
                    UserDefaultsManager.sharedInstance.setUserEmail(userEmail: observable.customers[i].email)
                    UserDefaultsManager.sharedInstance.setUserID(customerID: observable.customers[i].id)
                    let userDefultId =  UserDefaults.standard.integer(forKey:"customerID")
                    print("User id is", userDefultId)
                    break
                }
            }
        }
        return returnedValue
    }
    
}
