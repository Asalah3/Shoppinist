//
//  HomeViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 01/06/2023.
//

import UIKit
import Lottie

class HomeViewController: UIViewController {
    let appDelegate = UIApplication.shared.windows.first
    @IBOutlet weak var favButtonRight: UIBarButtonItem!
    @IBOutlet weak var cartButtonRight: UIBarButtonItem!
    @IBOutlet weak var NoData: AnimationView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    @IBOutlet weak var CouponsCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var currentCellIndex = 0
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var remoteDataSource: HomeRemoteDataSourceProtocol?
    var homeViewModel : HomeViewModel?
    var timer: Timer?
    var brandsList: BrandModel?
    var couponArr :[coupon]?
    var searchBrands = [SmartCollection]()
    var searching = false
    private var cartArray: [LineItem]?
    private var shoppingCartVM = ShoppingCartViewModel()
    
    var myDraftOrder : DrafOrder?
    var favViewModel : DraftViewModel?
    var draft : Drafts? = Drafts()
    var productsList : [LineItem]?
    var myCartDraftOrder : DrafOrder?
    var cartViewModel : ShoppingCartViewModel?
    var cartDraft : Drafts? = Drafts()
    var productsListCart : [LineItem]?
    
    override func viewWillAppear( _ animated: Bool){
        if UserDefaults.standard.bool(forKey: "Dark"){
            appDelegate?.overrideUserInterfaceStyle = .dark
        }
        else{
            appDelegate?.overrideUserInterfaceStyle = .light
        }
        //Favourites Logic
        productsList = [LineItem]()
        favViewModel = DraftViewModel()
        favViewModel?.getAllDrafts()
        favViewModel?.bindingAllDrafts = {() in self.renderFavView()}
        //Cart Logic
        productsListCart = [LineItem]()
        cartViewModel = ShoppingCartViewModel()
        cartViewModel?.getAllDrafts()
        cartViewModel?.bindingAllDrafts = {() in self.renderCartView()}
        if Utilites.isConnectedToNetwork() == false{
            Utilites.displayToast(message: "you are offline", seconds: 5, controller: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NoData.isHidden = true
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.CouponsCollectionView.collectionViewLayout = layout
        pageControl.numberOfPages = 5
        self.CouponsCollectionView.isPagingEnabled = true
        CouponsCollectionView.showsVerticalScrollIndicator = false
        CouponsCollectionView.showsHorizontalScrollIndicator = false
        
        let brandsLayout = UICollectionViewFlowLayout()
        brandsLayout.scrollDirection = .horizontal
        self.brandsCollectionView.collectionViewLayout = brandsLayout
        brandsCollectionView.showsVerticalScrollIndicator = false
        brandsCollectionView.showsHorizontalScrollIndicator = false
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        remoteDataSource = HomeRemoteDataSource()
        homeViewModel = HomeViewModel(remote: remoteDataSource ?? HomeRemoteDataSource())
        homeViewModel?.fetchHomeData(resourse: "")
        homeViewModel?.fetchBrandsToHomeViewController = {() in self.renderView()}
        
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
        
        couponArr = [coupon(img: UIImage(named: "10Offer")!, id: "10% offer") , coupon(img: UIImage(named: "20Offer")!, id: "20% offer") ,coupon(img: UIImage(named: "30Offer")!, id: "30% offer"),coupon(img: UIImage(named: "40Offer")!, id: "40% offer"),coupon(img: UIImage(named: "50Offer")!, id: "50% offer") ]
    }
    @objc func slideToNext(){
        if currentCellIndex < 4 {
            currentCellIndex = currentCellIndex + 1
        }else{
            currentCellIndex = 0
        }
        pageControl.currentPage = currentCellIndex
        CouponsCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == brandsCollectionView{
            if searching == true{
                return searchBrands.count
                
            }else{
                return brandsList?.smartCollections?.count ?? 0
            }
        }
        return couponArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == brandsCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionViewCell", for: indexPath) as? BrandsCollectionViewCell
            cell?.layer.borderWidth = 1
            cell?.layer.cornerRadius = 25
            cell?.layer.borderColor = UIColor.systemGray.cgColor
            cell?.clipsToBounds = true
            cell?.brandImage?.layer.cornerRadius = 25.0
            cell?.brandImage?.clipsToBounds = true
            if searching == true{
                cell?.setUpCell(brandImage: searchBrands[indexPath.row].image?.src ?? "", brandName: searchBrands[indexPath.row].title ?? "")
            }else{
                cell?.setUpCell(brandImage: brandsList?.smartCollections?[indexPath.row].image?.src ?? "", brandName: brandsList?.smartCollections?[indexPath.row].title ?? "")
            }
            return cell!
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponsCollectionViewCell", for: indexPath) as? CouponsCollectionViewCell
            
            cell?.couponImage.image = couponArr![indexPath.row].img
            return cell!
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == brandsCollectionView{
            let size = (brandsCollectionView.frame.size.width-10)/2.2
            return CGSize(width: size, height: size)
        }else{
            let size = (CouponsCollectionView.frame.size.width)
            return CGSize(width: size, height: (size-10)/2.25)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == CouponsCollectionView{
            return 0
        }else{
            return 10
        }
    }
    func renderView(){
        DispatchQueue.main.async {
            self.brandsList = self.homeViewModel?.fetchHomeData
            self.brandsCollectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == brandsCollectionView{
            let storyboard = UIStoryboard(name: "HomeStoryboard", bundle: nil)
            let brandProductsViewController = storyboard.instantiateViewController(withIdentifier: "BrandProductsViewController") as! BrandProductsViewController
            if searching == true{
                brandProductsViewController.brandId = searchBrands[indexPath.row].id ?? 0
            }else{
                brandProductsViewController.brandId = brandsList?.smartCollections?[indexPath.row].id ?? 0
            }
            self.navigationController?.pushViewController(brandProductsViewController, animated: true)
        }
        else{
            if UserDefaults.standard.integer(forKey:"customerID") != 0{
                UIPasteboard.general.string = couponArr![indexPath.row].id
                Utilites.displayToast(message: "Congratulations! you get a \(couponArr![indexPath.row].id) " , seconds: 2.0, controller: self )
                
                UserDefaultsManager.sharedInstance.setUserCoupon(userCoupon: couponArr![indexPath.row].id)
                print("user defult for coupon \(UserDefaultsManager.sharedInstance.getUserCoupon())")
            }else{
                
                let confirmAction = UIAlertAction(title: "Sign up", style: .default){ action  in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                    viewController.flag = true
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                Utilites.displayAlert(title: "You must Sign up", message: "You must Sign up?", action: confirmAction, controller: self )
            }
        }
    }
}


//------------------search bar-----------------------
extension HomeViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBrands = brandsList?.smartCollections?.filter({$0.title?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased()}) ?? [SmartCollection]()
        searching = true
        brandsCollectionView.reloadData()
        if self.searchBrands.count == 0{
            self.brandsCollectionView.isHidden = true
            self.NoData.isHidden = false
            self.NoData.contentMode = .scaleAspectFit
            self.NoData.loopMode = .loop
            self.NoData.play()
        }else{
            self.brandsCollectionView.isHidden = false
            self.NoData.isHidden = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        brandsCollectionView.reloadData()
    }
}

extension HomeViewController{
    func renderFavView(){
        DispatchQueue.main.async {
            let draftOrders = self.favViewModel?.getMyFavouriteDraft()
            if draftOrders != nil && draftOrders?.count != 0{
                self.myDraftOrder = draftOrders?[0]
                self.productsList = draftOrders?[0].lineItems
            }
        }
    }
    func renderCartView(){
        DispatchQueue.main.async {
            let draftOrders = self.cartViewModel?.getMyCartDraft()
            if draftOrders != nil && draftOrders?.count != 0{
                self.myCartDraftOrder = draftOrders?[0]
                self.productsListCart = draftOrders?[0].lineItems
                self.cartButtonRight.addBadge(text: "\(String(describing: self.productsListCart?.count ?? 0))" , withOffset: CGPoint(x: -5, y: 0))
            }
            else{
                self.cartButtonRight.addBadge(text: "0" , withOffset: CGPoint(x: -5, y: 0))
            }
        }
    }
}
