////
////  DraftOredViewModel.swift
////  Shoppinist
////
////  Created by Soha Ahmed Hamdy on 06/06/2023.
////
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
    var observableAllDrafts : ShoppingCart? {
        didSet {
            bindingAllDrafts()
        }
    }
    
    //-----------for create draft-----------
    func saveDraft(darftProduct: Product){
        DraftNetwork.CreateDraft(product: darftProduct) { draft in
            self.ObservableDraft = draft
        }
    }
    
    //-----------for delete draft-----------
    func delDraft(draftId: Int){
        DraftNetwork.deleteDraft(draftID: draftId) { draft in
            self.ObservableDraftDelete = draft
            self.getAllDrafts()
        }
    }
    
    //-----------for retrieve drafts-----------
    
    func getAllDrafts(){
        DraftNetwork.getAllDraftOrders() { returnedDrafts ,_ in
            self.observableAllDrafts = returnedDrafts
        }
    }
    
    //-----------for retrieve my fav-----------
    
    func getMyFavourites()->[DrafOrder]{
        var returnedValue = [DrafOrder]()
        
        if let observable = observableAllDrafts {
            print(observable.draft_orders?.count ?? 0)
            for i in 0..<(observable.draft_orders?.count ?? 0){
                if UserDefaults.standard.integer(forKey:"customerID") == observable.draft_orders?[i].customer?.id {
                    returnedValue.append((observable.draft_orders?[i])!)
                }
            }
        }
        return returnedValue
    }
    
    //-----------for check product in my fav-----------
    
    func checkIfFavourite(product: Product)->Bool{
        var returnedValue = false
        
        if let observable = observableAllDrafts {
            print(observable.draft_orders?.count ?? 0)
            for i in 0..<(observable.draft_orders?.count ?? 0){
                if UserDefaults.standard.integer(forKey:"customerID") == observable.draft_orders?[i].customer?.id  && product.title == observable.draft_orders?[i].line_items?[0].title {
                    returnedValue = true
                    break
                }
            }
        }
        return returnedValue
    }
   
    
}
