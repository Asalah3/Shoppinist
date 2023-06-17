//
//  FavViewController.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 10/06/2023.
//

import UIKit
import Lottie

class FavViewController: UIViewController {

    @IBOutlet weak var noData: AnimationView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var favTableView: UITableView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var productsList : [LineItem]?
    var myDraftOrder : DrafOrder?
    var favViewModel : DraftViewModel?
    var draft : Drafts? = Drafts()
    var currency = 0.0
    var searchProducts = [LineItem]()
    var searching = false
    var idList = [String]()

    
    override func viewWillAppear(_ animated: Bool) {
        self.favViewModel?.checkNetwork()
        
        noData.isHidden = true
        productsList = [LineItem]()
        favViewModel = DraftViewModel()
        self.favViewModel?.changeCurrency()
        self.favViewModel?.fetchCurrencyToCell = { [weak self] in
            DispatchQueue.main.async {
                self?.currency = (Double(self?.favViewModel?.fetchCurrencyData?.rates.egp ?? "0") ?? 0.0).rounded()
                self?.favTableView.reloadData()
            }
        }
        
        if Utilites.isConnectedToNetwork() == false{
            Utilites.displayToast(message: "you are offline", seconds: 4, controller: self)
        }
        
        //------------------load favourites from API------------------------
        noData.isHidden = true
        favTableView.showsVerticalScrollIndicator = false
        favTableView.showsHorizontalScrollIndicator = false
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
                activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        favViewModel?.getAllDrafts()
        favViewModel?.bindingAllDrafts = {() in self.renderView()}
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favViewModel?.bindingCheckConnectivity = { [weak self] in
            DispatchQueue.main.async {
                if self?.favViewModel?.ObservableConnection == false{
                    Utilites.displayToast(message: "you are offline", seconds: 5, controller: self ?? ViewController())
                }
            }
        }
    }
    
}

extension FavViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching == true{
            return searchProducts.count
        }else{
            return productsList?.count ?? 0

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavTableViewCell", for: indexPath) as! FavTableViewCell
        
        self.favViewModel?.checkNetwork()
        
        // cell radius
        cell.backView.layer.cornerRadius = 20.0
        cell.backView.layer.borderWidth = 1
        cell.backView.layer.borderColor = UIColor.darkGray.cgColor
        
        cell.clipsToBounds = true
        cell.productImage?.layer.cornerRadius = 10.0
        cell.productImage?.contentMode = .scaleAspectFill
        cell.productImage?.clipsToBounds = true
        cell.backView.clipsToBounds = true


        //assign values to cell
        var unwrappedImage : String = ""
        var productID : Int = 0
        
        if searching == true{
            if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
                let price = floor((Double(searchProducts[indexPath.row].price ?? "0.0") ?? 0.0) * self.currency)
                cell.productPrice.text = "\(String(price)) EGP"
            }else{
                cell.productPrice.text = "\(searchProducts[indexPath.row].price ?? "") $"
            }
            productID = Int(searchProducts[indexPath.row].sku ?? "") ?? 0
            cell.productName.text = searchProducts[indexPath.row].title
        }else{
            if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
                let price = floor((Double(productsList?[indexPath.row].price ?? "0.0") ?? 0.0) * self.currency)
                cell.productPrice.text = "\(String(price)) EGP"
            }else{
                cell.productPrice.text = "\(productsList?[indexPath.row].price ?? "") $"
            }
            unwrappedImage = productsList?[indexPath.row].image ?? ""
            productID = Int(productsList?[indexPath.row].sku ?? "") ?? 0
            cell.productName.text = productsList?[indexPath.row].title
        }
        
        print("productidid\(productID)")
        cell.productImage.sd_setImage(with: URL(string: unwrappedImage), placeholderImage: UIImage(named: "placeHolder"))

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Utilites.isConnectedToNetwork(){
            var sku = ""
            if searching{
                sku = searchProducts[indexPath.row].sku ?? ""
            }else{
                sku = productsList?[indexPath.row].sku ?? ""
            }
            let productID = Int(sku) ?? 0
            favViewModel?.getProductDetails(productID: productID)
            favViewModel?.fetchProductsDetailsToViewController = {() in self.renderViewToNavigate()}
        }else{
            let confirmAction = UIAlertAction(title: "OK", style: .default)
            Utilites.displayAlert(title: "Check internet connection", message: "you are offline?", action: confirmAction, controller: self)
        }
        
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
    
    
    func renderView(){
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
                                    print("itemImage \(self.productsList?[i].image)")
                                }
                            }
                        }
                    }
                }
                print("list is\(self.idList)")
                self.favTableView.reloadData()
            }else{
                self.productsList = nil
                print("draft is nil")
            }
            self.activityIndicator.stopAnimating()
            self.checkListCount()
        }
    }
    
    func renderViewToNavigate(){
        DispatchQueue.main.async {
            let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            
            detailsViewController.product = self.favViewModel?.fetchProductData
            self.navigationController?.pushViewController(detailsViewController, animated: true)
  
        }
    }
    
    func checkListCount(){
        if productsList?.count == 0 || productsList == nil{
            favTableView.isHidden = true
            noData.isHidden = false
            noData.contentMode = .scaleAspectFit
            noData.loopMode = .loop
            noData.play()
        }else{
            favTableView.isHidden = false
            noData.isHidden = true
        }
    }
    
    func deleteMyDraft(){
        self.favViewModel?.delDraft(draftId: (myDraftOrder?.id)!)
        self.favViewModel?.bindingDraftDelete = { [weak self] in
            print("view created")
            DispatchQueue.main.async {
                if self?.favViewModel?.ObservableDraftDelete  == 200{
                    Utilites.displayToast(message: "deleted successfully", seconds: 2.0, controller: self ?? ViewController())
                    self?.favViewModel?.getAllDrafts()

                }
                else{
                    Utilites.displayToast(message: "delete failed", seconds: 2.0, controller: self ?? ViewController())
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
        self.favViewModel?.updateDraft(updatedDraft: (self.draft)!)
        self.favViewModel?.bindingDraftUpdate = { [weak self] in
            print("view createddd")
            DispatchQueue.main.async {
                if self?.favViewModel?.ObservableDraftUpdate  == 200 || self?.favViewModel?.ObservableDraftUpdate  == 201{
                    Utilites.displayToast(message: "deleted successfully", seconds: 2.0, controller: self ?? ViewController())
                    self?.favViewModel?.getAllDrafts()
                }else{
                    Utilites.displayToast(message: "delete failed", seconds: 2.0, controller: self ?? ViewController())
                }
            }
        }
    }
    
    
}

//------------------search bar-----------------------
extension FavViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchProducts = productsList?.filter({$0.title?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased()}) ?? [LineItem]()
        searching = true
        favTableView.reloadData()
        if self.searchProducts.count == 0{
            self.favTableView.isHidden = true
            self.noData.isHidden = false
            self.noData.contentMode = .scaleAspectFit
            self.noData.loopMode = .loop
            self.noData.play()
        }else{
            self.favTableView.isHidden = false
            self.noData.isHidden = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        favTableView.reloadData()
    }
}
