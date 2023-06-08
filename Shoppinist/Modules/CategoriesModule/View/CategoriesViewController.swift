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
    @IBOutlet weak var noData: AnimationView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var categoriesSegment: UISegmentedControl!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var remoteDataSource: RemoteDataSourceProtocol?
    var categoriesViewModel : CategoriesViewModel?
//    var localData: FavLocalDataSourceProtocol?
//    var remoteData : ProductDetailsDataSourceProtocol?
    var favViewModel : DraftViewModel?
    var productsList : [Product]?
    var filteredList : [Product]?
    var isFiltered : Bool = false
    override func viewWillAppear(_ animated: Bool) {
        noData.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        localData = FavLocalDataSource()
//        remoteData = ProductDetailsDataSource()
//        favViewModel = FavViewModel(localDataSource: localData!, remoteDataSource: remoteData!)
        favViewModel = DraftViewModel()
        let actionButton = JJFloatingActionButton()
        actionButton.buttonColor = UIColor(red: CGFloat(0.61), green: CGFloat(0.45), blue: CGFloat(0.84), alpha: CGFloat(1.0))
        actionButton.buttonImage = UIImage(named: "filter")
        actionButton.addItem(title: "shoes", image: UIImage(named: "shoe")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
            print("Shoes")
            self.filterBySubFilters(filterType: "SHOES")
        }

        actionButton.addItem(title: "T-Shirts", image: UIImage(named: "tshirt")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
            print("T-Shirt")
            self.filterBySubFilters(filterType: "T-SHIRTS")
        }

        actionButton.addItem(title: "Accessories", image: UIImage(named: "accessories")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
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
            remoteDataSource = RemoteDataSource()
            categoriesViewModel = CategoriesViewModel(remoteDataSource: remoteDataSource ?? RemoteDataSource())
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
        if isFiltered{
            return filteredList?.count ?? 0
        }
        return productsList?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as? ProductsCollectionViewCell
        cell?.layer.borderWidth = 1
        cell?.layer.cornerRadius = 25
        cell?.layer.borderColor = UIColor.systemGray.cgColor
        let product : Product?
        if isFiltered {
            product = filteredList?[indexPath.row]
        }else{
            product = productsList?[indexPath.row]
        }
        cell?.setVieModel(draftViewModel:favViewModel!)
        cell?.setUpCell(product: product!)
        return cell ?? ProductsCollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (categoriesCollectionView.frame.size.width - 10)/2
        return CGSize(width: size, height: size * 1.2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
//        if isFiltered == true{
//            detailsViewController.product = self.filteredList?[indexPath.row]
//        }else{
//            detailsViewController.product = self.productsList?[indexPath.row]
//        }
//
//        self.navigationController?.pushViewController(detailsViewController, animated: true)
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
