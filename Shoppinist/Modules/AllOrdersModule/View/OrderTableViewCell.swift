//
//  OrderTableViewCell.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 13/06/2023.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderTotalPrice: UILabel!
    @IBOutlet weak var orderCreationDate: UILabel!
    @IBOutlet weak var orderShippedTo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setUpCell(order: Order) {
        self.orderCreationDate.text = order.createdAt
        self.orderTotalPrice.text = order.note
        let shippingAdress = order.shippingAddress
        let shippedTo = "\(shippingAdress?.country ?? ""), \( shippingAdress?.city ?? ""), \(shippingAdress?.address1 ?? "")"
        self.orderShippedTo.text = shippedTo
    }

}
