//
//  OrderDetailsViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 15/06/2023.
//

import UIKit

class OrderDetailsViewController: UIViewController {
    
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderTotalPrice: UILabel!
    @IBOutlet weak var orderAddress: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var orderProductsTableView: UITableView!
    var order: Order?
    override func viewDidLoad() {
        super.viewDidLoad()
        orderDate.text = order?.createdAt
        if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
            var cur = (UserDefaults.standard.double(forKey: "EGP"))
           
            self.orderTotalPrice.text = "\((Float(order?.note ?? "0.0") ?? 0.0) * Float(cur)) EGP"
        }else{
            self.orderTotalPrice.text = "\(order?.note ?? "0.0" ) $"
        }
        let shippingAdress = order?.shippingAddress
        let address = "\(shippingAdress?.country ?? ""), \( shippingAdress?.city ?? ""), \(shippingAdress?.address1 ?? "")"
        let phone = "\(shippingAdress?.phone ?? "")"
        phoneNumber.text = phone
        orderAddress.text = address
    }
    override func viewWillAppear(_ animated: Bool) {
        if Utilites.isConnectedToNetwork() == false{
            Utilites.displayToast(message: "you are offline", seconds: 5, controller: self)
        }
    }
}
extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        order?.lineItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductOrderTableViewCell", for: indexPath) as? ProductOrderTableViewCell
        cell?.setUpCell(lineItem: order?.lineItems?[indexPath.row] ?? LineItem())
        return cell ?? ProductOrderTableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    
}
