//
//  CategoriesViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 01/06/2023.
//

import UIKit
import JJFloatingActionButton
import Lottie
enum SubFilters {
case SHOES
case T_SHIRTS
case ACCESSORIES
}
class CategoriesViewController: UIViewController {
    @IBOutlet weak var favButtonRight: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noData: AnimationView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var categoriesSegment: UISegmentedControl!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var remoteDataSource: CategoriesRemoteDataSourceProtocol?
    var categoriesViewModel : CategoriesViewModelProtocol?
//    var localData: FavLocalDataSourceProtocol?
//    var remoteData : ProductDetailsDataSourceProtocol?
    var favViewModel : DraftViewModel?
    var productsList : [Product]?
    var filteredList : [Product]?
    var isFiltered : Bool = false
//    var currency = 0.0
    var searchProducts = [Product]()
    var searching = false
    var myDraftOrder : DrafOrder?
    var draft : Drafts? = Drafts()
    var productList : [LineItem]?
    
    private var cartArray: [LineItem]?
    private var shoppingCartVM = ShoppingCartViewModel()
  
    
    func getData(){
//        shoppingCartVM.getShoppingCart()
//        shoppingCartVM.bindingCart = {
//            self.renderViewCart()
//
//        }
    }
    func renderViewCart(){
//        DispatchQueue.main.async {
//            
//            self.cartArray = self.shoppingCartVM.cartList
//          
//           
//            }
   
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //Favourites Logic
        productList = [LineItem]()
        favViewModel = DraftViewModel()
        favViewModel?.getAllDrafts()
        favViewModel?.bindingAllDrafts = {() in self.renderFavView()}
        
        //-------------------------------------------
        if Utilites.isConnectedToNetwork() == false{
            Utilites.displayToast(message: "you are offline", seconds: 5, controller: self)
        }
        getData()
        let rightBarButton = self.navigationItem.rightBarButtonItem
        var count = cartArray?.count ?? 0
        
        rightBarButton?.addBadge(text: "\(count)" , withOffset: CGPoint(x: -60, y: 0))
        
        noData.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favViewModel = DraftViewModel()
        let actionButton = JJFloatingActionButton()
        actionButton.buttonColor = UIColor(red: CGFloat(0.61), green: CGFloat(0.45), blue: CGFloat(0.84), alpha: CGFloat(1.0))
        actionButton.buttonImage = UIImage(named: "filter")
        actionButton.addItem(title: "All", image: UIImage(named: "all")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
            self.searching = false
            self.searchBar.text = ""
            print("all")
            self.isFiltered = false
            self.renderView()
        }
        actionButton.addItem(title: "shoes", image: UIImage(named: "shoe")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
            self.searching = false
            self.searchBar.text = ""
            print("Shoes")
            self.filterBySubFilters(filterType: "SHOES")
        }

        actionButton.addItem(title: "T-Shirts", image: UIImage(named: "tshirt")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
            self.searching = false
            self.searchBar.text = ""
            print("T-Shirt")
            self.filterBySubFilters(filterType: "T-SHIRTS")
        }

        actionButton.addItem(title: "Accessories", image: UIImage(named: "accessories")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
            self.searching = false
            self.searchBar.text = ""
            print("Socks")
            self.filterBySubFilters(filterType: "ACCESSORIES")
        }
        
        actionButton.display(inViewController: self)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.categoriesCollectionView.collectionViewLayout = layout
        if isFiltered == false{
            activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = view.center
                    activityIndicator.startAnimating()
            view.addSubview(activityIndicator)
            remoteDataSource = CategoriesRemoteDataSource()
            categoriesViewModel = CategoriesViewModel(remoteDataSource: remoteDataSource ?? CategoriesRemoteDataSource())
            categoriesViewModel?.fetchCategoriesData(category: Categories.Men)
            categoriesViewModel?.fetchProductsToCategoriesViewController = {() in self.renderView()}
        }
        
        
        
    }
    func filterBySubFilters(filterType : String){
        self.isFiltered = true
        filteredList = categoriesViewModel?.filterBySubFilter(filter: filterType)
        self.categoriesCollectionView.reloadData()
        if self.filteredList?.count == 0{
            self.categoriesCollectionView.isHidden = true
            self.noData.isHidden = false
            self.noData.contentMode = .scaleAspectFit
            self.noData.loopMode = .loop
            self.noData.play()
        }else{
            self.categoriesCollectionView.isHidden = false
            self.noData.isHidden = true
        }
    }
    @IBAction func changeCategory(_ sender: Any) {
        isFiltered = false
        searching = false
        searchBar.text = ""
        switch categoriesSegment.selectedSegmentIndex{
        case 0:
            categoriesViewModel?.fetchCategoriesData(category: Categories.Men)
        case 1:
            categoriesViewModel?.fetchCategoriesData(category: Categories.Women)
        case 2:
            categoriesViewModel?.fetchCategoriesData(category: Categories.Kids)
        case 3:
            categoriesViewModel?.fetchCategoriesData(category: Categories.Sale)
        default:
            categoriesViewModel?.fetchCategoriesData(category: Categories.Men)
        }
        self.categoriesCollectionView.isHidden = true
        self.noData.isHidden = true
        activityIndicator.startAnimating()
        categoriesViewModel?.fetchProductsToCategoriesViewController = {() in self.renderView()}
    }
}
extension CategoriesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching == true {
            return searchProducts.count
        }else{
            if isFiltered{
                return filteredList?.count ?? 0
            }else{
                return productsList?.count ?? 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as? ProductsCollectionViewCell
        cell?.layer.borderWidth = 1
        cell?.layer.cornerRadius = 25
        cell?.layer.borderColor = UIColor.systemGray.cgColor
        cell?.clipsToBounds = true
        cell?.productImage?.layer.cornerRadius = 25.0
        cell?.productImage?.clipsToBounds = true
        let product : Product?
        if searching == true {
            product = searchProducts[indexPath.row]
        }else{
            if isFiltered {
                product = filteredList?[indexPath.row]
            }else{
                product = productsList?[indexPath.row]
            }
        }
        cell?.delegate = self
        cell?.setVieModel(draftViewModel:favViewModel!)
        cell?.setUpCell(product: product!)
        return cell ?? ProductsCollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (categoriesCollectionView.frame.size.width - 10)/2
        return CGSize(width: size, height: size * 1.4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    //----------------Navigate to details---------------
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Utilites.isConnectedToNetwork(){
            let storyboard = UIStoryboard(name: "CategoriesStoryboard", bundle: nil)
            let detailsViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            if searching == true{
                detailsViewController.product = self.searchProducts[indexPath.row]

            }else{
                if isFiltered == true{
                    detailsViewController.product = self.filteredList?[indexPath.row]
                }else{
                    detailsViewController.product = self.productsList?[indexPath.row]
                }
            }
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }else{
            let confirmAction = UIAlertAction(title: "OK", style: .default)
            Utilites.displayAlert(title: "Check internet connection", message: "you are offline?", action: confirmAction, controller: self)
        }
        
    }
    
    func renderView(){
        DispatchQueue.main.async {
            self.productsList = self.categoriesViewModel?.fetchCategoryData.products
            self.categoriesCollectionView.reloadData()
            self.activityIndicator.stopAnimating()
            if self.productsList?.count == 0{
                self.categoriesCollectionView.isHidden = true
                self.noData.isHidden = false
                self.noData.contentMode = .scaleAspectFit
                self.noData.loopMode = .loop
                self.noData.play()
            }
            else{
                self.categoriesCollectionView.isHidden = false
                self.noData.isHidden = true
            }
        }
    }
}

//------------------search bar-----------------------
extension CategoriesViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if isFiltered == true{
            searchProducts = filteredList?.filter({$0.title?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased()}) ?? [Product]()
        }else{
            searchProducts = productsList?.filter({$0.title?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased()}) ?? [Product]()
        }
        
        searching = true
        categoriesCollectionView.reloadData()
        if self.searchProducts.count == 0{
            self.categoriesCollectionView.isHidden = true
            self.noData.isHidden = false
            self.noData.contentMode = .scaleAspectFit
            self.noData.loopMode = .loop
            self.noData.play()
        }else{
            self.categoriesCollectionView.isHidden = false
            self.noData.isHidden = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        categoriesCollectionView.reloadData()
    }
}

extension CategoriesViewController: MyCustomCellDelegate{
    func navigateToSign() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showToast(message: String) {
        Utilites.displayToast(message: message, seconds: 2, controller: self)
    }
    
    func showAlert(title: String, message: String, confirmAction: UIAlertAction) {
        Utilites.displayAlert(title: title, message: message, action: confirmAction, controller: self)
    }
    
    
}

extension CategoriesViewController{
    func renderFavView(){
        DispatchQueue.main.async {
            let draftOrders = self.favViewModel?.getMyFavouriteDraft()
            if draftOrders != nil && draftOrders?.count != 0{
                self.myDraftOrder = draftOrders?[0]
                self.productList = draftOrders?[0].lineItems
                self.favButtonRight.addBadge(text: "\(String(describing: self.productList?.count ?? 0))" , withOffset: CGPoint(x: -10, y: 0))
            }
        }
    }
}

