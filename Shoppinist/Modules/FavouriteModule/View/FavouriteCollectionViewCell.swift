//
//  FavouriteCollectionViewCell.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 03/06/2023.
//

import UIKit
import SDWebImage
import CoreData

class FavouriteCollectionViewCell: UICollectionViewCell {
    
    //    var favouriteViewModel : FavViewModelProtocol?
    //    var favItem : NSManagedObject?
    
    var favViewModel : DraftViewModel?
    var myFavDraft: LineItem?
    var draft : Drafts? = Drafts()
    
    
    @IBOutlet weak var favName: UILabel!
    @IBOutlet weak var favPrice: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    
    @IBAction func deleteFromFavourites(_ sender: Any) {
        //delProduct(itemId: myFavDraft?.quantity ?? 0)
        //favouriteViewModel?.deleteFavouriteItem(favouriteItem: favItem ?? NSManagedObject())
        favDraftViewModel?.getAllDrafts()
        favDraftViewModel?.bindingAllDrafts = { [weak self] in
            DispatchQueue.main.async {
                let favDraft = self?.favDraftViewModel?.getMyFavouriteDraft()
                let isHasDraft = self?.favDraftViewModel?.checkIfCustomerHasFavDraft()
                if isHasDraft ?? false{
                    if favDraft?[0].lineItems?.count == 1{
                        self?.favDraftViewModel?.delDraft(draftId: (favDraft?[0].id)!)
                        self?.favDraftViewModel?.bindingDraftDelete = { [weak self] in
                            print("view created")
                            DispatchQueue.main.async {
                                
                                if self?.favDraftViewModel?.ObservableDraftDelete  == 200{
                                    print("deleted succeess")
                                }
                                else{
                                    print("deleted failed")
                                }
                            }
                        }
                    }else{
                        
                        self?.draft?.draftOrder = favDraft?[0]
                        print(self?.draft ?? "nil draft")
                        self?.draft?.draftOrder?.lineItems?.removeAll(where: { item in
                            item.quantity == itemId
                        })
                        self?.favDraftViewModel?.updateDraft(updatedDraft: (self?.draft)!)
                        print("item deleted")
                        
                    }
                    
                }
            }
        }
    }
    
    func setViewModel(favDraftViewModel : DraftViewModel){
        self.favViewModel = favDraftViewModel
        self.favViewModel?.getAllDrafts()
    }
    
    func setUpCell(favouriteItem: LineItem){
        self.favPrice.layer.borderWidth = 1
        self.favPrice.layer.cornerRadius = self.favPrice.frame.height / 2
        
        self.myFavDraft = favouriteItem
        
        favButton.tintColor = UIColor.red
        let image : String = favouriteItem.sku ?? ""
        favImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeHolder"))
        favName.text = favouriteItem.title
        favPrice.text = favouriteItem.price
        print("favcellid \(Int(favouriteItem.id ?? 0))")
        
        //        self.favItem = favouriteItem
        //
        //        favButton.tintColor = UIColor.red
        //        let image : String = favouriteItem.value(forKey: "image") as? String ?? ""
        //        favImage.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeHolder"))
        //        favName.text = favouriteItem.value(forKey: "name") as? String
        //        favPrice.text = favouriteItem.value(forKey: "price") as? String
        //        print("favcellid \(favouriteItem.value(forKey: "id") as? Int)")
        
    }
    
    func delProduct(itemId: Int){
        favDraftViewModel?.getAllDrafts()
        favDraftViewModel?.bindingAllDrafts = { [weak self] in
            DispatchQueue.main.async {
                let favDraft = self?.favDraftViewModel?.getMyFavouriteDraft()
                let isHasDraft = self?.favDraftViewModel?.checkIfCustomerHasFavDraft()
                if isHasDraft ?? false{
                    if favDraft?[0].lineItems?.count == 1{
                        self?.favDraftViewModel?.delDraft(draftId: (favDraft?[0].id)!)
                        self?.favDraftViewModel?.bindingDraftDelete = { [weak self] in
                            print("view created")
                            DispatchQueue.main.async {
                                
                                if self?.favDraftViewModel?.ObservableDraftDelete  == 200{
                                    print("deleted succeess")
                                }
                                else{
                                    print("deleted failed")
                                }
                            }
                        }
                    }else{
                        
                        self?.draft?.draftOrder = favDraft?[0]
                        print(self?.draft ?? "nil draft")
                        self?.draft?.draftOrder?.lineItems?.removeAll(where: { item in
                            item.quantity == itemId
                        })
                        self?.favDraftViewModel?.updateDraft(updatedDraft: (self?.draft)!)
                        print("item deleted")
                        
                    }
                }
            }
        }
    }
}
