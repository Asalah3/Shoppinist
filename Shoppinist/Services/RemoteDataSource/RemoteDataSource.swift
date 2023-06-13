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
        let url = URL(string: "https://api.currencyfreaks.com/v2.0/rates/latest?apikey=4bd3f7d6a381431baf16cc49836c87f0&base=usd&symbols=egp")
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
