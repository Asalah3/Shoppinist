//
//  DetailsViewController.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 03/06/2023.
//

import UIKit

class DetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var detailsSlider: UIPageControl!
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    @IBOutlet weak var detailsName: UILabel!
    @IBOutlet weak var detailsPrice: UILabel!
    @IBOutlet weak var detailsRate: UIView!
    @IBOutlet weak var detailsDescription: UITextView!
    @IBOutlet weak var detailsFavButton: UIButton!
    
    var product : Product?
    var currency : String = "EGP"
    var localData: FavLocalDataSourceProtocol?
    var remoteData : ProductDetailsDataSourceProtocol?
    var favViewModel : FavViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localData = FavLocalDataSource()
        remoteData = ProductDetailsDataSource()
        favViewModel = FavViewModel(localDataSource: localData!, remoteDataSource: remoteData!)
        
        if let favID = product?.id,
           let _ = favViewModel, ((favViewModel?.isExist(favouriteId:favID)) != nil){
            detailsFavButton.tintColor = UIColor.red
        } else {
            detailsFavButton.tintColor = UIColor.darkGray
            
        }
        
        detailsName.text = "\(String(describing: (product?.vendor)!))|\(String(describing: (product?.productType)!))"
        detailsPrice.text = "\(String(describing: (product?.variants?[0].price)!)) \(currency)"
        detailsDescription.text = (product?.bodyHTML)!
        detailsSlider.numberOfPages = product?.images?.count ?? 0
        detailsSlider.currentPage = 0


    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionViewCell", for: indexPath) as? DetailsCollectionViewCell
        cell?.detailsImage.sd_setImage(with: URL(string:(product?.images?[indexPath.row].src)!), placeholderImage: UIImage(named: "placeHolder"))
        
        
        return cell ?? DetailsCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        detailsSlider.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (detailsCollectionView.frame.size.width)
        let width = (view.frame.size.width)
        return CGSize(width: size, height: size)
    }
    
    @IBAction func addToFav(_ sender: Any) {
        
        if let favouriteViewModel = favViewModel,
           favouriteViewModel.isExist(favouriteId: product?.id ?? 0){
            detailsFavButton.tintColor = UIColor.darkGray
            favouriteViewModel.deleteItemById(favouriteId: product?.id ?? 0)
        } else {
            detailsFavButton.tintColor = UIColor.red
            favViewModel?.localDataSource?.insertItem(favouriteName: product?.title ?? "", favouriteId: product?.id ?? 0, favouriteImage: product?.image?.src ?? "", favouritePrice: detailsPrice.text ?? "")
        }
        
    }
    
    @IBAction func addToBag(_ sender: Any) {
    }
    
}
