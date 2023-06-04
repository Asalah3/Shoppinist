//
//  FavouriteViewController.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 03/06/2023.
//

import UIKit
import CoreData
import Lottie

class FavouriteViewController: UIViewController{
    
    @IBOutlet weak var noFavImage: AnimationView!
    @IBOutlet weak var favouriteCollectionView: UICollectionView!
    var favouriteViewModel: FavViewModel?
    var favouritesList : [NSManagedObject]?

    
    override func viewWillAppear(_ animated: Bool) {
        favouriteViewModel = FavViewModel(localDataSource: FavLocalDataSource(), remoteDataSource: ProductDetailsDataSource())
        favouritesList = favouriteViewModel?.getFavouritesResult()
        
        if favouritesList?.count == 0{
            favouriteCollectionView.isHidden = true
            favouriteCollectionView.isHidden = false
        }else{
            favouriteCollectionView.isHidden = false
            noFavImage.isHidden = true
        }
        self.favouriteCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noFavImage.isHidden = true
        
    }
}

extension FavouriteViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouritesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionViewCell", for: indexPath) as? FavouriteCollectionViewCell
        
        cell?.layer.borderWidth = 1
        cell?.layer.cornerRadius = 25
        cell?.layer.borderColor = UIColor.systemGray.cgColor
        
        let favouriteItem = (favouritesList?[indexPath.row])!
        cell?.setViewModel(favouriteViewModel: favouriteViewModel!, favCollection: favouriteCollectionView)
        cell?.setUpCell(favouriteItem: favouriteItem)
        return cell ?? FavouriteCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (favouriteCollectionView.frame.size.width - 10)/2
        return CGSize(width: size, height: size * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        favouriteViewModel?.getProductDetails(productID: (favouritesList?[indexPath.row].value(forKey: "id") as? Int) ?? 0)
        favouriteViewModel?.fetchProductsDetailsToViewController = {() in self.renderView()}
    }
    
    func renderView(){
        DispatchQueue.main.async {
            let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            detailsViewController.product = self.favouriteViewModel?.fetchProductData
            self.navigationController?.pushViewController(detailsViewController, animated: true)
            
            
        }
    }
    
    
}
