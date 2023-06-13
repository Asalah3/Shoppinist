//
//  AllOrdersViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 13/06/2023.
//

import UIKit

class AllOrdersViewController: UIViewController {

    @IBOutlet weak var ordersTableView: UITableView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var remoteDataSource: AllOrderRemoteDataSourceProtocol?
    var allOrdersViewModel: AllOrdersViewModelProtocol?
    var ordersList: [Order] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
                activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        remoteDataSource = AllOrderRemoteDataSource()
        allOrdersViewModel = AllOrdersViewModel(remote: remoteDataSource ?? AllOrderRemoteDataSource())
        allOrdersViewModel?.fetchOrdersData(customerId: 6930629984548)
        allOrdersViewModel?.fetchOrdersToAllOrdersViewController = {() in self.renderView()}
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert : UIAlertController = UIAlertController(title: "Warnning", message: "Do You Want To Delete This Order", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler: { action in
                self.deleteOrder(orderId: self.ordersList[indexPath.row].id ?? 0)
                self.ordersList.remove(at: indexPath.row)
                self.ordersTableView.deleteRows(at: [indexPath], with: .fade)
                self.ordersTableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default , handler: nil))
            
            self.present(alert, animated: true)
        }
        
    }
    func renderView(){
        DispatchQueue.main.async {
            self.ordersList = self.allOrdersViewModel?.fetchAllOrdersData ?? [Order]()
            self.ordersTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    func deleteOrder(orderId: Int){
        self.allOrdersViewModel?.deleteOrder(orderId: orderId)
        self.allOrdersViewModel?.bindingOrderDelete = {[weak self] in
            DispatchQueue.main.async {
                if self?.allOrdersViewModel?.observableDeleteOrder  == 200{
                    print("deleted succeessfully")
                }
                else{
                    print("Failed To delete")
                }
            }
        }
    }
}
