//
//  OrderModuleViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 05/06/2023.
//

import UIKit
import NVActivityIndicatorView
class OrderModuleViewController: UIViewController {
    
    @IBOutlet weak var coupon: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var discountAmount: UILabel!
    @IBOutlet weak var shippingFees: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    var grand: Float!
    var lineItems: [LineItem]?
    var shippingAddress: Address?
    var cartVM : ShoppingCartViewModel = ShoppingCartViewModel()
    var remoteDataSource: OrderRemoteDataSourceProtocol?
    var orderModuleViewModel: OrderModuleViewModelProtocol?
    var discount = 0.0
    var price: Double?
    var activityIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: .zero, type: .ballClipRotatePulse,color: UIColor(named: "move"))
    override func viewWillAppear(_ animated: Bool) {
        
        cartVM.getAllDrafts()
        cartVM.bindingAllDrafts = {() in self.renderView()}
        if Utilites.isConnectedToNetwork() == false{
            Utilites.displayToast(message: "you are offline", seconds: 5, controller: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: 40),
            activityIndicator.heightAnchor.constraint(equalToConstant: 40),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
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

extension OrderModuleViewController{
    func checkCoupon(coupon: String) -> Float{
        let price = self.price
        var cur = 1.0
        if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
            cur = (UserDefaults.standard.double(forKey: "EGP"))
        }
        switch coupon{
        case "10% offer":
            discount = (((price ?? 0.0) * 0.10) * cur)
            return Float(((price ?? 0.0) - ( (price ?? 0.0) * 0.10)))
        case "20% offer":
            discount = (((price ?? 0.0) * 0.20) * cur)
            return Float(((price ?? 0.0) - ( (price ?? 0.0) * 0.20)))
        case "30% offer":
            discount = (((price ?? 0.0) * 0.30) * cur)
            return Float(((price ?? 0.0) - ( (price ?? 0.0) * 0.30)))
        case "40% offer":
            discount = (((price ?? 0.0) * 0.40) * cur)
            return Float(((price ?? 0.0) - ( (price ?? 0.0) * 0.40)))
        case "50% offer":
            discount = (((price ?? 0.0) * 0.50) * cur)
            return Float(((price ?? 0.0) - ( (price ?? 0.0) * 0.40)))
        default:
            discount = 0.0
            return Float(((price ?? 0.0)))
        }
    }
}
extension OrderModuleViewController{
    func renderView(){
        DispatchQueue.main.async {
            let draftOrders = self.cartVM.getMyCartDraft()
            if draftOrders != nil && draftOrders.count != 0{
                print("draft not nil")
                self.activityIndicator.stopAnimating()
                self.lineItems = draftOrders[0].lineItems
                self.price = Double(draftOrders[0].subtotalPrice ?? "0")
                let userCoupon = UserDefaultsManager.sharedInstance.getUserCoupon()
                if userCoupon == "" {
                    self.coupon.text = "No copoun"
                }else{
                    self.coupon.text = "\(UserDefaultsManager.sharedInstance.getUserCoupon())"
                }
                let sub = self.checkCoupon(coupon: UserDefaultsManager.sharedInstance.getUserCoupon())
                if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
                    var cur = (UserDefaults.standard.double(forKey: "EGP"))
                    self.discountAmount.text = "\(Float(self.discount * Double(cur))) EPG"
                    let total = sub * Float(cur)
                    self.subTotal.text = "\(total) EPG"
                    let shipping = 10.0 * Float(cur)
                    self.shippingFees.text = "\(shipping) EPG"
                    self.grandTotal.text = "\(total + shipping) EPG"
                    UserDefaults.standard.set((total + shipping), forKey: "final")
                }else{
                    self.discountAmount.text = "\(self.discount) $"
                    self.subTotal.text = "\(sub) $"
                    self.shippingFees.text = "10 $"
                    self.grandTotal.text = "\(sub + 10) $"
                    UserDefaults.standard.set(sub + 10, forKey: "final")
                }
                self.grand = sub + 10
                print("grandTotal\( UserDefaults.standard.integer(forKey: "final"))")
            }else{
                self.lineItems = nil
                print("draft is nil")
            }
        }
    }
}
