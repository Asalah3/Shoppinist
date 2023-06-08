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
    var isHasDraft : Bool?

    
    func setVieModel(draftViewModel: DraftViewModel) {
        self.favDraftViewModel = draftViewModel
        draftViewModel.getAllDrafts()
        draftViewModel.bindingAllDrafts = { [weak self] in
            DispatchQueue.main.async {
                self?.isHasDraft = self?.favDraftViewModel?.checkIfCustomerHasFavDraft()
            }
        }
    }
    
    @IBAction func addTofavouriteButton(_ sender: Any) {
        
        if let favViewModel = favDraftViewModel,
           favViewModel.checkIfItemIsFav(productID: favObject?.id ?? 0){
            favDraftViewModel?.getAllDrafts()
            favouriteButton.tintColor = UIColor.darkGray
            delProduct(itemId: favObject?.id ?? 0)
        } else {
            favouriteButton.tintColor = UIColor.red
            favDraftViewModel?.getAllDrafts()
            favDraftViewModel?.bindingAllDrafts = { [weak self] in
                DispatchQueue.main.async {
                    
                    let myFav = self?.favDraftViewModel?.getMyDrafts()
                    let favDraft = self?.favDraftViewModel?.getMyFavouriteDraft()
                    var isHasDraft = self?.favDraftViewModel?.checkIfCustomerHasFavDraft()
                    print("hasDraft\(String(describing: isHasDraft))")
                    if isHasDraft ?? false{
                        self?.draft?.draftOrder = favDraft?[0]
                        print(self?.draft ?? "nil draft")
                        let lineItem = LineItem(id: self?.favObject?.id, variantID: nil, productID: self?.favObject?.id, title: self?.favObject?.title, variantTitle: "", sku:"\(( self?.favObject?.id)!)"  , vendor: "", quantity: 2, requiresShipping: false, taxable: false, giftCard: false, fulfillmentService: "", grams:20, taxLines: [TaxLine](), name: "", custom: false, price: self?.favObject?.variants?[0].price)
                        self?.draft?.draftOrder?.lineItems?.append(lineItem)
                        self?.favDraftViewModel?.updateDraft(updatedDraft: (self?.draft)!)
                        isHasDraft = self?.favDraftViewModel?.checkIfCustomerHasFavDraft()
                        print("updated")
                    }else{
                        print("created")
                        
                        self?.favDraftViewModel?.saveDraft(product: (self?.favObject!)!, note: "favourite")
                        self?.favDraftViewModel?.bindingDraft = { [weak self] in
                            print("view created")
                            DispatchQueue.main.async {
                                
                                if self?.favDraftViewModel?.ObservableDraft  == 201{
                                    print("succeess")
                                    isHasDraft = self?.favDraftViewModel?.checkIfCustomerHasFavDraft()
                                }
                                else{
                                    print("failed")
                                }
                            }
                        }
                    }
                    
                    print(myFav?.count ?? 0)
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
        self.productPrice.text = product.variants?[0].price
        self.productImage.sd_setImage(with: URL(string:product.image?.src ?? ""), placeholderImage: UIImage(named: "placeHolder"))
    }
    
    
}

extension ProductsCollectionViewCell{
    
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
