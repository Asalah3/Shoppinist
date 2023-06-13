//
//  CategoriesNetworkLayer.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 13/06/2023.
//

import Foundation
protocol CategoriesRemoteDataSourceProtocol{

    func fetchCategoryProducts(collection_id:String, compilitionHandler: @escaping (ProductModel?) -> Void)
}
class CategoriesRemoteDataSource: CategoriesRemoteDataSourceProtocol{
    func fetchCategoryProducts(collection_id:String, compilitionHandler: @escaping (ProductModel?) -> Void) {
        let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/products.json?collection_id=\(collection_id)")
        print("collectionid \(collection_id)")
        guard let newUrl = url else {
            return
        }
        var request = URLRequest(url: newUrl)
        request.allHTTPHeaderFields = ["auth_header": "request.auth_header",
                                       "cookies": "request.cookies"]
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request){ data,response , error in
            do{
                let result = try JSONDecoder().decode(ProductModel.self, from: data ?? Data())
                compilitionHandler(result)
                print(result.products?[0].id)
                print("sucsses ")
            } catch let error{
                print(error)
                compilitionHandler(nil)
                print("fail ")
            }
        }
        task.resume()
    }
}
