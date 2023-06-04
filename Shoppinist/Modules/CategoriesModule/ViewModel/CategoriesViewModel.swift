//
//  CategoriesViewModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 03/06/2023.
//

import Foundation
enum Categories{
    case Men
    case Women
    case Kids
    case Sale
}
protocol CategoriesViewModelProtocol{
    func fetchCategoriesData(category: Categories)
}
class CategoriesViewModel : CategoriesViewModelProtocol {
    
    
    var remote :RemoteDataSourceProtocol?
    init( remoteDataSource: RemoteDataSourceProtocol) {
        self.remote = remoteDataSource
    }
    var fetchProductsToCategoriesViewController : (()->())={}
    var fetchCategoryData:ProductModel!{
        didSet{
            fetchProductsToCategoriesViewController()
        }
    }
    func fetchCategoriesData(category: Categories) {
        var collectionId = ""
        switch category{
        case Categories.Men:
            collectionId = "447912870180"
        case Categories.Women:
            collectionId = "447912902948"
        case Categories.Kids:
            collectionId = "447912935716"
        case Categories.Sale:
            collectionId = "447912968484"
        }
        remote?.fetchCategoryProducts(collection_id: "\(collectionId)"){ [weak self] result in
            guard let result = result else {return}
            self?.fetchCategoryData = result
        }
    }
    
    func filterBySubFilter(filter : String) -> [Product]{
        let productsList : [Product] = self.fetchCategoryData?.products ?? []
        let filterdList = productsList.filter{ $0.productType == filter}
        return filterdList
    }
}
