//
//  ProductsCollectionViewCell.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 01/06/2023.
//

import UIKit
import SDWebImage

class ProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var favObject : Product?
    var favouriteViewModel: FavViewModel?
    
    func setVieModel(favViewModel: FavViewModel) {
        self.favouriteViewModel = favViewModel
        
    }
    
    @IBAction func addTofavouriteButton(_ sender: Any) {
        
        if let favouriteViewModel = favouriteViewModel,
           favouriteViewModel.isExist(favouriteId: favObject?.id ?? 0){
            favouriteButton.tintColor = UIColor.darkGray
            favouriteViewModel.deleteItemById(favouriteId: favObject?.id ?? 0)
        } else {
            favouriteButton.tintColor = UIColor.red
            favouriteViewModel?.localDataSource?.insertItem(favouriteName: favObject?.title ?? "", favouriteId: favObject?.id ?? 0, favouriteImage: favObject?.image?.src ?? "", favouritePrice: productPrice.text ?? "")
        }
        
    }
    func setUpCell(product: Product){
        favObject = product
        if let favID = favObject?.id,
           let favouriteViewModel = favouriteViewModel, favouriteViewModel.isExist(favouriteId:favID){
            favouriteButton.tintColor = UIColor.red
        } else {
            favouriteButton.tintColor = UIColor.darkGray
            
        }
        self.productName.text = product.title
        self.productPrice.layer.borderWidth = 1
        self.productPrice.layer.cornerRadius = self.productPrice.frame.height / 2
        self.productPrice.text = product.variants?[0].price
        self.productImage.sd_setImage(with: URL(string:product.image?.src ?? ""), placeholderImage: UIImage(named: "placeHolder"))
    }
}
