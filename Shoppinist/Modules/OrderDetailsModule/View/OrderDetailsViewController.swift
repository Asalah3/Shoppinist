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
    @IBOutlet weak var orderProductsTableView: UITableView!
    var order: Order?
    override func viewDidLoad() {
        super.viewDidLoad()
        orderDate.text = order?.createdAt
        orderTotalPrice.text = order?.note
        let shippingAdress = order?.shippingAddress
        let address = "\(shippingAdress?.country ?? ""), \( shippingAdress?.city ?? ""), \(shippingAdress?.address1 ?? "")"
        orderAddress.text = address
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
