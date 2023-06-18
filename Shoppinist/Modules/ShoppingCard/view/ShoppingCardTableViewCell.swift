//
//  ShoppingCardTableViewCell.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 04/06/2023.
//

import UIKit

protocol CounterProtocol {
    func increaseCounter(price: String)
    func decreaseCounter(price: String)
    func setItemQuantityToPut(quantity: Int , index: Int)
    
}

class ShoppingCardTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    var counter = 1
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var priceButton: UILabel!
    @IBOutlet weak var plusButton: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var increaseItem: UIButton!
    var counterProtocol: CounterProtocol?
    @IBOutlet weak var decreseItem: UIButton!
    var indexPath: IndexPath!
    var lineItem : [LineItem]!
    var item : LineItem?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        counterProtocol = CounterProtocol.self as? CounterProtocol
    }

    @IBAction func minusButton(_ sender: Any) {
        if counter > 1 {
            counter = counter - 1
            item?.quantity = counter
            let price = Double(priceButton.text ?? "0.0")
            quantityLabel.text = String (counter)
            priceButton.text = "\((price ?? 0.0) - (Double(item?.price ?? "0.0") ?? 0.0))"
            counterProtocol?.decreaseCounter(price: priceButton.text ?? "")
            counterProtocol?.setItemQuantityToPut(quantity: counter, index: indexPath.row)
//            counter = counter - 1
//            lineItem[indexPath.row].quantity = counter
//            quantityLabel.text = String (counter)
//            counterProtocol?.decreaseCounter(price: lineItem[indexPath.row].price ?? "")
//            counterProtocol?.setItemQuantityToPut(quantity: counter, index: indexPath.row)
        }

        disableDecreaseBtn()
        
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    @IBAction func plusButton(_ sender: Any) {
        if counter < ((item?.grams ?? 1) - 2){
            counter += 1
            var price = Double(item?.price ?? "0.0")
            quantityLabel.text = String (counter)
            priceButton.text = "\(Double(counter) * (price ?? 0.0))"
            counterProtocol?.increaseCounter(price: priceButton.text ?? "")
            counterProtocol?.setItemQuantityToPut(quantity: counter, index: indexPath.row)
        }
        
//        if counter < ((lineItem[indexPath.row].grams ?? 1) - 2) {
//            counter = counter + 1
//            quantityLabel.text = String (counter)
//            lineItem[indexPath.row].quantity = counter
//            counterProtocol?.increaseCounter()
//            counterProtocol?.setItemQuantityToPut(quantity: counter, index: indexPath.row)
//        }
//         else
//        {
////             Utilites.displayAlert(title: "Warning", message: "", action: UIAlertAction, controller: UIViewController)
//        }

        disableDecreaseBtn()
    }
    func disableDecreaseBtn (){
        if counter < 2
        {
            decreseItem.isEnabled = true
            decreseItem.alpha = 0.5
        }
        else {
            decreseItem.isEnabled = true
            decreseItem.alpha = 1
        }
    }
}
