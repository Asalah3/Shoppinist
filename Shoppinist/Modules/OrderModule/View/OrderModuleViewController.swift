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
    
    var lineItems: [OrderLineItem]?
    var shippingAddress: OrderAddress?
    var remoteDataSource: OrderRemoteDataSourceProtocol?
    var orderModuleViewModel: OrderModuleViewModelProtocol?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        coupon.text = "\(UserDefaultsManager.sharedInstance.getUserCoupon())"
        var price = (UserDefaultsManager.sharedInstance.getTotalPrice())
        func checkCopon(){
            
            if coupon.text == "10%offer" {
                subTotal.text = "\( price - 10)"
                
            }
            else if coupon.text == "offer20%" {
                subTotal.text = "\( price - 20)"
                
            }
            else if coupon.text == "offer30%" {
                subTotal.text = "\( price - 30)"
                
            }
            else if coupon.text == "offer40%" {
                
                subTotal.text = "\( price - 40)"
                
            }
            else if coupon.text == "offer50%" {
                
                subTotal.text = "\( price - 50)"
                
            }
            
            else if coupon.text  == " "{
                subTotal.text = "\( price )"
                
            }
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        remoteDataSource = OrderRemoteDataSource()
        orderModuleViewModel = OrderModuleViewModel(remote: remoteDataSource ?? OrderRemoteDataSource())
        
            
           
            
     
        
    }
    @IBAction func placeOrderButton(_ sender: Any) {
        let order = Order(id: nil, cartToken: nil, checkoutID: nil, checkoutToken: nil, confirmed: true, currency: nil, discountCodes: nil, createdAt: nil, email: nil, name: nil, taxLines: nil, customer: nil, lineItems: lineItems, shippingAddress: shippingAddress, shippingLines: nil)
        self.orderModuleViewModel?.createOrder(order: OrdersModel(orders: [order]))
        self.orderModuleViewModel?.bindingOrderCreated = {[weak self] in
            DispatchQueue.main.async {
                if self?.orderModuleViewModel?.observableCreateOrder == 201{
                    print("Order Inserted Successfully")
                }else{
                    print("Failed To Insert Order")
                }
            }
        }
        let payementVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
         self.present(payementVC, animated: true)
    }
    
   
}
