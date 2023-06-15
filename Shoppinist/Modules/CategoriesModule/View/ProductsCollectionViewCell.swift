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
    var productsList : [LineItem]?
    var myDraftOrder : DrafOrder?
    
    func setVieModel(draftViewModel: DraftViewModel) {
        self.favDraftViewModel = draftViewModel
        draftViewModel.bindingAllDrafts = { [weak self] in
            DispatchQueue.main.async {
                self?.isHasDraft = self?.favDraftViewModel?.checkIfCustomerHasFavDraft()
            }
        }
    }
    
    @IBAction func addTofavouriteButton(_ sender: Any) {
        
        favDraftViewModel?.getAllDrafts()
        favDraftViewModel?.bindingAllDrafts = { [weak self] in
            DispatchQueue.main.async {
                
                if let favViewModel = self?.favDraftViewModel,
                   favViewModel.checkIfItemIsFav(productID: self?.favObject?.id ?? 0){
                    
                    self?.favouriteButton.tintColor = UIColor.darkGray
                    
                    let draftOrders = self?.favDraftViewModel?.getMyFavouriteDraft()
                    if draftOrders != nil && draftOrders?.count != 0{
                        print("draft not nil")
                        self?.myDraftOrder = draftOrders?[0]
                        self?.productsList = draftOrders?[0].lineItems
                    }else{
                        print("draft is nil")
                    }
                    
                    self?.delProduct(itemId: self?.favObject?.id ?? 0)
                    
                } else {
                    self?.favouriteButton.tintColor = UIColor.red
                    let favDraft = self?.favDraftViewModel?.getMyFavouriteDraft()
                    var isHasDraft = self?.favDraftViewModel?.checkIfCustomerHasFavDraft()
                    print("hasDraft\(String(describing: isHasDraft))")
                    if isHasDraft ?? false{
                        self?.draft?.draftOrder = favDraft?[0]
                        print(self?.draft ?? "nil draft")
                        let lineItem = LineItem(id: nil, variantID: nil, productID: self?.favObject?.id, title: self?.favObject?.title, variantTitle: "", sku:"\(( self?.favObject?.id)!)"  , vendor: "", quantity: 2, requiresShipping: false, taxable: false, giftCard: false, fulfillmentService: "", grams:20, taxLines: [TaxLine](), name: "", custom: false, price: self?.favObject?.variants?[0].price)
                        self?.draft?.draftOrder?.lineItems?.append(lineItem)
                        self?.favDraftViewModel?.updateDraft(updatedDraft: (self?.draft)!)
                        isHasDraft = self?.favDraftViewModel?.checkIfCustomerHasFavDraft()
                        print("updated")
                    }else{
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
                    print("fav draft\(favDraft?.count ?? 0)")
                }
            }
        }
    }
    
    func setUpCell(product: Product){
        favObject = product
        if favDraftViewModel?.checkIfItemIsFav(productID: product.id ?? 0) == true{
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
        if self.productsList != nil && self.productsList?.count != 0{
            if self.myDraftOrder?.lineItems?.count == 1{
                self.deleteMyDraft()
            }else{
                self.deleteItemFromMyDraft(id: self.favObject?.id ?? 0)
            }
        }
    }
    
    func deleteMyDraft(){
        self.favDraftViewModel?.delDraft(draftId: myDraftOrder?.id ?? 0)
        self.favDraftViewModel?.bindingDraftDelete = { [weak self] in
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
    }
    
    
    func deleteItemFromMyDraft(id: Int){
        self.draft?.draftOrder = myDraftOrder
        print("mydraftdraft\(String(describing: myDraftOrder?.lineItems))")
        let productId: String = "\(id)"
        self.draft?.draftOrder?.lineItems?.removeAll(where: { item in
            item.sku! == productId
        })
        self.favDraftViewModel?.updateDraft(updatedDraft: (self.draft)!)
        self.favDraftViewModel?.bindingDraftUpdate = { [weak self] in
            print("view createddd")
            DispatchQueue.main.async {
                if self?.favDraftViewModel?.ObservableDraftUpdate  == 200 || self?.favDraftViewModel?.ObservableDraftUpdate  == 201{
                    print("updated item deleted")
                }else{
                    
                    print("updated item deleted fail")
                }
            }
        }
    }
    
    
    
}
