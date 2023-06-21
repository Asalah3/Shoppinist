//
//  DetailsViewController.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 03/06/2023.
//

import UIKit
import Cosmos

class DetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
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
    var cartVM: ShoppingCartViewModel?
    var lineitem = LineItem()
    var newLineItem : LineItem?
    var itemtitle : String?
    var lineItemArray:[LineItem] = []
    var lineAppend : [LineItem]?
    var addtoLine : DrafOrder?
    var cartcount = AllDrafts()
    var myDraftOrder : DrafOrder?
    var draft : Drafts? = Drafts()
    var myCartDraftOrder : DrafOrder?
    var cartDraft : Drafts? = Drafts()
    var productsList : [LineItem]?
    var AllDraftsUrl = "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/draft_orders.json"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsRate.isUserInteractionEnabled = false
        
        reviewViewModel = ReviewViewModel()
        reviewList = reviewViewModel?.getReviews()
        detailsReviewTable.reloadData()
        
        favViewModel = DraftViewModel()
        draftViewModel = DraftViewModel()
        draftViewModel?.getAllDrafts()
        draftViewModel?.bindingAllDrafts = {[weak self] in
            DispatchQueue.main.async { [self] in
                let isFav = self?.draftViewModel?.checkIfItemIsFav(productID: self?.product?.id ?? 0)
                if isFav ?? false{
                    self?.detailsFavButton.tintColor = UIColor.red
                }else{
                    self?.detailsFavButton.tintColor = UIColor.darkGray
                }
            }
        }
        cartVM = ShoppingCartViewModel()
        
        self.favViewModel?.changeCurrency()
        self.favViewModel?.fetchCurrencyToCell = { [weak self] in
            DispatchQueue.main.async {
                self?.currency = (Double(self?.favViewModel?.fetchCurrencyData?.rates.egp ?? "0") ?? 0.0)
                if UserDefaults.standard.string(forKey:"Currency") == "EGP"{
                    let price = floor((Double(self?.product?.variants?[0].price ?? "0.0")) ?? 0.0) * (self?.currency ?? 0)
                    self?.detailsPrice.text = "\(String(price)) EGP"
                }else{
                    self?.detailsPrice.text = "\(self?.product?.variants?[0].price ?? "") $"
                }
            }
        }
        
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
            if UserDefaults.standard.integer(forKey:"customerID") != 0{
                draftViewModel?.getAllDrafts()
                draftViewModel?.bindingAllDrafts = { [weak self] in
                    DispatchQueue.main.async {
                        
                        if let favViewModel = self?.draftViewModel,
                           favViewModel.checkIfItemIsFav(productID: self?.product?.id ?? 0){
                            
                            let draftOrders = self?.draftViewModel?.getMyFavouriteDraft()
                            if draftOrders != nil && draftOrders?.count != 0{
                                self?.myDraftOrder = draftOrders?[0]
                                self?.productsList = draftOrders?[0].lineItems
                            }else{
                            }
                            let confirmAction = UIAlertAction(title: "Delete", style: .default){ action  in
                                self?.detailsFavButton.tintColor = UIColor.darkGray
                                self?.delProduct(itemId: self?.product?.id ?? 0)
                            }
                            Utilites.displayAlert(title: "Delete from favourite!", message: "This item in favourite, Do you want to delete?", action: confirmAction, controller: self ?? DetailsViewController())
                            
                            
                        } else {
                            self?.detailsFavButton.tintColor = UIColor.red
                            let favDraft = self?.draftViewModel?.getMyFavouriteDraft()
                            let isHasDraft = self?.draftViewModel?.checkIfCustomerHasFavDraft()
                            if isHasDraft ?? false{
                                self?.addItemToFavourite(favDraft: favDraft ?? [DrafOrder]())
                                
                            }else{
                                self?.createDraftOrder()
                                
                            }
                        }
                    }
                }
            }else{
                let confirmAction = UIAlertAction(title: "Sign up", style: .default){ action  in
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                }
                                Utilites.displayAlert(title: "You must Sign up", message: "You must Sign up?", action: confirmAction, controller: self )
            }
        }else{
            let confirmAction = UIAlertAction(title: "OK", style: .default)
            Utilites.displayAlert(title: "Check internet connection", message: "you are offline?", action: confirmAction, controller: self)
        }
        
    }
    
    
    @IBAction func showMoreReviews(_ sender: Any) {
        let reviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        
        self.navigationController?.pushViewController(reviewViewController, animated: true)
    }
    
    @IBAction func addToBag(_ sender: Any) {
        if Utilites.isConnectedToNetwork(){
            if UserDefaults.standard.integer(forKey:"customerID") != 0{
                cartVM?.getAllDrafts()
                cartVM?.bindingAllDrafts = { [weak self] in
                    DispatchQueue.main.async {
                        if let cartViewModel = self?.cartVM,
                           cartViewModel.checkIfItemInCart(productID: self?.product?.id ?? 0){
                            Utilites.displayToast(message: "The Product Already In Cart", seconds: 5, controller: self ?? DetailsViewController())
                        } else {
                            let cartDraft = self?.cartVM?.getMyCartDraft()
                            let isHasDraft = self?.cartVM?.checkIfCustomerHasCartDraft()
                            if isHasDraft ?? false{
                                self?.addItemToCart(favDraft: cartDraft ?? [DrafOrder]())
                                
                            }else{
                                self?.createCartDraftOrder()
                                
                            }
                        }
                    }
                }
            }else{
                let confirmAction = UIAlertAction(title: "OK", style: .default)
                Utilites.displayAlert(title: "Warrning", message: "you must Sign Up", action: confirmAction, controller: self)
            }
        }else{
            let confirmAction = UIAlertAction(title: "OK", style: .default)
            Utilites.displayAlert(title: "Check internet connection", message: "you are offline?", action: confirmAction, controller: self)
        }
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
            DispatchQueue.main.async {
                if self?.draftViewModel?.ObservableDraft  == 201{
                    Utilites.displayToast(message: "Product added To WishList succeessfully", seconds: 2, controller: self ?? DetailsViewController())
                    self?.isHasDraft = self?.draftViewModel?.checkIfCustomerHasFavDraft()
                }
                else{
                    Utilites.displayToast(message: "Failed To Add The Product", seconds: 2, controller: self ?? DetailsViewController())
                }
            }
        }
    }
    
    
    func addItemToFavourite(favDraft: [DrafOrder]){
        self.draft?.draftOrder = favDraft[0]
        let lineItem = LineItem(id: nil, variantID: nil, productID: self.product?.id, title: self.product?.title, variantTitle: "", sku:"\((self.product?.id)!),\((self.product?.image?.src)!)"  , vendor: "", quantity: 1, requiresShipping: false, taxable: false, giftCard: false, fulfillmentService: "", grams:20, taxLines: [TaxLine](), name: "", custom: false, price: self.product?.variants?[0].price)
        self.draft?.draftOrder?.lineItems?.append(lineItem)
        self.draftViewModel?.updateDraft(updatedDraft: (self.draft)!)
        self.draftViewModel?.bindingDraftUpdate = { [weak self] in
            DispatchQueue.main.async {
                if self?.draftViewModel?.ObservableDraftUpdate  == 200 || self?.draftViewModel?.ObservableDraftUpdate  == 201{
                    Utilites.displayToast(message: "Product added To WishList succeessfully", seconds: 2, controller: self ?? DetailsViewController())
                }else{
                    Utilites.displayToast(message: "Failed To Add The Product", seconds: 2, controller: self ?? DetailsViewController())
                }
            }
        }
        isHasDraft = self.draftViewModel?.checkIfCustomerHasFavDraft()
    }
    
    
    func deleteMyDraft(){
        self.draftViewModel?.delDraft(draftId: myDraftOrder?.id ?? 0)
        self.draftViewModel?.bindingDraftDelete = { [weak self] in
            DispatchQueue.main.async {
                if self?.draftViewModel?.ObservableDraftDelete  == 200{
                    Utilites.displayToast(message: "Product deleted From Wishlist succeessfully", seconds: 2, controller: self ?? DetailsViewController())
                }
                else{
                    Utilites.displayToast(message: "Failed To Delete The Product", seconds: 2, controller: self ?? DetailsViewController())
                }
            }
        }
    }
    
    
    func deleteItemFromMyDraft(id: Int){
        self.draft?.draftOrder = myDraftOrder
        let productId: Int = id
        self.draft?.draftOrder?.lineItems?.removeAll(where: { item in
            let myString = item.sku ?? ""
            let myArray = myString.split(separator: ",")
            let productid = Int(myArray[0]) ?? 0
            return productid == productId
        })
        self.draftViewModel?.updateDraft(updatedDraft: (self.draft)!)
        self.draftViewModel?.bindingDraftUpdate = { [weak self] in
            print("view createddd")
            DispatchQueue.main.async {
                if self?.draftViewModel?.ObservableDraftUpdate  == 200 || self?.draftViewModel?.ObservableDraftUpdate  == 201{
                    Utilites.displayToast(message: "Product deleted From Wishlist succeessfully", seconds: 2, controller: self ?? DetailsViewController())
                }else{
                    Utilites.displayToast(message: "Failed To Delete The Product", seconds: 2, controller: self ?? DetailsViewController())
                }
            }
        }
    }
    
    
}
extension DetailsViewController{
    func createCartDraftOrder(){
        self.cartVM?.saveDraft(product: product!, note: "cart")
        self.cartVM?.bindingDraft = { [weak self] in
            DispatchQueue.main.async {
                if self?.cartVM?.ObservableDraft  == 201{
                    Utilites.displayToast(message: "Product added To Cart succeessfully", seconds: 2, controller: self ?? DetailsViewController())
                    self?.isHasDraft = self?.cartVM?.checkIfCustomerHasCartDraft()
                }
                else{
                    Utilites.displayToast(message: "Failed To Add The Product", seconds: 2, controller: self ?? DetailsViewController())
                }
            }
        }
    }
    
    func addItemToCart(favDraft: [DrafOrder]){
        self.cartDraft?.draftOrder = favDraft[0]
        let lineItem = LineItem(id: nil, variantID: nil, productID: self.product?.id, title: self.product?.title, variantTitle: "", sku:"\((self.product?.id)!),\((self.product?.image?.src)!)"  , vendor: "", quantity: 1, requiresShipping: false, taxable: false, giftCard: false, fulfillmentService: "", grams:self.product?.variants?.first?.inventory_quantity, taxLines: [TaxLine](), name: "", custom: false, price: self.product?.variants?[0].price)
        self.cartDraft?.draftOrder?.lineItems?.append(lineItem)
        self.cartVM?.updateDraft(updatedDraft: (self.cartDraft)!)
        self.cartVM?.bindingDraftUpdate = { [weak self] in
            DispatchQueue.main.async {
                if self?.cartVM?.ObservableDraftUpdate  == 200 || self?.cartVM?.ObservableDraftUpdate  == 201{
                    Utilites.displayToast(message: "Product added To Cart succeessfully", seconds: 2, controller: self ?? DetailsViewController())
                }else{
                    Utilites.displayToast(message: "Failed To Add The Product", seconds: 2, controller: self ?? DetailsViewController())
                }
            }
        }
        isHasDraft = self.cartVM?.checkIfCustomerHasCartDraft()
    }
}


