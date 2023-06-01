//
//  CategoriesViewController.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 01/06/2023.
//

import UIKit
struct CategoriesModel{
    var categoriesName: String
    var categoriesPrice: String
    var categoriesImage: String
}
class CategoriesViewController: UIViewController {
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var categoriesSegment: UISegmentedControl!
    var menList : [CategoriesModel] = [CategoriesModel(categoriesName: "Men", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),
                                              CategoriesModel(categoriesName: "Men", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),
                                              CategoriesModel(categoriesName: "Men", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),
                                              CategoriesModel(categoriesName: "Men", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),]
    var WomenList : [CategoriesModel] = [CategoriesModel(categoriesName: "Women", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),
                                              CategoriesModel(categoriesName: "Women", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),
                                              CategoriesModel(categoriesName: "Women", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),
                                              CategoriesModel(categoriesName: "Women", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),]
    var kidsList : [CategoriesModel] = [CategoriesModel(categoriesName: "kids", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),
                                              CategoriesModel(categoriesName: "kids", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),
                                              CategoriesModel(categoriesName: "kids", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),
                                              CategoriesModel(categoriesName: "kids", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),]
    var saleList : [CategoriesModel] = [CategoriesModel(categoriesName: "sale", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),
                                              CategoriesModel(categoriesName: "sale", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),
                                              CategoriesModel(categoriesName: "sale", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),
                                              CategoriesModel(categoriesName: "sale", categoriesPrice: "2500.2", categoriesImage: "placeHolder"),]
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.categoriesCollectionView.collectionViewLayout = layout
//        categoriesCollectionView.showsVerticalScrollIndicator = false
//        categoriesCollectionView.showsHorizontalScrollIndicator = false
        
    }

}
extension CategoriesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch categoriesSegment.selectedSegmentIndex{
        case 0:
            categoriesCollectionView.reloadData()
            return menList.count
        case 1:
            categoriesCollectionView.reloadData()
            return WomenList.count
        case 2:
            categoriesCollectionView.reloadData()
            return kidsList.count
        case 3:
            categoriesCollectionView.reloadData()
            return saleList.count
        default:
            categoriesCollectionView.reloadData()
            return menList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as? ProductsCollectionViewCell
        cell?.layer.borderWidth = 1
        cell?.layer.cornerRadius = 25
        cell?.layer.borderColor = UIColor.systemGray.cgColor
        switch categoriesSegment.selectedSegmentIndex{
        case 1:
            categoriesCollectionView.reloadData()
            cell?.setUpCell(productImage: WomenList[indexPath.row].categoriesImage, productName: WomenList[indexPath.row].categoriesName, productPrice: WomenList[indexPath.row].categoriesPrice)
        case 2:
            categoriesCollectionView.reloadData()
            cell?.setUpCell(productImage: kidsList[indexPath.row].categoriesImage, productName: kidsList[indexPath.row].categoriesName, productPrice: kidsList[indexPath.row].categoriesPrice)
        case 3:
            categoriesCollectionView.reloadData()
            cell?.setUpCell(productImage: saleList[indexPath.row].categoriesImage, productName: saleList[indexPath.row].categoriesName, productPrice: WomenList[indexPath.row].categoriesPrice)
        default:
            categoriesCollectionView.reloadData()
            cell?.setUpCell(productImage: menList[indexPath.row].categoriesImage, productName: menList[indexPath.row].categoriesName, productPrice: menList[indexPath.row].categoriesPrice)
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (categoriesCollectionView.frame.size.width - 10)/2
        return CGSize(width: size, height: size * 1.2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
