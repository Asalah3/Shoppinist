//
//  PaymentViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 08/06/2023.
//

import UIKit
import PassKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var paymentSegment: UISegmentedControl!
    var order : PostOrdersModel?
    var remoteDataSource: OrderRemoteDataSourceProtocol?
    var orderModuleViewModel: OrderModuleViewModelProtocol?
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var totalprice :Int = 0
    var finalPrice: Int = 0
    private var shoppingCartVM: ShoppingCartViewModel?
    var myDraftOrder : DrafOrder?

    @IBOutlet weak var price: UILabel!
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
            request.currencyCode = "USD"
        }
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Shoppinist", amount: NSDecimalNumber(value: UserDefaults.standard.integer(forKey: "final")))]
        return request
    }()
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "Currency") == "EGP" {
            price.text = "\(UserDefaults.standard.integer(forKey: "final")) EGP"
        }else{
            price.text = " \(UserDefaults.standard.integer(forKey: "final")) $"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingCartVM = ShoppingCartViewModel()
        remoteDataSource = OrderRemoteDataSource()
        orderModuleViewModel = OrderModuleViewModel(remote: remoteDataSource ?? OrderRemoteDataSource())
    }
    func Payment(){
        let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        if controller != nil {
            controller!.delegate = self
            present(controller!,  animated: true ,completion: {
                self.orderModuleViewModel?.createOrder(order: self.order!)
                self.orderModuleViewModel?.bindingOrderCreated = {[weak self] in
                    DispatchQueue.main.async {
                        if self?.orderModuleViewModel?.observableCreateOrder == 201{
                            Utilites.displayToast(message: "Order Inserted Successfully", seconds: 5, controller: self ?? PaymentViewController())
                            self?.deleteMyDraft()
                            
                        }else{
                            print("Failed To Insert Order")
                        }
                    }
                }
            })
        }
        
    }
    @IBAction func processedToConfirm(_ sender: Any) {
        if  self.paymentSegment.selectedSegmentIndex == 0{
            if UserDefaults.standard.string(forKey: "Currency") == "EGP" {
                if UserDefaults.standard.integer(forKey: "final") > 5000
                {
                    showAlert(title: "Stop" , message: "COD Total Price Can't Be greater than 5000EGP")
                }
                else{
                    placeOrder()
                }
            }
            if UserDefaults.standard.string(forKey: "Currency") != "EGP" {
                if UserDefaults.standard.integer(forKey: "final") > 1000
                {
                    showAlert(title: "Stop" , message: "COD Total Price Can't Be greater than 1000 $")
                }
                else{
                    placeOrder()
                    
                    
                }
            }
            
        }else if self.paymentSegment.selectedSegmentIndex == 1{
            Payment()
            
        }
    }
}



extension PaymentViewController : PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion:{
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        })

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
    func placeOrder(){
        let alert : UIAlertController = UIAlertController(title: "Warnning", message: "Do You Want To Processed This order", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default , handler: { action in
            self.orderModuleViewModel?.createOrder(order: self.order!)
            self.orderModuleViewModel?.bindingOrderCreated = {[weak self] in
                DispatchQueue.main.async {
                    if self?.orderModuleViewModel?.observableCreateOrder == 201{
                        Utilites.displayToast(message: "Order Inserted Successfully", seconds: 5, controller: self ?? PaymentViewController())
                        self?.deleteMyDraft()
                    }else{
                        print("Failed To Insert Order")
                    }
                    
                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default , handler: nil))
        
        self.present(alert, animated: true)
    }
}
extension PaymentViewController{
    func renderView(){
        DispatchQueue.main.async {
            let draftOrders = self.shoppingCartVM?.getMyCartDraft()
            if draftOrders != nil && draftOrders?.count != 0{
                self.myDraftOrder = draftOrders?[0]
                self.shoppingCartVM?.delDraft(draftId: self.myDraftOrder?.id ?? 0)
                if self.paymentSegment.selectedSegmentIndex == 0{
                    if let navigationController = self.navigationController {
                        navigationController.popToRootViewController(animated: true)
                    }
                }
               
            }
        }
    }
    func deleteMyDraft(){
        shoppingCartVM?.getAllDrafts()
        shoppingCartVM?.bindingAllDrafts = {() in self.renderView()}
    }

}
