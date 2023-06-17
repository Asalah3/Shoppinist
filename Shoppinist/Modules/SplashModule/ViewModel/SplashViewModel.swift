//
//  SplashViewModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 17/06/2023.
//

import Foundation
class SplashViewModel{
    var fetchCurrencyToCell : (()->())={}
    var fetchCurrencyData:CurrenyModel!{
        didSet{
            fetchCurrencyToCell()
        }
    }
    func checkCurreny() -> Bool{
        var result = false
        if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
            result = true
        }
        return result
    }
    func changeCurrency() {
        RemoteDataSource().getCurrency{curreny in
            guard let curreny = curreny else {return}
            print("currency is \(curreny)")
            self.fetchCurrencyData = curreny
        }
    }
}
