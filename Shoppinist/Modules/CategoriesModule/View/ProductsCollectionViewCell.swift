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
    
    @IBAction func addTofavouriteButton(_ sender: Any) {
    }
    func setUpCell(productImage: String, productName:String, productPrice:String){
        self.productName.text = productName
        self.productPrice.layer.borderWidth = 1
        self.productPrice.layer.cornerRadius = self.productPrice.frame.height / 2
        self.productPrice.text = productPrice
        self.productImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        self.productImage.sd_setImage(with: URL(string:productImage), placeholderImage: UIImage(named: "placeHolder"))
    }
}
