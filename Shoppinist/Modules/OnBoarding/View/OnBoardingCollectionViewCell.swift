//
//  OnBoardingCollectionViewCell.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 07/06/2023.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: OnBoardingCollectionViewCell.self)

    @IBOutlet weak var slideImage: UIImageView!
    
    @IBOutlet weak var slideTitle: UILabel!
    @IBOutlet weak var slideDescription: UILabel!
    func setUp(_ slide : OnBoardingSlide) {
        slideImage.image = slide.image
        slideTitle.text = slide.title
        slideDescription.text = slide.description
    }
}
