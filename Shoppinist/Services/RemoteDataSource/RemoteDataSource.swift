//
//  RemoteDataSource.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 31/05/2023.
//

import Foundation

protocol RemoteDataSourceProtocol{
    func getCurrency(compilitionHandler: @escaping (CurrenyModel?) -> Void)
}
class RemoteDataSource: RemoteDataSourceProtocol{
    func getCurrency(compilitionHandler: @escaping (CurrenyModel?) -> Void) {
        let url = URL(string: "https://api.currencyfreaks.com/v2.0/rates/latest?apikey=152bfa1859934bf996d578d0315e0f2f&base=usd&symbols=egp")
        guard let newUrl = url else {
            return
        }
        let request = URLRequest(url: newUrl)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request){ data,response , error in
            do{
                let result = try JSONDecoder().decode(CurrenyModel.self, from: data ?? Data())
                compilitionHandler(result)
                print("sucsses")
            } catch let error{
                print(error)
                compilitionHandler(nil)
                print("fail ")
            }
        }
        task.resume()
    }
}
