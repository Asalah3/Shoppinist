//
//  CategoriesViewModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 03/06/2023.
//

import Foundation
enum Categories : String{
    case Men = "447912870180"
    case Women = "447912902948"
    case Kids = "447912935716"
    case Sale = "447912968484"
}
protocol CategoriesViewModelProtocol{
    func fetchCategoriesData(category: Categories)
    func filterBySubFilter(filter : String) -> [Product]
    var fetchProductsToCategoriesViewController : (()->()) {get set}
    var fetchCategoryData:ProductModel!{get set}
}
class CategoriesViewModel : CategoriesViewModelProtocol {
    
    
    var remote : CategoriesRemoteDataSourceProtocol?
    init( remoteDataSource: CategoriesRemoteDataSourceProtocol) {
        self.remote = remoteDataSource
    }
    var fetchProductsToCategoriesViewController : (()->())={}
    var fetchCategoryData:ProductModel!{
        didSet{
            fetchProductsToCategoriesViewController()
        }
    }
    func fetchCategoriesData(category: Categories) {
        remote?.fetchCategoryProducts(collection_id: category.rawValue){ [weak self] result in
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
