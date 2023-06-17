//
//  ProductOrderTableViewCell.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 15/06/2023.
//

import UIKit

class ProductOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setUpCell(lineItem: LineItem){
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.cornerRadius = 25
        self.containerView.layer.borderColor = UIColor.systemGray.cgColor
        self.productImage.sd_setImage(with: URL(string:lineItem.sku ?? ""), placeholderImage: UIImage(named: "placeHolder"))
        self.productName.text = lineItem.name
        if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
            var cur = (UserDefaults.standard.double(forKey: "EGP"))
            let price = floor((Double(lineItem.price ?? "0.0") ?? 0.0) * cur)
            self.productPrice.text = "\(String(price)) EGP"
        }else{
            self.productPrice.text = "\(lineItem.price ?? "") $"
        }
        self.productQuantity.text = "\(lineItem.quantity ?? 0)"
    }

}
