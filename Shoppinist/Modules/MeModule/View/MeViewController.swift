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
    
    @IBOutlet weak var noOrdersLabel: UILabel!
    @IBOutlet weak var noFavLabel: UILabel!
    @IBOutlet weak var cartButtonRight: UIBarButtonItem!
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
    var productID : Int?
    let meStoryboard = UIStoryboard(name: "Order", bundle: nil)
    var myCartDraftOrder : DrafOrder?
    var cartViewModel : ShoppingCartViewModel?
    var cartDraft : Drafts? = Drafts()
    var productsListCart : [LineItem]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noOrdersLabel.isHidden = true
        noFavLabel.isHidden = true
     
        customerName.text = UserDefaults.standard.string(forKey:"customerFirsttName")
        allOrdersViewModel = AllOrdersViewModel(remote: remoteDataSource ?? AllOrderRemoteDataSource())
        
        //Favourites Logic
        productsList = [LineItem]()
        favViewModel = DraftViewModel()
        
        
    }
   
    @IBAction func seeMoreOrdersButton(_ sender: Any) {
        
        let allOrdersViewController = meStoryboard.instantiateViewController(withIdentifier: "AllOrdersViewController") as? AllOrdersViewController
        self.navigationController?.pushViewController(allOrdersViewController ?? AllOrdersViewController(), animated: true)
    }
    @IBAction func seeMoreFavouritesButton(_ sender: Any) {

    }
    //ShoppingCard
    @IBAction func shoppingButton(_ sender: Any) {

        
    }
    @IBAction func settingButton(_ sender: Any) {

    }
    
    override func viewWillAppear( _ animated: Bool){

        productsListCart = [LineItem]()
        cartViewModel = ShoppingCartViewModel()
        cartViewModel?.getAllDrafts()
        cartViewModel?.bindingAllDrafts = {() in self.renderCartView()}
        
        
        if Utilites.isConnectedToNetwork() == false{
            Utilites.displayToast(message: "you are offline", seconds: 5, controller: self)

        }
        allOrdersViewModel?.fetchOrdersData(customerId: UserDefaultsManager.sharedInstance.getUserID() ?? 0)
        allOrdersViewModel?.fetchOrdersToAllOrdersViewController = {() in self.renderOrdersView()}
        favViewModel?.getAllDrafts()
        favViewModel?.bindingAllDrafts = {() in self.renderFavView()}
        
      
    }
  
}
extension MeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ordersTableView{
            if ordersList.count == 0{
                noOrdersLabel.isHidden = false
                return 0
            }else{
                noOrdersLabel.isHidden = true
                return 1
            }
        }else{
            //Favourites Logic
            if productsList?.count == 0{
                noFavLabel.isHidden = false
                self.favouritesTableView.isHidden = true
                return 0
            }else if productsList?.count ?? 1 <= 2{
                noFavLabel.isHidden = true
                self.favouritesTableView.isHidden = false
                return productsList?.count ?? 0
            }else{
                noFavLabel.isHidden = true
                self.favouritesTableView.isHidden = false
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
            cell?.productImage?.clipsToBounds = true
            cell?.backView.clipsToBounds = true
            
            var unwrappedImage : String = ""
            if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
                var cur = (UserDefaults.standard.double(forKey: "EGP"))
                let price = floor((Double(productsList?[indexPath.row].price ?? "0.0") ?? 0.0) * cur)
                cell?.productPrice.text = "Price: \(String(price)) EGP"
            }else{
                cell?.productPrice.text = "\(productsList?[indexPath.row].price ?? "") $"
            }
            let myString = productsList?[indexPath.row].sku ?? ""
            let myArray = myString.split(separator: ",")
            productID = Int(myArray[0]) ?? 0
            unwrappedImage = String(myArray[1])
            cell?.productName.text = productsList?[indexPath.row].title
            cell?.productImage.sd_setImage(with: URL(string: unwrappedImage), placeholderImage: UIImage(named: "placeHolder"))

            
            return cell ?? FavTableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == ordersTableView{
            
            let orderDetailsViewController = meStoryboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as? OrderDetailsViewController
            orderDetailsViewController?.order = ordersList[indexPath.row]
            self.navigationController?.pushViewController(orderDetailsViewController ?? OrderDetailsViewController(), animated: true)
        }else{
            //Favourites Logic
            
            if Utilites.isConnectedToNetwork(){
                let myString = productsList?[indexPath.row].sku ?? ""
                print("myString\(myString)")
                let myArray = myString.split(separator: ",")
                let productid = Int(myArray[0]) ?? 0
                favViewModel?.getProductDetails(productID: productid)
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
            if self.ordersList.isEmpty{
                self.noOrdersLabel.isHidden = false
                self.ordersTableView.isHidden = true
            }else{
                self.noOrdersLabel.isHidden = true
                self.ordersTableView.isHidden = false
            }
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
    
    func renderCartView(){
        DispatchQueue.main.async {
            let draftOrders = self.cartViewModel?.getMyCartDraft()
            if draftOrders != nil && draftOrders?.count != 0{
                self.myCartDraftOrder = draftOrders?[0]
                self.productsListCart = draftOrders?[0].lineItems
                self.cartButtonRight.addBadge(text: "\(String(describing: self.productsListCart?.count ?? 0))" , withOffset: CGPoint(x: -10, y: 0))
            }
            else{
                self.cartButtonRight.addBadge(text: "0" , withOffset: CGPoint(x: -10, y: 0))
            }
        }
    }
    func renderViewToNavigate(){
        DispatchQueue.main.async {
            
            let storyboard = UIStoryboard(name: "FavouriteView", bundle: nil)
            let detailsViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            
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
                self.favouritesTableView.reloadData()
            }else{
                self.productsList = nil
                self.noFavLabel.isHidden = false
                self.favouritesTableView.isHidden = true
            }
        }
    }
}
