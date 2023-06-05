//
//  FavouriteCollectionViewCell.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 03/06/2023.
//

import UIKit
import SDWebImage
import CoreData

class FavouriteCollectionViewCell: UICollectionViewCell {
    
    var favouriteViewModel : FavViewModelProtocol?
    var favItem : NSManagedObject?
    var favouriteCollectionView: UICollectionView?
    
    @IBOutlet weak var favName: UILabel!
    @IBOutlet weak var favPrice: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var favButton: UIButton!
        
    @IBAction func deleteFromFavourites(_ sender: Any) {
        favouriteViewModel?.deleteFavouriteItem(favouriteItem: favItem ?? NSManagedObject())
        favouriteCollectionView?.reloadData()
    }
    
    func setViewModel(favouriteViewModel : FavViewModelProtocol, favCollection: UICollectionView){
        self.favouriteViewModel = favouriteViewModel
        self.favouriteCollectionView = favCollection
    }
    
    func setUpCell(favouriteItem: NSManagedObject){
        self.favPrice.layer.borderWidth = 1
        self.favPrice.layer.cornerRadius = self.favPrice.frame.height / 2
        
        self.favItem = favouriteItem
        
        favButton.tintColor = UIColor.red
        let image : String = favouriteItem.value(forKey: "image") as? String ?? ""
        favImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeHolder"))
        favName.text = favouriteItem.value(forKey: "name") as? String
        favPrice.text = favouriteItem.value(forKey: "price") as? String
        print("favcellid \(favouriteItem.value(forKey: "id") as? Int)")
        
    }
    
}
