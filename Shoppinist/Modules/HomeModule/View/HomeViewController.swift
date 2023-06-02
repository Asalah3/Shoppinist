//
//  HomeViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 01/06/2023.
//

import UIKit
struct BrandModel{
    var brandName: String
    var brandImage: String
}
class HomeViewController: UIViewController {
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    @IBOutlet weak var CouponsCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var currentCellIndex = 0
    var timer: Timer?
    var brandsList:[BrandModel] = [BrandModel(brandName: "Brand", brandImage: "Brand"),
                                   BrandModel(brandName: "Brand", brandImage: "Brand"),
                                   BrandModel(brandName: "Brand", brandImage: "Brand"),
                                   BrandModel(brandName: "Brand", brandImage: "Brand"),
                                   BrandModel(brandName: "Brand", brandImage: "Brand"),
                                   BrandModel(brandName: "Brand", brandImage: "Brand"),
                                   BrandModel(brandName: "Brand", brandImage: "Brand")]
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
            return brandsList.count
        }
        return couponsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == brandsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandsCollectionViewCell", for: indexPath) as? BrandsCollectionViewCell
            cell?.layer.borderWidth = 1
            cell?.layer.cornerRadius = 25
            cell?.layer.borderColor = UIColor.systemGray.cgColor
            cell?.setUpCell(brandImage: brandsList[indexPath.row].brandImage, brandName: brandsList[indexPath.row].brandName)
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
            return CGSize(width: size, height: size * 1.15)
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
}
