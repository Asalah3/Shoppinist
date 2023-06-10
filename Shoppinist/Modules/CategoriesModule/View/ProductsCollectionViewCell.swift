//
//  ProductsCollectionViewCell.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 01/06/2023.
//

import UIKit
import SDWebImage

class ProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var favObject : Product?
    var favDraftViewModel: DraftViewModel?
    var draft : Drafts? = Drafts()
    var myDraft: LineItem?
    var draftItem : DrafOrder?
    var isHasDraft : Bool?
    var currency = 0.0
    
    func setVieModel(draftViewModel: DraftViewModel) {
        self.favDraftViewModel = draftViewModel
        draftViewModel.bindingAllDrafts = { [weak self] in
            DispatchQueue.main.async {
                self?.isHasDraft = self?.favDraftViewModel?.checkIfCustomerHasFavDraft()
            }
        }
    }
    
    @IBAction func addTofavouriteButton(_ sender: Any) {
        
        if let favViewModel = favDraftViewModel,
           favViewModel.checkIfItemIsFav(productID: favObject?.id ?? 0){
            //favDraftViewModel?.getAllDrafts()
            favouriteButton.tintColor = UIColor.darkGray
            delProduct(itemId: favObject?.id ?? 0)
        } else {
            favouriteButton.tintColor = UIColor.red
            favDraftViewModel?.getAllDrafts()
            favDraftViewModel?.bindingAllDrafts = { [weak self] in
                DispatchQueue.main.async {
                    
                    let favDraft = self?.favDraftViewModel?.getMyFavouriteDraft()
                    if favDraft != nil && favDraft?.count != 0{
                        self?.draft?.draftOrder = favDraft?[0]
                        self?.draftItem = favDraft?[0]
                        let lineItem = LineItem(id: self?.favObject?.id, variantID: nil, productID: self?.favObject?.id, title: self?.favObject?.title, variantTitle: self?.favObject?.image?.src!, sku:"\(( self?.favObject?.id)!)"  , vendor: self?.favObject?.image?.src!, quantity: 2, requiresShipping: nil, taxable: nil, giftCard: nil, fulfillmentService: self?.favObject?.image?.src!, grams:20, taxLines: nil, name: self?.favObject?.image?.src!, custom: nil, price: self?.favObject?.variants?[0].price)
                        
                        self?.draft?.draftOrder?.lineItems?.append(lineItem)
                        self?.favDraftViewModel?.updateDraft(updatedDraft: (self?.draft)!)
                        self?.favDraftViewModel?.bindingDraftUpdate = { [weak self] in
                            print("view createddd")
                            DispatchQueue.main.async {
                                
                                if self?.favDraftViewModel?.ObservableDraftUpdate  == 201{
                                    print("updated insert succeess")
                                }
                                else{
                                    print("updated insert failed")
                                }
                            }
                        }
                    }else{
                        print("created")
                        
                        self?.favDraftViewModel?.saveDraft(product: (self?.favObject!)!, note: "favourite")
                        self?.favDraftViewModel?.bindingDraft = { [weak self] in
                            print("view created")
                            DispatchQueue.main.async {
                                
                                if self?.favDraftViewModel?.ObservableDraft  == 201{
                                    print("succeess")
                                }
                                else{
                                    print("failed")
                                }
                            }
                        }
                    }
                    
                    print("fav draft\(favDraft?.count ?? 0)")
                }
                }
        }
    }
    
    func setUpCell(product: Product){
        favObject = product
        if favDraftViewModel?.checkIfItemIsFav(productID: favObject?.id ?? 0) == true{
            favouriteButton.tintColor = UIColor.red
        } else {
            favouriteButton.tintColor = UIColor.darkGray
            
        }
        self.productName.text = product.title
        self.productPrice.layer.borderWidth = 1
        self.productPrice.layer.cornerRadius = self.productPrice.frame.height / 2
        if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
            let price = floor((Double(product.variants?[0].price ?? "0.0") ?? 0.0) * self.currency)
            self.productPrice.text = "\(String(price)) EGP"
        }else{
            self.productPrice.text = "\(product.variants?[0].price ?? "") $"
        }
        self.productImage.sd_setImage(with: URL(string:product.image?.src ?? ""), placeholderImage: UIImage(named: "placeHolder"))
    }
    
    
}

extension ProductsCollectionViewCell{
    
    func delProduct(itemId: Int){
//        if draft != nil && draft?.draftOrder != nil{
//            if draftItem?.lineItems?.count == 1{
//                deleteMyDraft()
//            }else{
//                deleteItemFromMyDraft(id: itemId)
//            }
//        }
    }
    
    func deleteMyDraft(){
        self.favDraftViewModel?.delDraft(draftId: (draftItem?.id)!)
        self.favDraftViewModel?.bindingDraftDelete = { [weak self] in
            print("view created")
            DispatchQueue.main.async {
                if self?.favDraftViewModel?.ObservableDraftDelete  == 200{
                    print("deleted succeess")
                    self?.favDraftViewModel?.getAllDrafts()
                }
                else{
                    print("deleted failed")
                }
            }
        }
    }
    
    
    func deleteItemFromMyDraft(id: Int){
        self.draft?.draftOrder = draftItem
        print("mydraftdraft\(String(describing: self.draft?.draftOrder?.lineItems))")
        let productId: String = "\((favObject?.id)!)"
        self.draft?.draftOrder?.lineItems?.removeAll(where: { item in
            item.sku! == productId
        })
        self.favDraftViewModel?.updateDraft(updatedDraft: (self.draft)!)
        self.favDraftViewModel?.bindingDraftUpdate = { [weak self] in
            print("view createddd")
            DispatchQueue.main.async {
                if self?.favDraftViewModel?.ObservableDraftUpdate  == 200 || self?.favDraftViewModel?.ObservableDraftUpdate  == 201{
                    print("updated item deleted")
                    self?.favDraftViewModel?.getAllDrafts()
                }else{
                    print("updated item deleted fail")
                }
            }
        }
    }
}
