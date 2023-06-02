//
//  CouponsCollectionViewCell.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 01/06/2023.
//

import UIKit

class CouponsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var couponImage: UIImageView!
    func setUpCell(couponImage: String){
        self.couponImage.image = UIImage(named: couponImage)
    }}
