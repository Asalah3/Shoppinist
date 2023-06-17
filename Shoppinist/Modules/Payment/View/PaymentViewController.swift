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
    @IBOutlet weak var cashPaymentButton: UIButton!
    var order : PostOrdersModel?
    var remoteDataSource: OrderRemoteDataSourceProtocol?
    var orderModuleViewModel: OrderModuleViewModelProtocol?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var totalprice :Int = 0
    var finalPrice: Int = 0
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
        remoteDataSource = OrderRemoteDataSource()
        orderModuleViewModel = OrderModuleViewModel(remote: remoteDataSource ?? OrderRemoteDataSource())
        
    }
    

    @IBAction func cashButton(_ sender: Any) {
        OptionSelected(_isApplePaySelected: false)
        Utilites.displayToast(message: "You choose To Pay cash on Delivery" , seconds: 2.0, controller: self )
       
     
    }
    @IBAction func applePaymentButton(_ sender: Any) {
       
        OptionSelected(_isApplePaySelected: true)
        Payment()
        Utilites.displayToast(message: "You choose  apple payment " , seconds: 2.0, controller: self )

       
    }
    
    @IBAction func processedToConfirm(_ sender: Any) {
        print("presssed")
        if ((self.applePaymentButton.isSelected) == false) && ((self.cashPaymentButton.isSelected) == false){
            self.showAlert(title: "No Method is selected", message: "Please Select Payment Method")
        }else{
            self.orderModuleViewModel?.createOrder(order: order!)
            self.orderModuleViewModel?.bindingOrderCreated = {[weak self] in
                DispatchQueue.main.async {
                    if self?.orderModuleViewModel?.observableCreateOrder == 201{
                        print("Order Inserted Successfully")
                        self?.orderModuleViewModel?.deleteShoppingCart{ deleted in
                            if deleted == nil{
                                print("ShoppingCart Deleted Successfully")
                            }else{
                                print("Failed To Delete ShoppingCart")
                            }
                        }
                        if let navigationController = self?.navigationController {
                            navigationController.popToRootViewController(animated: true)
                        }
                    }else{
                        print("Failed To Insert Order")
                    }
                    
                }
            }
        }
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
     
    
    func showAlert(title: String , message: String){
        let alert = UIAlertController(title: title ,message : message
                                      , preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .destructive)
        alert.addAction(OkAction)
        self.present(alert, animated: true)
    }
}

