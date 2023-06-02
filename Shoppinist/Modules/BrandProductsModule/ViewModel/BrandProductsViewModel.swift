//
//  BrandProductsViewModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 02/06/2023.
//

import Foundation
protocol BrandProductsViewModelProtocol{
    func fetchBrandProducts(collectionId :Int)
}
class BrandProductsViewModel : BrandProductsViewModelProtocol{
    var remote :RemoteDataSourceProtocol?
    init( remoteDataSource: RemoteDataSourceProtocol) {
        self.remote = remoteDataSource
    }
    var fetchProductsToBrandProductsViewController : (()->())={}
    var fetchProductsData:ProductModel!{
        didSet{
            fetchProductsToBrandProductsViewController()
        }
    }
    func fetchBrandProducts(collectionId :Int) {
        remote?.fetchBrandProducts(collection_id: "\(collectionId)"){ result in
            guard let result = result else {return}
            self.fetchProductsData = result
        }
    }
    
    
}
