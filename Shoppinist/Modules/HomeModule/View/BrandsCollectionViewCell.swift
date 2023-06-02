//
//  BrandsCollectionViewCell.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 01/06/2023.
//

import UIKit
import SDWebImage

class BrandsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var brandName: UILabel!
    
    func setUpCell(brandImage: String , brandName: String){
        self.brandName.text = brandName
        self.brandImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.brandImage.sd_setImage(with: URL(string:brandImage), placeholderImage: UIImage(named: "placeHolder"))
    }
}
