//
//  HomeViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 01/06/2023.
//

import UIKit
//struct BrandModel{
//    var brandName: String
//    var brandImage: String
//}
class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    @IBOutlet weak var CouponsCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var currentCellIndex = 0
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var remoteDataSource: RemoteDataSourceProtocol?
    var homeViewModel : HomeViewModel?
    var timer: Timer?
    var brandsList: BrandModel?
    var couponsList:[String] = ["10Offer","20Offer","30Offer","40Offer","50Offer"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.CouponsCollectionView.collectionViewLayout = layout
        pageControl.numberOfPages = couponsList.count
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
        
        remoteDataSource = RemoteDataSource()
        homeViewModel = HomeViewModel(remoteDataSource: remoteDataSource ?? RemoteDataSource())
        homeViewModel?.fetchHomeData(resourse: "")
        homeViewModel?.fetchBrandsToHomeViewController = {() in self.renderView()}
        
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
    }
    @objc func slideToNext(){
        if currentCellIndex < couponsList.count-1{
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
            return brandsList?.smartCollections?.count ?? 0
        }
        return couponsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == brandsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionViewCell", for: indexPath) as? BrandsCollectionViewCell
            cell?.layer.borderWidth = 1
            cell?.layer.cornerRadius = 25
            cell?.layer.borderColor = UIColor.systemGray.cgColor
            cell?.setUpCell(brandImage: brandsList?.smartCollections?[indexPath.row].image?.src ?? "", brandName: brandsList?.smartCollections?[indexPath.row].title ?? "")
            return cell!
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponsCollectionViewCell", for: indexPath) as? CouponsCollectionViewCell
            cell?.setUpCell(couponImage: couponsList[indexPath.row])
            return cell!
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == brandsCollectionView{
            let size = (brandsCollectionView.frame.size.width-10)/2.5
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
        let brandProductsViewController = self.storyboard?.instantiateViewController(withIdentifier: "BrandProductsViewController") as! BrandProductsViewController
        brandProductsViewController.brandId = brandsList?.smartCollections?[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(brandProductsViewController, animated: true)
    }
}
