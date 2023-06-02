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
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var remoteDataSource: RemoteDataSourceProtocol?
    var categoriesViewModel : CategoriesViewModel?
    var productsList : ProductModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.categoriesCollectionView.collectionViewLayout = layout
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
                activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        remoteDataSource = RemoteDataSource()
        categoriesViewModel = CategoriesViewModel(remoteDataSource: remoteDataSource ?? RemoteDataSource())
        
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
        categoriesViewModel?.fetchProductsToCategoriesViewController = {() in self.renderView()}
    }

    @IBAction func changeCategory(_ sender: Any) {
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
        categoriesViewModel?.fetchProductsToCategoriesViewController = {() in self.renderView()}
    }
}
extension CategoriesViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsList?.products?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as? ProductsCollectionViewCell
        cell?.layer.borderWidth = 1
        cell?.layer.cornerRadius = 25
        cell?.layer.borderColor = UIColor.systemGray.cgColor
        let product = productsList?.products?[indexPath.row]
        cell?.setUpCell(productImage: product?.image?.src ?? "", productName: product?.title ?? "", productPrice: "\(product?.variants[0].price ?? "")")
        return cell ?? ProductsCollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (categoriesCollectionView.frame.size.width - 10)/2
        return CGSize(width: size, height: size * 1.2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func renderView(){
        DispatchQueue.main.async {
            self.productsList = self.categoriesViewModel?.fetchCategoryData
            self.categoriesCollectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}
