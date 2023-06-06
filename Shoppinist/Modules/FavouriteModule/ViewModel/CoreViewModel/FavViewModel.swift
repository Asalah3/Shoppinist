//
//  FavViewModel.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 04/06/2023.
//

import Foundation
import CoreData


protocol FavViewModelProtocol{
    func getFavouritesResult() -> [NSManagedObject]
    func deleteFavouriteItem(favouriteItem : NSManagedObject)
    func deleteItemById(favouriteId : Int)
    func isExist(favouriteId : Int) -> Bool
    func getProductDetails(productID : Int)
}

class FavViewModel : FavViewModelProtocol{
    
    var localDataSource: FavLocalDataSourceProtocol?
    var remoteDataSource: ProductDetailsDataSourceProtocol?
    
    var fetchProductsDetailsToViewController : (()->())={}
    var fetchProductData:Product!{
        didSet{
            fetchProductsDetailsToViewController()
        }
    }
    
    init(localDataSource: FavLocalDataSourceProtocol, remoteDataSource: ProductDetailsDataSourceProtocol) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    //--------------get from API-----------------
    func getProductDetails(productID : Int) {
        remoteDataSource?.fetchProductDetails(product_id: productID){ result in
            guard let result = result else {return}
            print("itemdata \(result)")
            self.fetchProductData = result.product
        }
    }
    
    
    //--------------get from CoreData-----------------
    func getFavouritesResult() -> [NSManagedObject]{
        return localDataSource?.fetchFavouriteItems() ?? []
    }
    func deleteFavouriteItem(favouriteItem : NSManagedObject){
        localDataSource?.deleteItem(favouriteItem: favouriteItem)
    }
    func deleteItemById(favouriteId : Int){
        localDataSource?.deleteItemById(favouriteId: favouriteId)
    }
    func isExist(favouriteId : Int) -> Bool{
        return localDataSource?.checkIfInserted(favouriteId: favouriteId) ?? false
    }
}
