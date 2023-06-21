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
        let url = URL(string: "https://api.currencyfreaks.com/v2.0/rates/latest?apikey=08d217ba01994c1bb9b4e2a3d78449e7&base=usd&symbols=egp")
        guard let newUrl = url else {
            return
        }
        let request = URLRequest(url: newUrl)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request){ data,response , error in
            do{
                let result = try JSONDecoder().decode(CurrenyModel.self, from: data ?? Data())
                compilitionHandler(result)
            } catch let error{
                print(error)
                compilitionHandler(nil)
            }
        }
        task.resume()
    }
}
