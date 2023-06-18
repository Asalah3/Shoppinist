//
//  MeViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 01/06/2023.
//

import UIKit
import NVActivityIndicatorView
import BadgeSwift
class MeViewController: UIViewController {
    
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var favouritesTableView: UITableView!
    @IBOutlet weak var customerName: UILabel!
    private var cartArray: [LineItem]?
    private var shoppingCartVM = ShoppingCartViewModel()
    var remoteDataSource: AllOrderRemoteDataSourceProtocol?
    var allOrdersViewModel: AllOrdersViewModelProtocol?
    var ordersList: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        customerName.text = UserDefaults.standard.string(forKey:"customerFirsttName")
        allOrdersViewModel = AllOrdersViewModel(remote: remoteDataSource ?? AllOrderRemoteDataSource())
//        allOrdersViewModel?.fetchOrdersData(customerId: UserDefaultsManager.sharedInstance.getUserID() ?? 0)
//        allOrdersViewModel?.fetchOrdersToAllOrdersViewController = {() in self.renderOrdersView()}
        //Favourites Logic
    }
    
    func getData(){
        shoppingCartVM.getShoppingCart()
        shoppingCartVM.bindingCart = {
            self.renderView()
        }
    }
    func renderView(){
        DispatchQueue.main.async {
            self.cartArray = self.shoppingCartVM.cartList
        }
    }

    @IBAction func seeMoreOrdersButton(_ sender: Any) {
        let allOrdersViewController = self.storyboard?.instantiateViewController(withIdentifier: "AllOrdersViewController") as? AllOrdersViewController
        self.navigationController?.pushViewController(allOrdersViewController ?? AllOrdersViewController(), animated: true)
    }
    @IBAction func seeMoreFavouritesButton(_ sender: Any) {
//        let favViewController = self.storyboard?.instantiateViewController(withIdentifier: "FavViewController") as? FavViewController
//        self.navigationController?.pushViewController(favViewController ?? FavViewController(), animated: true)
    }
    //ShoppingCard
    @IBAction func shoppingButton(_ sender: Any) {
        let cart = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingCard") as! ShoppingCardViewController
        
        navigationController?.pushViewController(cart, animated: true)
        
    }
    @IBAction func settingButton(_ sender: Any) {
        let setting = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        navigationController?.pushViewController(setting, animated: true)
    }
    
    override func viewWillAppear( _ animated: Bool){

        shoppingCartVM.getShoppingCart()
        shoppingCartVM.bindingCart = {
            DispatchQueue.main.async {
                self.cartArray = self.shoppingCartVM.cartList
            }
        }
        if Utilites.isConnectedToNetwork() == false{
            Utilites.displayToast(message: "you are offline", seconds: 5, controller: self)

        }
        allOrdersViewModel?.fetchOrdersData(customerId: UserDefaultsManager.sharedInstance.getUserID() ?? 0)
        allOrdersViewModel?.fetchOrdersToAllOrdersViewController = {() in self.renderOrdersView()}
        getData()
        let rightBarButton = self.navigationItem.rightBarButtonItem
        var count = cartArray?.count ?? 0

        rightBarButton?.addBadge(text: "\(count)" , withOffset: CGPoint(x: -60, y: 0))
      
    }
  
}
extension MeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ordersTableView{
            if ordersList.count == 0{
                return 0
            }else{
                return 1
            }
        }else{
            //Favourites Logic
            return 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ordersTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as? OrderTableViewCell
            cell?.setUpCell(order: ordersList[indexPath.row])
            return cell ?? OrderTableViewCell()
        }
        else{
            //Favourites Logic
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavTableViewCell", for: indexPath) as? FavTableViewCell
            return cell ?? FavTableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == ordersTableView{
            let orderDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsViewController") as? OrderDetailsViewController
            orderDetailsViewController?.order = ordersList[indexPath.row]
            self.navigationController?.pushViewController(orderDetailsViewController ?? OrderDetailsViewController(), animated: true)
        }else{
            //Favourites Logic
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == ordersTableView{
            return ordersTableView.frame.height
        }else{
            return favouritesTableView.frame.height / 2
        }
    }
    func renderOrdersView(){
        DispatchQueue.main.async {
            self.ordersList = self.allOrdersViewModel?.fetchAllOrdersData ?? [Order]()
            self.ordersTableView.reloadData()
        }
    }
    //Favourites Logic
    func renderFavouritesView(){
        DispatchQueue.main.async {
            self.favouritesTableView.reloadData()
        }
    }
    
}
