//
//  BrandProductsViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 02/06/2023.
//

import UIKit
import Lottie

class BrandProductsViewController: UIViewController {
    
    @IBOutlet weak var NoData: AnimationView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderRange: UILabel!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var remoteDataSource: BrandProductsRemoteDataSourceProtocol?
    var brandProductsViewModel : BrandProductsViewModelProtocol?
    var localData: FavLocalDataSourceProtocol?
    var remoteData : ProductDetailsDataSourceProtocol?
    var favViewModel : DraftViewModel?
    var productsList : [Product]?
    var brandId = 0
    var currency = 0.0
    var searchBrandProducts = [Product]()
    var filteredPrice : [Product] = []
    var searching = false
    var filtered = false
    
    override func viewWillAppear(_ animated: Bool) {
        favViewModel = DraftViewModel()
        self.favViewModel?.changeCurrency()
        self.favViewModel?.fetchCurrencyToCell = { [weak self] in
            DispatchQueue.main.async {
                self?.currency = (Double(self?.favViewModel?.fetchCurrencyData?.rates.egp ?? "0") ?? 0.0).rounded()
                self?.productsCollectionView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        localData = FavLocalDataSource()
//        remoteData = ProductDetailsDataSource()
//        favViewModel = FavViewModel(localDataSource: localData!, remoteDataSource: remoteData!)
        NoData.isHidden = true
        // -------------------- SetUp CollectionViewFlow --------------------
        let brandsLayout = UICollectionViewFlowLayout()
        brandsLayout.scrollDirection = .vertical
        self.productsCollectionView.collectionViewLayout = brandsLayout
        productsCollectionView.showsVerticalScrollIndicator = false
        productsCollectionView.showsHorizontalScrollIndicator = false
        
        // -------------------- SetUp ActivityIndicator --------------------
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
                activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        // -------------------- SetUp ViewModel --------------------
        
        remoteDataSource = BrandProductsRemoteDataSource()
        brandProductsViewModel = BrandProductsViewModel(remoteDataSource: remoteDataSource ?? BrandProductsRemoteDataSource())
        brandProductsViewModel?.fetchBrandProducts(collectionId: brandId)
        brandProductsViewModel?.fetchProductsToBrandProductsViewController = {() in self.renderView()}
    }
    
    @IBAction func changeSlider(_ sender: Any) {
        filtered = true
        self.sliderRange.text = String(floor(self.slider.value))
        filteredPrice = productsList?.filter({Float($0.variants?.first?.price ?? "0.0") ?? 0.0 <= slider.value}) ?? []
        self.productsCollectionView.reloadData()
        if self.filteredPrice.count == 0{
            self.productsCollectionView.isHidden = true
            self.NoData.isHidden = false
            self.NoData.contentMode = .scaleAspectFit
            self.NoData.loopMode = .loop
            self.NoData.play()
        }else{
            self.productsCollectionView.isHidden = false
            self.NoData.isHidden = true
        }
    }
}
extension BrandProductsViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching == true{
            return searchBrandProducts.count
        }else if filtered == true{
            return filteredPrice.count
        }else{
            return productsList?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as? ProductsCollectionViewCell
        cell?.layer.borderWidth = 1
        cell?.layer.cornerRadius = 25
        cell?.layer.borderColor = UIColor.systemGray.cgColor
        var product : Product?
        if searching == true{
            product = searchBrandProducts[indexPath.row]

        }else if filtered == true{
            product = filteredPrice[indexPath.row]
        }else{
            product = productsList?[indexPath.row]

        }
        cell?.setVieModel(draftViewModel:favViewModel!)
        cell?.currency = currency
        cell?.setUpCell(product: product!)
        return cell ?? ProductsCollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (productsCollectionView.frame.size.width - 10)/2
        return CGSize(width: size, height: size * 1.2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        if searching == true{
            detailsViewController.product = self.searchBrandProducts[indexPath.row]
        }else{
            detailsViewController.product = self.productsList?[indexPath.row]
        }
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func renderView(){
        DispatchQueue.main.async {
            self.productsList = self.brandProductsViewModel?.fetchProductsData
            self.slider.value = Float(self.productsList?.first?.variants?.first?.price ?? "0.0") ?? 0.0
            self.slider.minimumValue = Float(self.productsList?.first?.variants?.first?.price ?? "0.0") ?? 0.0
            self.slider.maximumValue = Float(self.productsList?.last?.variants?.first?.price ?? "0.0") ?? 0.0
            self.sliderRange.text = String(floor(self.slider.value))
            self.productsCollectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}

//------------------search bar-----------------------
extension BrandProductsViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var list : [Product] = []
        if filtered == true{
            list = filteredPrice
        }else{
            list = productsList ?? []
        }
        
        searchBrandProducts = list.filter({$0.title?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased()})
        searching = true
        productsCollectionView.reloadData()
        if self.searchBrandProducts.count == 0{
            self.productsCollectionView.isHidden = true
            self.NoData.isHidden = false
            self.NoData.contentMode = .scaleAspectFit
            self.NoData.loopMode = .loop
            self.NoData.play()
        }else{
            self.productsCollectionView.isHidden = false
            self.NoData.isHidden = true
        }
        if searchText == ""{
            searching = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        productsCollectionView.reloadData()
    }
}
