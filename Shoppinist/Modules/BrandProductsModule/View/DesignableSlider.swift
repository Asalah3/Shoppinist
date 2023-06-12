//
//  DesignableSlider.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 12/06/2023.
//

import UIKit
@IBDesignable
class DesignableSlider: UISlider {
    @IBInspectable var thumbImage: UIImage?{
        didSet {
            setThumbImage(thumbImage, for: .normal)
        }
    }
}
