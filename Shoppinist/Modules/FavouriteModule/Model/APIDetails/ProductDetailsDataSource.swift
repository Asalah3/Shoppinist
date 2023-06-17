//
//  ProductDetailsDataSource.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 04/06/2023.
//

import Foundation

protocol ProductDetailsDataSourceProtocol{
    static func fetchProductDetails(product_id:Int, compilitionHandler: @escaping (ProductDetailsModel?) -> Void)
    static func fetchFavProductDetails(product_id:String, compilitionHandler: @escaping (FavProductDetailsModel?) -> Void)

}
class ProductDetailsDataSource: ProductDetailsDataSourceProtocol{
    
    static func fetchFavProductDetails(product_id: String, compilitionHandler: @escaping (FavProductDetailsModel?) -> Void) {
        let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/products.json?ids=\(product_id)")
        guard let newUrl = url else {
            return
        }
        print("newUrl\(newUrl)")
        let request = URLRequest(url: newUrl)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request){ data ,response , error in
            do{
                print("fav data is \(data)")
                let result = try JSONDecoder().decode(FavProductDetailsModel.self, from: data ?? Data())
                print("fav data is \(result)")
                compilitionHandler(result)
                print("success in details")
                print("result \(result)")


            }catch let error{
                print(error.localizedDescription)
                print("error in details")
                compilitionHandler(nil)
            }
            
        }
        task.resume()
    }
    
    
   static func fetchProductDetails(product_id: Int, compilitionHandler: @escaping (ProductDetailsModel?) -> Void){
        print(product_id)
        let url = URL(string: "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/products/\(product_id).json")
        guard let newUrl = url else {
            return
        }
        print("newUrl\(newUrl)")
        let request = URLRequest(url: newUrl)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request){ data ,response , error in
            do{
                let result = try JSONDecoder().decode(ProductDetailsModel.self, from: data ?? Data())
                compilitionHandler(result)
                print("success in details")
                print("result \(result)")


            }catch let error{
                print(error.localizedDescription)
                print("error in details")
                compilitionHandler(nil)
            }
            
        }
        task.resume()
    }
}
