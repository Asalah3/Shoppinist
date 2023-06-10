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
    var viewModel:DraftViewModel?
   // var draft : Drafts? = Drafts()
    var favList : [LineItem]?
//    var favouriteViewModel: FavViewModel?
//    var favouritesList : [NSManagedObject]?
//    var localData : FavLocalDataSourceProtocol?
//    var remoteData : ProductDetailsDataSourceProtocol?

    
    override func viewWillAppear(_ animated: Bool) {
//        localData = FavLocalDataSource()
//        remoteData = ProductDetailsDataSource()
//        favouriteViewModel = FavViewModel(localDataSource: localData!, remoteDataSource: remoteData!)
//        favouritesList = favouriteViewModel?.getFavouritesResult()
//        if favouritesList?.count == 0 || favouritesList == nil{
//            favouriteCollectionView.isHidden = true
//            noFavImage.isHidden = false
//            noFavImage.contentMode = .scaleAspectFit
//            noFavImage.loopMode = .loop
//            noFavImage.play()
//        }else{
//            favouriteCollectionView.isHidden = false
//            noFavImage.isHidden = true
//        }
        favList = [LineItem]()
        viewModel = DraftViewModel()
        viewModel?.getAllDrafts()
        viewModel?.bindingAllDrafts = { [weak self] in
            DispatchQueue.main.async {
                
                let myFav = self?.viewModel?.getMyFavouriteDraft()
                if myFav != nil && myFav?.count != 0{
                    self?.favList = myFav?[0].line_items
                    self?.favouriteCollectionView.reloadData()
                    print("getDrafts \(self?.favList?.count)")

                }
                self?.checkListCount()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noFavImage.isHidden = true
        
    }
}

extension FavouriteViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("favListLength\(favList?.count ?? 0)")
        return favList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionViewCell", for: indexPath) as? FavouriteCollectionViewCell
        
        cell?.layer.borderWidth = 1
        cell?.layer.cornerRadius = 25
        cell?.layer.borderColor = UIColor.systemGray.cgColor
        
        let favouriteItem = (favList?[indexPath.row])!
        cell?.setViewModel(favDraftViewModel: viewModel!)
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
        let sku = favList?[indexPath.row].sku ?? ""
        let productID = Int(sku) ?? 0
        
        viewModel?.getProductDetails(productID: productID)
        viewModel?.fetchProductsDetailsToViewController = {() in self.renderView()}
    }
    
    func renderView(){
        DispatchQueue.main.async {
            let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            
            detailsViewController.product = self.viewModel?.fetchProductData
            //print("iditem \(String(describing: self.favouriteViewModel?.fetchProductData))")
            self.navigationController?.pushViewController(detailsViewController, animated: true)

            
        }
    }
    func checkListCount(){
        if favList?.count == 0 || favList == nil{
            favouriteCollectionView.isHidden = true
            noFavImage.isHidden = false
            noFavImage.contentMode = .scaleAspectFit
            noFavImage.loopMode = .loop
            noFavImage.play()
        }else{
            favouriteCollectionView.isHidden = false
            noFavImage.isHidden = true
        }
    }
    
    
}
