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
    func saveDraft(product: Product, note: String){
        DraftNetwork.CreateDraft(product: product, note: note) { draft in
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
    func getMyDrafts()->[DrafOrder]{
        var returnedValue = [DrafOrder]()
        
        if let observable = observableAllDrafts {
            print(observable.draft_orders?.count ?? 0)
            for i in 0..<(observable.draft_orders?.count ?? 0){
                if UserDefaults.standard.integer(forKey:"customerID") == observable.draft_orders?[i].customer?.id{
                    returnedValue.append((observable.draft_orders?[i])!)
                }
            }
        }
        return returnedValue
    }
    
    //-----------for retrieve my fav-----------
    func getMyFavouriteDraft()->[DrafOrder]{
        var returnedValue = [DrafOrder]()
        
        if let observable = observableAllDrafts {
            print(observable.draft_orders?.count ?? 0)
            for i in 0..<(observable.draft_orders?.count ?? 0){
                if UserDefaults.standard.integer(forKey:"customerID") == observable.draft_orders?[i].customer?.id && observable.draft_orders?[i].note == "favourite"{
                    returnedValue.append((observable.draft_orders?[i])!)
                }
            }
        }
        return returnedValue
    }
    
    //-----------for check product in my fav-----------
    func checkIfCustomerHasFavDraft()->Bool{
        var returnedValue = false
        
        if let observable = observableAllDrafts {
            print(observable.draft_orders?.count ?? 0)
            for i in 0..<(observable.draft_orders?.count ?? 0){
                if UserDefaults.standard.integer(forKey:"customerID") == observable.draft_orders?[i].customer?.id && observable.draft_orders?[i].note == "favourite"{
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
            print(observable.draft_orders?.count ?? 0)
            for i in 0..<(observable.draft_orders?.count ?? 0){
                if UserDefaults.standard.integer(forKey:"customerID") == observable.draft_orders?[i].customer?.id && observable.draft_orders?[i].note == "favourite"{
                    for n in 0..<(observable.draft_orders?[i].line_items?.count ?? 0){
                        print("proID \(observable.draft_orders?[i].line_items?[n].sku)")
                        print("proId\(productID)")
                        if ((observable.draft_orders?[i].line_items?[n].sku) ?? "") == "\(productID)"{
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
    func getProductDetails(productID : Int) {
        ProductDetailsDataSource.fetchProductDetails(product_id: productID){ result in
            guard let result = result else {return}
            print("itemdata \(result)")
            self.fetchProductData = result.product
        }
    }
    
    var fetchCurrencyToCell : (()->())={}
    var fetchCurrencyData:CurrenyModel!{
        didSet{
            fetchCurrencyToCell()
        }
    }
    func checkCurreny() -> Bool{
        var result = false
        if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
            result = true
        }
        return result 
    }
    func changeCurrency() {
        RemoteDataSource().getCurrency{curreny in
            guard let curreny = curreny else {return}
            self.fetchCurrencyData = curreny
        }
    }
   
    
}
