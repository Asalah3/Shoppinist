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
    var localData : FavLocalDataSourceProtocol?
    var remoteData : ProductDetailsDataSourceProtocol?

    
    override func viewWillAppear(_ animated: Bool) {
        localData = FavLocalDataSource()
        remoteData = ProductDetailsDataSource()
        favouriteViewModel = FavViewModel(localDataSource: localData!, remoteDataSource: remoteData!)
        favouritesList = favouriteViewModel?.getFavouritesResult()
        if favouritesList?.count == 0 || favouritesList == nil{
            favouriteCollectionView.isHidden = true
            noFavImage.isHidden = false
            noFavImage.contentMode = .scaleAspectFit
            noFavImage.loopMode = .loop
            noFavImage.play()
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
        let size = (view.frame.size.width - 10)/2
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
            print("iditem \(String(describing: self.favouriteViewModel?.fetchProductData))")
            self.navigationController?.pushViewController(detailsViewController, animated: true)

            
        }
    }
    
    
}
