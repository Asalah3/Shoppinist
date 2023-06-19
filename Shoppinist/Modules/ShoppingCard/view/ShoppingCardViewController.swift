//
//  ShoppingCardViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 04/06/2023.
//

import UIKit
import Reachability
import SDWebImage
import Lottie

class ShoppingCardViewController: UIViewController {
    @IBOutlet weak var proccess_btn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var noData: AnimationView!
    private var productsList: [LineItem]?
    var lineItem = LineItem()
    private var shoppingCartVM: ShoppingCartViewModel?
    var myDraftOrder : DrafOrder?
    var draft : Drafts? = Drafts()
    var currency = 0.0
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    @IBOutlet weak var subTotalPrice: UILabel!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var cardTableView: UITableView!
    override func viewDidLoad() {
        self.shoppingCartVM?.bindingCheckConnectivity = { [weak self] in
            DispatchQueue.main.async {
                if self?.shoppingCartVM?.ObservableConnection == false{
                    Utilites.displayToast(message: "you are offline", seconds: 5, controller: self ?? ShoppingCardViewController())
                }
            }
        }
    }
    @IBAction func CheckOutButton(_ sender: Any) {
    }
    override func viewWillAppear(_ animated: Bool) {
        self.shoppingCartVM?.checkNetwork()
        noData.isHidden = true
        productsList = [LineItem]()
        shoppingCartVM = ShoppingCartViewModel()
        if Utilites.isConnectedToNetwork() == false{
            Utilites.displayToast(message: "you are offline", seconds: 4, controller: self)
        }
        
        //------------------load favourites from API------------------------
        noData.isHidden = true
        cardTableView.showsVerticalScrollIndicator = false
        cardTableView.showsHorizontalScrollIndicator = false
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
                activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        shoppingCartVM?.getAllDrafts()
        shoppingCartVM?.bindingAllDrafts = {() in self.renderView()}
    }
    func renderView(){
        DispatchQueue.main.async {
            let draftOrders = self.shoppingCartVM?.getMyCartDraft()
            if draftOrders != nil && draftOrders?.count != 0{
                print("draft not nil")
                self.myDraftOrder = draftOrders?[0]
                self.subTotalPrice.text = self.myDraftOrder?.subtotalPrice
                self.productsList = draftOrders?[0].lineItems
                self.cardTableView.reloadData()
            }else{
                self.productsList = nil
                print("draft is nil")
            }
            self.activityIndicator.stopAnimating()
            self.checkListCount()
        }
    }
    func checkListCount(){
        if productsList?.count == 0 || productsList == nil{
            cardTableView.isHidden = true
            subTotalPrice.isHidden = true
            totalPriceLabel.isHidden = true
            checkOutButton.isHidden = true
            noData.isHidden = false
            noData.contentMode = .scaleAspectFit
            noData.loopMode = .loop
            noData.play()
        }else{
            cardTableView.isHidden = false
            noData.isHidden = true
            subTotalPrice.isHidden = false
            totalPriceLabel.isHidden = false
            checkOutButton.isHidden = false
        }
    }
}
extension ShoppingCardViewController: UITableViewDataSource ,UITableViewDelegate{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsList?.count ?? 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "shoppingCardCell", for: indexPath) as! ShoppingCardTableViewCell
        cell.delegate = self
        cell.lineItem = productsList?[indexPath.row]
        cell.setUpCell()
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if Utilites.isConnectedToNetwork(){
            let confirmAction = UIAlertAction(title: "Delete", style: .default){ action in
                if self.productsList != nil && self.productsList?.count != 0{
                    if self.myDraftOrder?.lineItems?.count == 1{
                        self.deleteMyDraft()
                    }else{
                        self.deleteItemFromMyDraft(index: indexPath.row)
                    }
                }
            }
            Utilites.displayAlert(title: "You are about to delete product!!", message: "Do you want to delete this product from favourite?", action: confirmAction, controller: self)
        }else{
            let confirmAction = UIAlertAction(title: "OK", style: .default)
            Utilites.displayAlert(title: "Check internet connection", message: "you are offline?", action: confirmAction, controller: self)
        }
        
    }
    func deleteMyDraft(){
        self.shoppingCartVM?.delDraft(draftId: (myDraftOrder?.id)!)
        self.shoppingCartVM?.bindingDraftDelete = { [weak self] in
            print("view created")
            DispatchQueue.main.async {
                if self?.shoppingCartVM?.ObservableDraftDelete  == 200{
                    Utilites.displayToast(message: "deleted successfully", seconds: 2.0, controller: self ?? ShoppingCardViewController())
                    self?.shoppingCartVM?.getAllDrafts()

                }
                else{
                    Utilites.displayToast(message: "delete failed", seconds: 2.0, controller: self ?? ShoppingCardViewController())
                }
            }
        }
    }
    func deleteItemFromMyDraft(index : Int){
        self.draft?.draftOrder = myDraftOrder
        print("mydraftdraft\(String(describing: self.draft?.draftOrder?.lineItems))")
        let productId: String = "\((productsList?[index].sku)!)"
        self.draft?.draftOrder?.lineItems?.removeAll(where: { item in
            item.sku! == productId
        })
        self.shoppingCartVM?.updateDraft(updatedDraft: (self.draft)!)
        self.shoppingCartVM?.bindingDraftUpdate = { [weak self] in
            print("view createddd")
            DispatchQueue.main.async {
                if self?.shoppingCartVM?.ObservableDraftUpdate  == 200 || self?.shoppingCartVM?.ObservableDraftUpdate  == 201{
                    Utilites.displayToast(message: "deleted successfully", seconds: 2.0, controller: self ?? ShoppingCardViewController())
                    self?.shoppingCartVM?.getAllDrafts()
                }else{
                    Utilites.displayToast(message: "delete failed", seconds: 2.0, controller: self ?? ShoppingCardViewController())
                }
            }
        }
    }
}

extension ShoppingCardViewController: CartCellDelegate{
    func startAnimating() {
        self.view.isUserInteractionEnabled = false
        activityIndicator.center = view.center
                activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
    func showToast(message: String) {
        Utilites.displayToast(message: message, seconds: 2, controller: self)
    }
   
    
    
}
