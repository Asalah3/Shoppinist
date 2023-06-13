//
//  AllOrdersViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 13/06/2023.
//

import UIKit

class AllOrdersViewController: UIViewController {

    @IBOutlet weak var ordersTableView: UITableView!
    var ordersList: [Order] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
extension AllOrdersViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as? OrderTableViewCell
        cell?.setUpCell(order: ordersList[indexPath.row])
        return cell ?? OrderTableViewCell()

    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    
}
