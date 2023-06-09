//
//  CouponsCollectionViewCell.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 01/06/2023.
//

import UIKit

class CouponsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var couponImage: UIImageView!
    
}

struct coupon {
    var img : UIImage
    var id : String
}
