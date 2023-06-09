//
//  BrandProductsViewModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 02/06/2023.
//

import Foundation
protocol BrandProductsViewModelProtocol{
    func fetchBrandProducts(collectionId :Int)
    var fetchProductsToBrandProductsViewController : (()->()){get set}
    var fetchProductsData:[Product]!{get set}
}
class BrandProductsViewModel : BrandProductsViewModelProtocol{
    var remote :BrandProductsRemoteDataSourceProtocol?
    init( remoteDataSource: BrandProductsRemoteDataSourceProtocol) {
        self.remote = remoteDataSource
    }
    var fetchProductsToBrandProductsViewController : (()->())={}
    var fetchProductsData:[Product]!{
        didSet{
            fetchProductsToBrandProductsViewController()
        }
    }
    func fetchBrandProducts(collectionId :Int) {
        remote?.fetchBrandProducts(collection_id: "\(collectionId)"){ result in
            let sortedList = result?.products?.sorted(by:{Double($0.variants?[0].price ?? "0.0") ?? 0.0 < Double($1.variants?[0].price ?? "0.0") ?? 0.0})
            guard let result = sortedList else {return}
            self.fetchProductsData = result
        }
    }
    
    
}
