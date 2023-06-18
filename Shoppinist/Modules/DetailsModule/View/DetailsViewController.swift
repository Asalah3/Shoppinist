//
//  DetailsViewController.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 03/06/2023.
//

import UIKit
import Cosmos

class DetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var detailsReviewTable: UITableView!
    
    @IBOutlet weak var detailsSlider: UIPageControl!
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    @IBOutlet weak var detailsName: UILabel!
    @IBOutlet weak var detailsPrice: UILabel!
    @IBOutlet weak var detailsRate: CosmosView!
    @IBOutlet weak var detailsDescription: UITextView!
    @IBOutlet weak var detailsFavButton: UIButton!
    
    var product : Product?
    var draftViewModel: DraftViewModel?
    var reviewViewModel: ReviewViewModel?
    var reviewList : [Review]?
    
    var isHasDraft : Bool?
    var check = true
    var currentCellIndex = 0
    var currency = 0.0
    var favViewModel : DraftViewModel?
    var cart : DrafOrder = DrafOrder()
    var cartVM = ShoppingCartViewModel()
    var lineitem = LineItem()
    var newLineItem : LineItem?
    var itemtitle : String?
    var lineItemArray:[LineItem] = []
    var lineAppend : [LineItem]?
    var addtoLine : DrafOrder?
    var cartcount = AllDrafts()
    var myDraftOrder : DrafOrder?
    var draft : Drafts? = Drafts()
    var productsList : [LineItem]?
    var AllDraftsUrl = "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/draft_orders.json"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        renderCartData()
        detailsRate.isUserInteractionEnabled = false
        
        reviewViewModel = ReviewViewModel()
        reviewList = reviewViewModel?.getReviews()
        detailsReviewTable.reloadData()
        
        
        favViewModel = DraftViewModel()
        draftViewModel = DraftViewModel()
        draftViewModel?.getAllDrafts()
        draftViewModel?.bindingAllDrafts = {[weak self] in
            DispatchQueue.main.async { [self] in
                var isFav = self?.draftViewModel?.checkIfItemIsFav(productID: self?.product?.id ?? 0)
                if isFav ?? false{
                    self?.detailsFavButton.tintColor = UIColor.red
                }else{
                    self?.detailsFavButton.tintColor = UIColor.darkGray
                }
            }
        }
        self.favViewModel?.changeCurrency()
        self.favViewModel?.fetchCurrencyToCell = { [weak self] in
            DispatchQueue.main.async {
                self?.currency = (Double(self?.favViewModel?.fetchCurrencyData?.rates.egp ?? "0") ?? 0.0).rounded()
                if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
                    let price = floor((Double(self?.product?.variants?[0].price ?? "0.0")) ?? 0.0) * (self?.currency ?? 0)
                    self?.detailsPrice.text = "\(String(price)) EGP"
                }else{
                    self?.detailsPrice.text = "\(self?.product?.variants?[0].price ?? "") $"
                }
            }
        }
        
       // draftViewModel = DraftViewModel()

//        localData = FavLocalDataSource()
//        remoteData = ProductDetailsDataSource()
//        favViewModel = FavViewModel(localDataSource: localData!, remoteDataSource: remoteData!)
//        if let favID = product?.id,
//           let _ = draftViewModel, ((draftViewModel?.isExist(favouriteId:favID)) != nil){
//            detailsFavButton.tintColor = UIColor.red
//        } else {
//            detailsFavButton.tintColor = UIColor.darkGray
//
//        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.detailsCollectionView.collectionViewLayout = layout
        self.detailsCollectionView.isPagingEnabled = true
        detailsCollectionView.showsVerticalScrollIndicator = false
        detailsCollectionView.showsHorizontalScrollIndicator = false

        detailsRate.rating = Double(4)
        detailsName.text = product?.title
        detailsDescription.text = (product?.bodyHTML)!
        detailsSlider.numberOfPages = product?.images?.count ?? 0
        detailsSlider.currentPage = 0


    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.images?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionViewCell", for: indexPath) as? DetailsCollectionViewCell
        cell?.contentMode = .scaleAspectFill
        cell?.clipsToBounds = true
        cell?.detailsImage.sd_setImage(with: URL(string:(product?.images?[indexPath.row].src)!), placeholderImage: UIImage(named: "placeHolder"))


        return cell ?? DetailsCollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        detailsSlider.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (detailsCollectionView.frame.size.width)
        let height = (detailsCollectionView.frame.size.height)
        
        return CGSize(width: width, height: height)
    }




    @IBAction func addToFav(_ sender: Any) {
        
        if Utilites.isConnectedToNetwork(){
            draftViewModel?.getAllDrafts()
            draftViewModel?.bindingAllDrafts = { [weak self] in
                DispatchQueue.main.async {
                    
                    if let favViewModel = self?.draftViewModel,
                       favViewModel.checkIfItemIsFav(productID: self?.product?.id ?? 0){
                        
                        let draftOrders = self?.draftViewModel?.getMyFavouriteDraft()
                        if draftOrders != nil && draftOrders?.count != 0{
                            print("draft not nil")
                            self?.myDraftOrder = draftOrders?[0]
                            self?.productsList = draftOrders?[0].lineItems
                        }else{
                            print("draft is nil")
                        }
                        let confirmAction = UIAlertAction(title: "Delete", style: .default){ action  in
                            self?.detailsFavButton.tintColor = UIColor.darkGray
                            self?.delProduct(itemId: self?.product?.id ?? 0)
                        }
                        Utilites.displayAlert(title: "Delete from favourite!", message: "This item in favourite, Do you want to delete?", action: confirmAction, controller: self ?? DetailsViewController())
                        
                        
                    } else {
                        self?.detailsFavButton.tintColor = UIColor.red
                        let favDraft = self?.draftViewModel?.getMyFavouriteDraft()
                        var isHasDraft = self?.draftViewModel?.checkIfCustomerHasFavDraft()
                        print("hasDraft\(String(describing: isHasDraft))")
                        if isHasDraft ?? false{
                            self?.addItemToFavourite(favDraft: favDraft ?? [DrafOrder]())

                        }else{
                            self?.createDraftOrder()

                        }
                    }
                }
            }
        }else{
            let confirmAction = UIAlertAction(title: "OK", style: .default)
            Utilites.displayAlert(title: "Check internet connection", message: "you are offline?", action: confirmAction, controller: self)
        }

        
        
        
        
        
        
        
        
        
        
//        if let favouriteViewModel = favViewModel,
//           favouriteViewModel.isExist(favouriteId: product?.id ?? 0){
//            detailsFavButton.tintColor = UIColor.darkGray
//            favouriteViewModel.deleteItemById(favouriteId: product?.id ?? 0)
//        } else {
//            detailsFavButton.tintColor = UIColor.red
//            favViewModel?.localDataSource?.insertItem(favouriteName: product?.title ?? "", favouriteId: product?.id ?? 0, favouriteImage: product?.image?.src ?? "", favouritePrice: detailsPrice.text ?? "")
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        cartVM.cartsUrl = self.AllDraftsUrl
        cartVM.getCart()
        cartVM.bindingCartt = {()in
            self.renderCart()
            
        }
    }
    
    
    @IBAction func showMoreReviews(_ sender: Any) {
        let reviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        
        self.navigationController?.pushViewController(reviewViewController, animated: true)
    }
    
    @IBAction func addToBag(_ sender: Any) {
        
        renderCartData ()
        
        cartcount.draftOrders?.forEach({ email in

            if  email.email ==  UserDefaultsManager.sharedInstance.getUserEmail()! && email.note == nil
            {
        
        renderCartData ()
        
        addtoLine = email
        UserDefaultsManager.sharedInstance.setUserCart(cartId: email.id)
        lineAppend = email.lineItems
        renderCartData ()
        lineAppend?.forEach({itemm in
            if itemm.title == self.product?.title  {
                renderCartData ()
                
                itemtitle = itemm.title
                Utilites.displayToast(message: "Already in cart" , seconds: 1.0, controller: self)
                print ("done")
                renderCartData ()
            }
        })
            if itemtitle == nil {
                renderCartData ()
        newLineItem = LineItem()
        newLineItem?.title = product?.title
        newLineItem?.price = product?.variants![0].price
        newLineItem?.sku = product?.image?.src
        newLineItem?.vendor = product?.vendor
        newLineItem?.productID = product?.id
        newLineItem?.grams = product?.variants![0].inventory_quantity
        newLineItem?.quantity = 1
        lineAppend?.append(newLineItem!)
        var draftOrder = DrafOrder()
        draftOrder.lineItems = lineAppend
        addtoLine = draftOrder
        let draftOrderAppend : Drafts = Drafts(draftOrder:draftOrder)
        putCart(cartt: draftOrderAppend)
        Utilites.displayToast(message: "Added to cart" , seconds: 2.0, controller: self )
                renderCartData ()
        UserDefaultsManager.sharedInstance.setCartState(cartState: true)
        print ("already used")
                print ("put")
                renderCartData ()
                    }
                   
                    }
                  
                })
           
            if addtoLine == nil
                                {
                                self.postCart()
                renderCartData ()
                print ("posted")
                Utilites.displayToast(message: "Added to cart" , seconds: 2.0, controller: self )
                UserDefaultsManager.sharedInstance.setCartState(cartState: true)
                    }
      
        renderCartData ()
  }
}

extension DetailsViewController: UITabBarDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviewList?.count ?? 0 <= 3{
            return reviewList?.count ?? 0
        }else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        
        // cell radius
        cell.backView.layer.cornerRadius = 20.0
        cell.backView.layer.borderWidth = 1
        cell.backView.layer.borderColor = UIColor.darkGray.cgColor
        
        cell.clipsToBounds = true
        cell.reviewImage?.layer.cornerRadius = 38.0
        cell.reviewImage?.contentMode = .scaleAspectFill
        cell.reviewImage?.clipsToBounds = true
        cell.backView.clipsToBounds = true
        
        cell.reviewImage.image = UIImage(named: reviewList?[indexPath.row].image ?? "")
        cell.reviewText.text = reviewList?[indexPath.row].text ?? ""
        cell.reviewRate.rating = reviewList?[indexPath.row].rate ?? 0.00
        cell.reviewRate.isUserInteractionEnabled = false

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

extension DetailsViewController {
    func renderCart() {
        DispatchQueue.main.async {
            self.cartcount = self.cartVM.cartResult ?? AllDrafts()
        }
    }
}

extension DetailsViewController {
    
    func renderCartData () {
        cartVM.cartsUrl = self.AllDraftsUrl
        cartVM.getCart()
        cartVM.bindingCartt = {()in
            self.renderCart()
            
        }
    }
}

extension DetailsViewController {
    
    func putCart(cartt:Drafts){
        self.cartVM.putNewCart(userCart: cartt) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    print ("carrt Error \n \(error)" )
                }
                return
            }
            guard response?.statusCode ?? 0 >= 200 && response?.statusCode ?? 0 < 300   else {
                DispatchQueue.main.async {
                    print ("cart Response \n \(response ?? HTTPURLResponse())" )
                }
                return
            }
            print("cart was added successfully")
            DispatchQueue.main.async {
                print("cart Saved")
            }
        }
    }
}

extension DetailsViewController {
    func postCart(){
        let newdraft  : [String : Any] =  [ "draft_order" :
                                                [
                                                    
                                                    "email": UserDefaultsManager.sharedInstance.getUserEmail()!,
                                                    
                                                    "currency": "Egp",
                                                    
                                                    "line_items" : [
                                                        [
                                                            
                                                            "product_id": (self.product?.id)!,
                                                            "title": (self.product?.title)! ,
                                                            
                                                            "sku": (product?.image?.src)!,
                                                            "vender" : (self.product?.vendor)!,
                                                            "quantity": 1,
                                                            
                                                            "grams":self.product!.variants![0].inventory_quantity!,
                                                            
                                                            "price": (self.product?.variants![0].price)!,
                                                            
                                                        ]
                                                    ],
                                                    "customer": [
                                                        "id":UserDefaultsManager.sharedInstance.getUserID()
                                                    ]
                                                    
                                                ]
        ]
        self.cartVM.postNewCart(userCart:newdraft){ data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    print ("cart Error \n \(error?.localizedDescription ?? "")" )
                }
                return
            }
            
            guard response?.statusCode ?? 0 >= 200 && response?.statusCode ?? 0 < 300   else {
                DispatchQueue.main.async {
                    print ("cart Response \n \(response ?? HTTPURLResponse())" )
                    
                }
                return
            }
            print ("this is response\(String(describing: response?.statusCode))")
            print("cart was added successfully")
            
            DispatchQueue.main.async {
                print("cart Saved")
            }
        }
    }
}

extension DetailsViewController{
    func delProduct(itemId: Int){
        if self.productsList != nil && self.productsList?.count != 0{
            if self.myDraftOrder?.lineItems?.count == 1{
                self.deleteMyDraft()
            }else{
                self.deleteItemFromMyDraft(id: product?.id ?? 0)
            }
        }
    }
    
    func createDraftOrder(){
        self.draftViewModel?.saveDraft(product: product!, note: "favourite")
        self.draftViewModel?.bindingDraft = { [weak self] in
            print("view created")
            DispatchQueue.main.async {
                if self?.draftViewModel?.ObservableDraft  == 201{
                    Utilites.displayToast(message: "product added succeessfully", seconds: 2, controller: self ?? DetailsViewController())
                    self?.isHasDraft = self?.draftViewModel?.checkIfCustomerHasFavDraft()
                }
                else{
                    Utilites.displayToast(message: "product add failed", seconds: 2, controller: self ?? DetailsViewController())
                }
            }
        }
    }
    
    
    func addItemToFavourite(favDraft: [DrafOrder]){
        self.draft?.draftOrder = favDraft[0]
        print(self.draft ?? "nil draft")
        let lineItem = LineItem(id: nil, variantID: nil, productID: self.product?.id, title: self.product?.title, variantTitle: "", sku:"\(( self.product?.id)!)"  , vendor: "", quantity: 2, requiresShipping: false, taxable: false, giftCard: false, fulfillmentService: "", grams:20, taxLines: [TaxLine](), name: "", custom: false, price: self.product?.variants?[0].price)
        self.draft?.draftOrder?.lineItems?.append(lineItem)
        self.draftViewModel?.updateDraft(updatedDraft: (self.draft)!)
        self.draftViewModel?.bindingDraftUpdate = { [weak self] in
            print("view createddd")
            DispatchQueue.main.async {
                if self?.draftViewModel?.ObservableDraftUpdate  == 200 || self?.draftViewModel?.ObservableDraftUpdate  == 201{
                    Utilites.displayToast(message: "product added succeessfully", seconds: 2, controller: self ?? DetailsViewController())
                }else{
                    Utilites.displayToast(message: "product add failed", seconds: 2, controller: self ?? DetailsViewController())
                }
            }
        }
        isHasDraft = self.draftViewModel?.checkIfCustomerHasFavDraft()
    }
    
    
    func deleteMyDraft(){
        self.draftViewModel?.delDraft(draftId: myDraftOrder?.id ?? 0)
        self.draftViewModel?.bindingDraftDelete = { [weak self] in
            print("view created")
            DispatchQueue.main.async {
                if self?.draftViewModel?.ObservableDraftDelete  == 200{
                    Utilites.displayToast(message: "deleted succeessfully", seconds: 2, controller: self ?? DetailsViewController())
                }
                else{
                    Utilites.displayToast(message: "deleted failed", seconds: 2, controller: self ?? DetailsViewController())
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
        self.draftViewModel?.updateDraft(updatedDraft: (self.draft)!)
        self.draftViewModel?.bindingDraftUpdate = { [weak self] in
            print("view createddd")
            DispatchQueue.main.async {
                if self?.draftViewModel?.ObservableDraftUpdate  == 200 || self?.draftViewModel?.ObservableDraftUpdate  == 201{
                    Utilites.displayToast(message: "deleted succeessfully", seconds: 2, controller: self ?? DetailsViewController())
                }else{
                    Utilites.displayToast(message: "deleted failed", seconds: 2, controller: self ?? DetailsViewController())
                }
            }
        }
    }
    
    
}


