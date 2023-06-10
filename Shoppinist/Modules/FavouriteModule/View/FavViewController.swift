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
    var favViewModel : DraftViewModel?
    var currency = 0.0
    var searchProducts = [LineItem]()
    var searching = false
    
    override func viewWillAppear(_ animated: Bool) {
        noData.isHidden = true
        favViewModel = DraftViewModel()
        productsList = [LineItem]()
        self.favViewModel?.changeCurrency()
        self.favViewModel?.fetchCurrencyToCell = { [weak self] in
            DispatchQueue.main.async {
                self?.currency = (Double(self?.favViewModel?.fetchCurrencyData?.rates.egp ?? "0") ?? 0.0).rounded()
                self?.favTableView.reloadData()
            }
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
        if searching == true{
            if (searchProducts[indexPath.row].vendor) != nil{
                unwrappedImage = (searchProducts[indexPath.row].vendor)!
            }else{
                unwrappedImage = ""
            }
            cell.productPrice.text = searchProducts[indexPath.row].price
            cell.productName.text = searchProducts[indexPath.row].title
        }else{
            if (productsList?[indexPath.row].vendor) != nil{
                unwrappedImage = (productsList?[indexPath.row].vendor)!
            }else{
                unwrappedImage = ""
            }
            cell.productPrice.text = productsList?[indexPath.row].price
            cell.productName.text = productsList?[indexPath.row].title
        }
        cell.productImage.sd_setImage(with: URL(string: unwrappedImage), placeholderImage: UIImage(named: "placeHolder"))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var sku = ""
        if searching{
            sku = searchProducts[indexPath.row].sku ?? ""
        }else{
            sku = productsList?[indexPath.row].sku ?? ""
        }
        let productID = Int(sku) ?? 0
        favViewModel?.getProductDetails(productID: productID)
        favViewModel?.fetchProductsDetailsToViewController = {() in self.renderViewToNavigate()}
    }
    
    func renderView(){
        DispatchQueue.main.async {
            let draftOrders = self.favViewModel?.getMyFavouriteDraft()
            if draftOrders != nil && draftOrders?.count != 0{
                print("draft not nil")
                self.productsList = draftOrders?[0].line_items
                self.favTableView.reloadData()
            }else{
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
            //print("iditem \(String(describing: self.favouriteViewModel?.fetchProductData))")
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
