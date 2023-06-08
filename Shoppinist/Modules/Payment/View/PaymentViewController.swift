//
//  PaymentViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 08/06/2023.
//

import UIKit

class PaymentViewController: UIViewController {
    @IBOutlet weak var applePaymentButton: UIButton!
    
    @IBOutlet weak var coupounTextField: UITextField!
    @IBOutlet weak var cashPaymentButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilites.setUpTextFeildStyleAddress(textField: coupounTextField)
       
    }
    

    @IBAction func cashButton(_ sender: Any) {
    }
    @IBAction func applePaymentButton(_ sender: Any) {
    }
    @IBAction func placeOrderButton(_ sender: Any) {
    }
    
}
