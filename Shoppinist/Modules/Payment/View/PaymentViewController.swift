//
//  PaymentViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 08/06/2023.
//

import UIKit
import PassKit

class PaymentViewController: UIViewController {
    @IBOutlet weak var applePaymentButton: UIButton!
    @IBOutlet weak var coupounTextField: UITextField!
    @IBOutlet weak var cashPaymentButton: UIButton!
    
    
    private var paymentRequest : PKPaymentRequest = {
      let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.pushpendra.pay"
        request.supportedNetworks = [.quicPay, .masterCard, .visa]
        request.supportedCountries = ["EG", "US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "EG"
        if UserDefaults.standard.string(forKey: "Currency") == "EGP" {
         request.currencyCode = "EGP"
     } else {
         request.currencyCode = "US"
       }
        request.currencyCode = "EGP"
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Shoppinist", amount: NSDecimalNumber(value: UserDefaults.standard.integer(forKey: "final")))]
        return request
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilites.setUpTextFeildStyleAddress(textField: coupounTextField)
       
    }
    

    @IBAction func cashButton(_ sender: Any) {
        OptionSelected(_isApplePaySelected: false)
    }
    @IBAction func applePaymentButton(_ sender: Any) {
        OptionSelected(_isApplePaySelected: true)
        Payment()
    }
    @IBAction func placeOrderButton(_ sender: Any) {
    }
    func OptionSelected(_isApplePaySelected: Bool) {
        if _isApplePaySelected {
            self.applePaymentButton.isSelected = true
            applePaymentButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            self.cashPaymentButton.isSelected = false
            cashPaymentButton.setImage(UIImage(systemName: "circle"), for: .normal)
        } else {
            self.applePaymentButton.isSelected = false
            applePaymentButton.setImage(UIImage(systemName: "circle"), for: .normal)
            self.cashPaymentButton.isSelected = true
            cashPaymentButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        }
    }
    func Payment(){
        let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        if controller != nil {
            controller!.delegate = self
            present(controller!,  animated: true ,completion: nil)
        }
    }
    
}
extension PaymentViewController : PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController , didAuthorizePayment payment: PKPayment , handler completion: @escaping (PKPaymentAuthorizationResult) -> Void){
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}
