//
//  ShoppingCartViewModel.swift
//  Shoppinist
//
//  Created by Asalah Sayed on 19/06/2023.
//

import Foundation
class ShoppingCartViewModel{
    //-----------for network connection -----------
    var bindingCheckConnectivity : (()->())={}
    var ObservableConnection: Bool!{
        didSet{
            bindingCheckConnectivity()
        }
    }
    
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
    
    
    //-----------for network connection -----------
    func checkNetwork(){
        Utilites.isConnectedToNetwork() { connection in
            self.ObservableConnection = connection
        }
    }
    
    
    //-----------for create draft-----------
    func saveDraft(product: Product, note: String){
        CartNetwork.CreateDraft(product: product, note: note) { draft in
            self.ObservableDraft = draft
        }
    }
    
    //-----------for delete draft-----------
    func delDraft(draftId: Int){
        CartNetwork.deleteDraft(draftID: draftId) { draft in
            self.ObservableDraftDelete = draft
        }
    }
    
    //-----------for retrieve drafts-----------
    func getAllDrafts(){
        CartNetwork.getAllDraftOrders() { returnedDrafts ,_ in
            self.observableAllDrafts = returnedDrafts
        }
    }
    //-----------for update draft-----------
    func updateDraft(updatedDraft: Drafts){
        CartNetwork.updateDraft(draft: updatedDraft) { draft in
            self.ObservableDraftUpdate = draft
        }
    }
    
    
    //-----------for retrieve my fav-----------
    func getMyCartDraft()->[DrafOrder]{
        var returnedValue = [DrafOrder]()
        
        if let observable = observableAllDrafts {
            print(observable.draftOrders?.count ?? 0)
            for i in 0..<(observable.draftOrders?.count ?? 0){
                if UserDefaults.standard.integer(forKey:"customerID") == observable.draftOrders?[i].customer?.id && observable.draftOrders?[i].note == "cart"{
                    returnedValue.append((observable.draftOrders?[i])!)
                }
            }
        }
        print("my fav draft count")
        print(returnedValue.count)
        return returnedValue
    }
    
    //-----------for check product in my fav-----------
    func checkIfCustomerHasCartDraft()->Bool{
        var returnedValue = false
        
        if let observable = observableAllDrafts {
            print(observable.draftOrders?.count ?? 0)
            for i in 0..<(observable.draftOrders?.count ?? 0){
                if UserDefaults.standard.integer(forKey:"customerID") == observable.draftOrders?[i].customer?.id && observable.draftOrders?[i].note == "cart"{
                    returnedValue = true
                    break
                }
            }
        }
        return returnedValue
    }
    
    //-----------for check product in my fav-----------
    func checkIfItemInCart(productID: Int)->Bool{
        var returnedValue = false
        
        if let observable = observableAllDrafts {
            print(observable.draftOrders?.count ?? 0)
            for i in 0..<(observable.draftOrders?.count ?? 0){
                if UserDefaults.standard.integer(forKey:"customerID") == observable.draftOrders?[i].customer?.id && observable.draftOrders?[i].note == "cart"{
                    for n in 0..<(observable.draftOrders?[i].lineItems?.count ?? 0){
                        print("proID \(observable.draftOrders?[i].lineItems?[n].sku)")
                        print("proId\(productID)")
                        let myString = observable.draftOrders?[i].lineItems?[n].sku ?? ""
                        let myArray = myString.split(separator: ",")
                        let productid = Int(myArray[0]) ?? 0
                        if ((productid) == productID){
                            returnedValue = true
                            break
                        }
                    }
                }
            }
        }
        return returnedValue
    }
    
}
