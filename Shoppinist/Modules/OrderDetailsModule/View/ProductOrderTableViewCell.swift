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
        self.productImage.clipsToBounds = true
        self.productImage.layer.cornerRadius = 25
        let myString = lineItem.sku ?? ""
        let myArray = myString.split(separator: ",")
        let img = String(myArray[1])
        self.productImage.sd_setImage(with: URL(string:img), placeholderImage: UIImage(named: "placeHolder"))
        self.productName.text = lineItem.name
        if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
            let cur = (UserDefaults.standard.double(forKey: "EGP"))
            let price = floor((Double(lineItem.price ?? "0.0") ?? 0.0) * cur)
            self.productPrice.text = "Price: \(String(price)) EGP"
        }else{
            self.productPrice.text = "Price: \(lineItem.price ?? "") $"
        }
        self.productQuantity.text = "Quantity: \(lineItem.quantity ?? 0)"
    }

}
