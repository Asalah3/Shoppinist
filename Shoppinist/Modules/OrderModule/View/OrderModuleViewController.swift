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
    var grand: Float!
    var lineItems: [LineItem]?
    var shippingAddress: Address?
    var remoteDataSource: OrderRemoteDataSourceProtocol?
    var orderModuleViewModel: OrderModuleViewModelProtocol?
    
    var price: Float?
    
    
    override func viewWillAppear(_ animated: Bool) {
        let userCoupon = UserDefaultsManager.sharedInstance.getUserCoupon()
        if userCoupon == "" {
            coupon.text = "No copoun"
        }else{
            coupon.text = "\(UserDefaultsManager.sharedInstance.getUserCoupon())"
        }
        
        let sub = checkCoupon(coupon: UserDefaultsManager.sharedInstance.getUserCoupon())
        if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
            var cur = (UserDefaults.standard.double(forKey: "EGP"))
            let total = sub * Float(cur)
            subTotal.text = "\(total) EPG"
            let shipping = 10.0 * Float(cur)
            shippingFees.text = "\(shipping) EPG"
            grandTotal.text = "\(total + shipping) EPG"
            UserDefaults.standard.set((total + shipping), forKey: "final")
        }else{
            subTotal.text = "\(sub) $"
            shippingFees.text = "10 $"
            grandTotal.text = "\(sub + 10) $"
            UserDefaults.standard.set(sub + 10, forKey: "final")
        }
        grand = sub + 10
       
        
        print("grandTotal\( UserDefaults.standard.integer(forKey: "final"))")
        
    }

    func checkCoupon(coupon: String) -> Float{
        let price = (UserDefaultsManager.sharedInstance.getTotalPrice())
        var cur = 1.0
        if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
            cur = (UserDefaults.standard.double(forKey: "EGP"))
        }
        switch coupon{
        case "10%offer":
            discountAmount.text = "\((price * 0.10) * cur) "
            return Float((price - ( price * 0.10)))
        case "20%offer":
            discountAmount.text = "\((price * 0.20) * cur)"
            return Float((price - ( price * 0.20)))
        case "30%offer":
            discountAmount.text = "\((price * 0.30) * cur)"
            return Float((price - ( price * 0.30)))
        case "40%offer":
            discountAmount.text = "\((price * 0.40) * cur)"
            return Float((price - ( price * 0.40)))
        case "50%offer":
            discountAmount.text = "\((price * 0.50) * cur)"
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
        
        let order = Order(id: nil, confirmed: true, discountCodes: nil, createdAt: nil, email: nil, name: nil, note: "\(grand ?? 0.0)", taxLines: nil, customer: Customer(id: UserDefaultsManager.sharedInstance.getUserID()), lineItems: lineItems, shippingAddress: address, shippingLines: nil)
        let payementVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        payementVC.order = PostOrdersModel(order: order)
        self.navigationController?.pushViewController(payementVC, animated: true)
    }
    
   
}
