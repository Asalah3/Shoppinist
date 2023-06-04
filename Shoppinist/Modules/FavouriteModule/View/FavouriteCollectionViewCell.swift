//
//  FavouriteCollectionViewCell.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 03/06/2023.
//

import UIKit
import SDWebImage

class FavouriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var favName: UILabel!
    @IBOutlet weak var favPrice: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    
    @IBAction func deleteFromFavourites(_ sender: Any) {
    }
    
    func setUpCell(favouriteImage: String, favouriteName:String, favouritePrice:String){
        self.favName.text = favouriteName
        self.favPrice.layer.borderWidth = 1
        self.favPrice.layer.cornerRadius = self.favPrice.frame.height / 2
        self.favPrice.text = favouritePrice
        self.favImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        self.favImage.sd_setImage(with: URL(string:favouriteImage), placeholderImage: UIImage(named: "placeHolder"))
        self.favImage.image = UIImage(named: favouriteImage)
    }
    
    
}
