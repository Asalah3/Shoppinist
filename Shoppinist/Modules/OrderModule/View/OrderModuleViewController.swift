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
    override func viewDidLoad() {
        super.viewDidLoad()
        remoteDataSource = OrderRemoteDataSource()
        orderModuleViewModel = OrderModuleViewModel(remote: remoteDataSource ?? OrderRemoteDataSource())
        coupon.text = "\(UserDefaultsManager.sharedInstance.getUserCoupon())"
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
