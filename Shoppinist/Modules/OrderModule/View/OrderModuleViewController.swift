//
//  OrderModuleViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 05/06/2023.
//

import UIKit

class OrderModuleViewController: UIViewController {

    @IBOutlet weak var coupon: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var discountAmount: UILabel!
    @IBOutlet weak var shippingFees: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    
    var lineItems: [LineItem]?
    var shippingAddress: Address?
    var remoteDataSource: OrderRemoteDataSourceProtocol?
    var orderModuleViewModel: OrderModuleViewModelProtocol?
    
    var price: Float?
    
    
    override func viewWillAppear(_ animated: Bool) {
        coupon.text = "\(UserDefaultsManager.sharedInstance.getUserCoupon())"
        let sub = checkCoupon(coupon: UserDefaultsManager.sharedInstance.getUserCoupon())
        subTotal.text = "\(sub)"
        shippingFees.text = "10"
        grandTotal.text = "\(sub + 10)"
       
        UserDefaults.standard.set(sub + 10, forKey: "final")
        print("grandTotal\( UserDefaults.standard.integer(forKey: "final"))")
        
    }

    func checkCoupon(coupon: String) -> Float{
        let price = (UserDefaultsManager.sharedInstance.getTotalPrice())
        switch coupon{
        case "10%offer":
            discountAmount.text = "\( price * 0.10)"
            return Float((price - ( price * 0.10)))
        case "20%offer":
            discountAmount.text = "\( price * 0.20)"
            return Float((price - ( price * 0.20)))
        case "30%offer":
            discountAmount.text = "\( price * 0.30)"
            return Float((price - ( price * 0.30)))
        case "40%offer":
            discountAmount.text = "\( price * 0.40)"
            return Float((price - ( price * 0.40)))
        case "50%offer":
            discountAmount.text = "\( price * 0.50)"
            return Float((price - ( price * 0.40)))
        default:
            discountAmount.text = "\(0.0)"
            return Float((price))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        remoteDataSource = OrderRemoteDataSource()
        orderModuleViewModel = OrderModuleViewModel(remote: remoteDataSource ?? OrderRemoteDataSource())
    }
    @IBAction func placeOrderButton(_ sender: Any) {
        let name = UserDefaults.standard.string(forKey:"customerFirsttName")
        let address = ShippingAddress(address1: shippingAddress?.address1, city: shippingAddress?.city, country: shippingAddress?.country, phone: shippingAddress?.phone, name: name)
        
        let order = Order(id: nil, confirmed: true, discountCodes: nil, createdAt: nil, email: nil, name: nil, note: grandTotal.text, taxLines: nil, customer: Customer(id: UserDefaultsManager.sharedInstance.getUserID()), lineItems: lineItems, shippingAddress: address, shippingLines: nil)
        let payementVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        payementVC.order = PostOrdersModel(order: order)
        self.navigationController?.pushViewController(payementVC, animated: true)
    }
    
   
}
