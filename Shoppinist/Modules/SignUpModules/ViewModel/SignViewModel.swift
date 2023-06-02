//
//  SignViewModel.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 03/06/2023.
//

import Foundation

class SignViewModel{
    
    var bindingSignUp:(()->()) = {}
    var ObservableSignUp : Int? {
        didSet {
            bindingSignUp()
        }
    }
    
func insertCustomer(customer:Customer){
    SignUpNetworkService.customerRegister(newCustomer: customer) { checkSignAblitiy in
        self.ObservableSignUp = checkSignAblitiy
    }
    }
   
    
}
