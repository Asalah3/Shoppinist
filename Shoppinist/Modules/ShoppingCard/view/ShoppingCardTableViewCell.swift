//
//  ShoppingCardTableViewCell.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 04/06/2023.
//

import UIKit



class ShoppingCardTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    var counter = 1
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var priceButton: UILabel!
    @IBOutlet weak var plusButton: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var increaseItem: UIButton!
    @IBOutlet weak var decreseItem: UIButton!
    var indexPath: IndexPath!
    var lineItem : LineItem!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func minusButton(_ sender: Any) {
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    func setUpCell(){
        var unwrappedImage : String = ""
//        var productID : Int = 0
        priceButton.text = lineItem?.price
        let myString = lineItem?.sku ?? ""
        print("myString\(myString)")
        let myArray = myString.split(separator: ",")
//        productID = Int(myArray[0]) ?? 0
        unwrappedImage = String(myArray[1])
        print("unwrappedImage\(unwrappedImage)")
//        productID = Int(productsList?[indexPath.row].sku ?? "") ?? 0
        name.text = lineItem?.title
        quantityLabel.text = "\(lineItem?.quantity ?? 1)"
        img.sd_setImage(with: URL(string: unwrappedImage), placeholderImage: UIImage(named: "placeHolder"))
    }
    @IBAction func plusButton(_ sender: Any) {
        
    }
}
