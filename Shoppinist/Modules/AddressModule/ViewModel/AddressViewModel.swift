//
//  AddressViewModel.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 04/06/2023.
//

import Foundation

class AddressViewModel {
    
    var bindingGet :(()->())?
    var bindingStatusCode :((Int)->Void) = {_ in }
   
    var statusCode : Int = 0{
        didSet{
            bindingStatusCode(statusCode)
        }
    }
    
    var ObservableGet : CustomerAddress? {
        didSet {
            bindingGet!()
        }
    }
    
    func deleteAddress(AddressId : Int , CustomerId : Int){
        AddressNetworkServices.deleteAddress(Address_Id: AddressId, Customer_Id: CustomerId) { [weak self] code in
            self?.statusCode = code
        }
    }
    
    
    func getAddress() {
        AddressNetworkServices.getAddress { retriveAddress, _ in
            self.ObservableGet = retriveAddress
        }
    }
}
