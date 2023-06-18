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
    var myDraftOrder : DrafOrder?
    var favViewModel : DraftViewModel?
    var draft : Drafts? = Drafts()
    var productsList : [LineItem]?
    var idList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        customerName.text = UserDefaults.standard.string(forKey:"customerFirsttName")
        allOrdersViewModel = AllOrdersViewModel(remote: remoteDataSource ?? AllOrderRemoteDataSource())
//        allOrdersViewModel?.fetchOrdersData(customerId: UserDefaultsManager.sharedInstance.getUserID() ?? 0)
//        allOrdersViewModel?.fetchOrdersToAllOrdersViewController = {() in self.renderOrdersView()}
        
        
        //Favourites Logic
        productsList = [LineItem]()
        favViewModel = DraftViewModel()
        favViewModel?.getAllDrafts()
        favViewModel?.bindingAllDrafts = {() in self.renderFavView()}
        
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
            if productsList?.count ?? 0 <= 2{
                return productsList?.count ?? 0
            }else{
                return 2
            }
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
            
            // cell radius
            cell?.backView.layer.cornerRadius = 20.0
            cell?.backView.layer.borderWidth = 1
            cell?.backView.layer.borderColor = UIColor.darkGray.cgColor
            
            cell?.clipsToBounds = true
            cell?.productImage?.layer.cornerRadius = 10.0
            cell?.productImage?.contentMode = .scaleAspectFill
            cell?.productImage?.clipsToBounds = true
            cell?.backView.clipsToBounds = true
            
            var unwrappedImage : String = ""
            var productID : Int = 0
            
            cell?.productPrice.text = "\(productsList?[indexPath.row].price ?? "") $"
            unwrappedImage = productsList?[indexPath.row].image ?? ""
            productID = Int(productsList?[indexPath.row].sku ?? "") ?? 0
            cell?.productName.text = productsList?[indexPath.row].title
            cell?.productImage.sd_setImage(with: URL(string: unwrappedImage), placeholderImage: UIImage(named: "placeHolder"))

            
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
            
            if Utilites.isConnectedToNetwork(){
                var sku = ""
                sku = productsList?[indexPath.row].sku ?? ""
                let productID = Int(sku) ?? 0
                favViewModel?.getProductDetails(productID: productID)
                favViewModel?.fetchProductsDetailsToViewController = {() in self.renderViewToNavigate()}
            }else{
                let confirmAction = UIAlertAction(title: "OK", style: .default)
                Utilites.displayAlert(title: "Check internet connection", message: "you are offline?", action: confirmAction, controller: self)
            }
            
            
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

extension MeViewController{
    
    func renderViewToNavigate(){
        DispatchQueue.main.async {
            let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            
            detailsViewController.product = self.favViewModel?.fetchProductData
            self.navigationController?.pushViewController(detailsViewController, animated: true)
  
        }
    }
    
    func renderFavView(){
        DispatchQueue.main.async {
            let draftOrders = self.favViewModel?.getMyFavouriteDraft()
            if draftOrders != nil && draftOrders?.count != 0{
                print("draft not nil")
                self.myDraftOrder = draftOrders?[0]
                self.productsList = draftOrders?[0].lineItems
                if self.productsList != nil{
                    for i in self.productsList! {
                        self.idList.append(i.sku ?? "")
                    }
                }
                if self.idList.count != 0{
                    let IDs: String = self.idList.joined(separator: ",")
                    print("IDss \(IDs)")
                    self.favViewModel?.getFavProductDetails(productID: IDs)
                    self.favViewModel?.fetchFavProductsDetailsToViewController = {
                        let result = self.favViewModel?.fetchFavProductData
                        guard let favProducts = result
                        else {
                            return
                            
                        }
                        for i in 0..<(self.productsList?.count ?? 0){
                            for product in favProducts{
                                if self.productsList?[i].sku == String(product.id ?? 0){
                                    self.productsList?[i].image = product.image?.src
                                    print("itemImage \(String(describing: self.productsList?[i].image))")
                                }
                            }
                        }
                    }
                }
                print("list is\(self.idList)")
                self.favouritesTableView.reloadData()
            }else{
                self.productsList = nil
                print("draft is nil")
            }
        }
    }
}
