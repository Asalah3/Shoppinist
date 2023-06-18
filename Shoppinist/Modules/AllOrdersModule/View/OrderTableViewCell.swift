//
//  OrderTableViewCell.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 13/06/2023.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var orderTotalPrice: UILabel!
    @IBOutlet weak var orderCreationDate: UILabel!
    @IBOutlet weak var orderShippedTo: UILabel!
    @IBOutlet weak var containerView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setUpCell(order: Order) {
        self.orderCreationDate.text = order.createdAt
        if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
            var cur = (UserDefaults.standard.double(forKey: "EGP"))
           
            self.orderTotalPrice.text = "\((Float(order.note ?? "0.0") ?? 0.0) * Float(cur)) EGP"
        }else{
            self.orderTotalPrice.text = "\(order.note ?? "0.0" ) $"
            
        }
        let shippingAdress = order.shippingAddress
        let shippedTo = "\(shippingAdress?.country ?? ""), \( shippingAdress?.city ?? ""), \(shippingAdress?.address1 ?? "")"
        let phoneNumber = "\(shippingAdress?.phone ?? "")"
        self.orderShippedTo.text = shippedTo
        self.phone.text = phoneNumber
    }

}
