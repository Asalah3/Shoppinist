//
//  FavLocalDataSource.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 04/06/2023.
//

import Foundation
import UIKit
import CoreData

protocol FavLocalDataSourceProtocol{
    func fetchFavouriteItems() -> [NSManagedObject]
    func InsertItem(favouriteName : String , favouriteId : Int , favouriteImage : String, favouritePrice: String)
    func deleteItem(favouriteItem : NSManagedObject)
    func deleteItemById(favouriteId : Int)
    func checkIfInserted(favouriteId : Int) -> Bool
}
class FavLocalDataSource: FavLocalDataSourceProtocol{
    var context : NSManagedObjectContext?
    var entity : NSEntityDescription?
    
     init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "FavProduct", in: context!)
    }
    
    
    func InsertItem(favouriteName : String , favouriteId : Int , favouriteImage : String, favouritePrice: String){
        let newItem = NSManagedObject(entity: entity ?? NSEntityDescription(), insertInto: context)
        newItem.setValue(favouriteId, forKey: "id")
        newItem.setValue(favouriteName, forKey: "name")
        newItem.setValue(favouriteImage, forKey: "image")
        newItem.setValue(favouritePrice, forKey: "price")
        
        do {
            try context?.save()
         } catch {
          print("Error saving")
        }
    }
    
    func deleteItem(favouriteItem : NSManagedObject){
        do {
            context?.delete(favouriteItem)
            try context?.save()
        } catch {
            print("Failed")
            
        }
    }
    
    func deleteItemById(favouriteId : Int){
        var favouriteItem : NSManagedObject?
        var favouritesList : [NSManagedObject]?
        favouritesList = fetchFavouriteItems()
        favouritesList?.forEach{ data in
            let favId = data.value(forKey: "id") as? Int
            if favId == favouriteId{
                favouriteItem = data
                do {
                    context?.delete(favouriteItem ?? NSManagedObject())
                    try context?.save()
                } catch {
                    print("Failed")
                    
                }
            }
        }
        
    }
    
    func fetchFavouriteItems() -> [NSManagedObject]{
        var favouritesList : [NSManagedObject]?
        favouritesList = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavProduct")
        request.returnsObjectsAsFaults = false
        do {
            if let result = try context?.fetch(request) as? [NSManagedObject]{
                for data in result{
                    favouritesList?.append(data)
                }
            }
            
        } catch {
            print("Failed")
        }
        return favouritesList ?? []
    }
    
    
    func checkIfInserted(favouriteId : Int) -> Bool {
        var result = false
        var favouritesList : [NSManagedObject]?
        favouritesList = fetchFavouriteItems()
        favouritesList?.forEach{ data in
            let favId = data.value(forKey: "id") as? Int
            if favId == favouriteId{
                result =  true
            }
        }
        return result
    }
    
}

