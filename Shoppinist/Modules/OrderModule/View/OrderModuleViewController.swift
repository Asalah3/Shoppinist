//
//  OrderModuleViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 05/06/2023.
//

import UIKit

class OrderModuleViewController: UIViewController {

    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var paymentType: UILabel!
    @IBOutlet weak var coupon: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var discountAmount: UILabel!
    @IBOutlet weak var shippingFees: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func placeOrderButton(_ sender: Any) {
    }
    
}
