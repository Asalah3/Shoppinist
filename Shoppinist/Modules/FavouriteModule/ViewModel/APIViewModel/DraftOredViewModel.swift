//
//  DraftOredViewModel.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 06/06/2023.
//

import Foundation

class DraftViewModel{
    
    
    //-----------for create draft-----------
    var bindingDraft:(()->()) = {}
    var ObservableDraft : Int? {
        didSet {
            bindingDraft()
        }
    }
    
    //-----------for delete draft-----------
    var bindingDraftDelete:(()->()) = {}
    var ObservableDraftDelete : Int? {
        didSet {
            bindingDraftDelete()
        }
    }
    
    //-----------for retrieve drafts-----------
    var bindingAllDrafts:(()->()) = {}
    var observableAllDrafts : AllDrafts? {
        didSet {
            bindingAllDrafts()
        }
    }
    
    //-----------for update draft-----------
    var bindingDraftUpdate:(()->()) = {}
    var ObservableDraftUpdate : Int? {
        didSet {
            bindingDraftUpdate()
        }
    }
    
    //-----------for draft details-----------
    var fetchProductsDetailsToViewController : (()->())={}
    var fetchProductData:Product!{
        didSet{
            fetchProductsDetailsToViewController()
        }
    }
    
    //-----------for create draft-----------
    func saveDraft(productId:Int, productTitle: String, productQuantity: Int, productPrice: String,customerId: Int, note: String){
        DraftNetwork.CreateDraft(productId:productId, productTitle: productTitle, productQuantity: productQuantity, productPrice: productPrice, customerId: customerId, note: note) { draft in
            self.ObservableDraft = draft
        }
    }
    
    //-----------for delete draft-----------
    func delDraft(draftId: Int){
        DraftNetwork.deleteDraft(draftID: draftId) { draft in
            self.ObservableDraftDelete = draft
        }
    }
    
    //-----------for retrieve drafts-----------
    func getAllDrafts(){
        DraftNetwork.getAllDraftOrders() { returnedDrafts ,_ in
            self.observableAllDrafts = returnedDrafts
        }
    }
    //-----------for update draft-----------
    func updateDraft(updatedDraft: Drafts){
        DraftNetwork.updateDraft(draft: updatedDraft) { draft in
            self.ObservableDraftUpdate = draft
        }
    }
    
    //-----------for retrieve my Drafts-----------
    func getMyDrafts()->[DraftOrder]{
        var returnedValue = [DraftOrder]()
        
        if let observable = observableAllDrafts {
            print(observable.draftOrders?.count ?? 0)
            for i in 0..<(observable.draftOrders?.count ?? 0){
                if UserDefaults.standard.integer(forKey:"customerID") == observable.draftOrders?[i].customer?.id{
                    returnedValue.append((observable.draftOrders?[i])!)
                }
            }
        }
        return returnedValue
    }
    
    //-----------for retrieve my fav-----------
    func getMyFavouriteDraft()->[DraftOrder]{
        var returnedValue = [DraftOrder]()
        
        if let observable = observableAllDrafts {
            print(observable.draftOrders?.count ?? 0)
            for i in 0..<(observable.draftOrders?.count ?? 0){
                if UserDefaults.standard.integer(forKey:"customerID") == observable.draftOrders?[i].customer?.id && observable.draftOrders?[i].note == "favourite"{
                    returnedValue.append((observable.draftOrders?[i])!)
                }
            }
        }
        return returnedValue
    }
    
    //-----------for check product in my fav-----------
    func checkIfCustomerHasFavDraft()->Bool{
        var returnedValue = false
        
        if let observable = observableAllDrafts {
            print(observable.draftOrders?.count ?? 0)
            for i in 0..<(observable.draftOrders?.count ?? 0){
                if UserDefaults.standard.integer(forKey:"customerID") == observable.draftOrders?[i].customer?.id && observable.draftOrders?[i].note == "favourite"{
                    returnedValue = true
                    break
                }
            }
        }
        return returnedValue
    }
    
    //-----------for check product in my fav-----------
    func checkIfItemIsFav(productID: Int)->Bool{
        var returnedValue = false
        
        if let observable = observableAllDrafts {
            print(observable.draftOrders?.count ?? 0)
            for i in 0..<(observable.draftOrders?.count ?? 0){
                if UserDefaults.standard.integer(forKey:"customerID") == observable.draftOrders?[i].customer?.id && observable.draftOrders?[i].note == "favourite"{
                    for n in 0..<(observable.draftOrders?[i].lineItems?.count ?? 0){
                        if observable.draftOrders?[i].lineItems?[n].id == productID{
                            returnedValue = true
                            break
                        }
                    }
                }
            }
        }
        return returnedValue
    }
    
    //--------------get details from API-----------------
//    func getProductDetails(productID : Int) {
//        ProductDetailsDataSource?.fetchProductDetails(product_id: productID){ result in
//            guard let result = result else {return}
//            print("itemdata \(result)")
//            self.fetchProductData = result.product
//        }
//    }
    
    
   
    
}