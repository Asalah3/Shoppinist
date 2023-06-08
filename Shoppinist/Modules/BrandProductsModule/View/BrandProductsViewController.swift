//
//  BrandProductsViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 02/06/2023.
//

import UIKit

class BrandProductsViewController: UIViewController {
    @IBOutlet weak var productsCollectionView: UICollectionView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var remoteDataSource: RemoteDataSourceProtocol?
    var brandProductsViewModel : BrandProductsViewModel?
    var localData: FavLocalDataSourceProtocol?
    var remoteData : ProductDetailsDataSourceProtocol?
    var favViewModel : DraftViewModel?
    var productsList : ProductModel?
    var brandId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
//        localData = FavLocalDataSource()
//        remoteData = ProductDetailsDataSource()
//        favViewModel = FavViewModel(localDataSource: localData!, remoteDataSource: remoteData!)
        favViewModel = DraftViewModel()
        let brandsLayout = UICollectionViewFlowLayout()
        brandsLayout.scrollDirection = .vertical
        self.productsCollectionView.collectionViewLayout = brandsLayout
        productsCollectionView.showsVerticalScrollIndicator = false
        productsCollectionView.showsHorizontalScrollIndicator = false
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
                activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        remoteDataSource = RemoteDataSource()
        brandProductsViewModel = BrandProductsViewModel(remoteDataSource: remoteDataSource ?? RemoteDataSource())
        brandProductsViewModel?.fetchBrandProducts(collectionId: brandId)
        brandProductsViewModel?.fetchProductsToBrandProductsViewController = {() in self.renderView()}
    }
}
extension BrandProductsViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsList?.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as? ProductsCollectionViewCell
        cell?.layer.borderWidth = 1
        cell?.layer.cornerRadius = 25
        cell?.layer.borderColor = UIColor.systemGray.cgColor
        let product = productsList?.products?[indexPath.row]
        cell?.setVieModel(draftViewModel:favViewModel!)
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
//        let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
//        detailsViewController.product = self.productsList?.products?[indexPath.row]
//        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func renderView(){
        DispatchQueue.main.async {
            self.productsList = self.brandProductsViewModel?.fetchProductsData
            self.productsCollectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}
