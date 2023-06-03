//
//  AddAddressViewModel.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 03/06/2023.
//

import Foundation

class AddAddressviewModel{
    
    var bindingAddress:(()->())?
    
    var ObservableAddress : Int? {
        didSet {
            bindingAddress!()
        }
    }
    let id = UserDefaults.standard.integer(forKey:"customerID")
    func CreateAddress(createAddress: Address) {
       
        AddressNetworkServices.CreateAddress(customerId: id, address: createAddress) { check in
            self.ObservableAddress = check
        }
    }
    
}
