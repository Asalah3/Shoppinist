//
//  DetailsViewController.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 03/06/2023.
//

import UIKit

class DetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var detailsSlider: UIPageControl!
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    @IBOutlet weak var detailsName: UILabel!
    @IBOutlet weak var detailsPrice: UILabel!
    @IBOutlet weak var detailsRate: UIView!
    @IBOutlet weak var detailsDescription: UITextView!
    @IBOutlet weak var detailsFavButton: UIButton!
    
    var product : Product?
    var currency : String = "EGP"
//    var localData: FavLocalDataSourceProtocol?
//    var remoteData : ProductDetailsDataSourceProtocol?
//    var favViewModel : FavViewModel?
    
    
//    var check = true
//    var currentCellIndex = 0
//    var cart : DrafOrder = DrafOrder()
//    var cartVM = ShoppingCartViewModel()
//    var lineitem = LineItem()
//    var newLineItem : LineItem?
//    var itemtitle : String?
//    var lineItemArray:[LineItem] = []
//    var lineAppend : [LineItem]?
//    var addtoLine : DrafOrder?
//    var cartcount = ShoppingCart()
//    var AllDraftsUrl = "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/draft_orders.json"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        viewWillAppear(false)
//
//        localData = FavLocalDataSource()
//        remoteData = ProductDetailsDataSource()
//        favViewModel = FavViewModel(localDataSource: localData!, remoteDataSource: remoteData!)
//
//        if let favID = product?.id,
//           let _ = favViewModel, ((favViewModel?.isExist(favouriteId:favID)) != nil){
//            detailsFavButton.tintColor = UIColor.red
//        } else {
//            detailsFavButton.tintColor = UIColor.darkGray
//
//        }
//
//        detailsName.text = "\(String(describing: (product?.vendor)!))|\(String(describing: (product?.productType)!))"
//        detailsPrice.text = "\(String(describing: (product?.variants?[0].price)!)) \(currency)"
//        detailsDescription.text = (product?.bodyHTML)!
//        detailsSlider.numberOfPages = product?.images?.count ?? 0
//        detailsSlider.currentPage = 0
//
//
//    }
//
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.images?.count ?? 0
    }
//
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionViewCell", for: indexPath) as? DetailsCollectionViewCell
        cell?.detailsImage.sd_setImage(with: URL(string:(product?.images?[indexPath.row].src)!), placeholderImage: UIImage(named: "placeHolder"))


        return cell ?? DetailsCollectionViewCell()
    }
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        detailsSlider.currentPage = indexPath.row
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = (detailsCollectionView.frame.size.width)
//        let width = (view.frame.size.width)
//        return CGSize(width: size, height: size)
//    }
//
    @IBAction func addToFav(_ sender: Any) {
        
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
        
//        cartVM.cartsUrl = self.AllDraftsUrl
//        cartVM.getAllDrafts()
//        cartVM.bindingCartt = {()in
//            self.renderCart()
//
//        }
    }
    
    @IBAction func addToBag(_ sender: Any) {
//        cartcount.draft_orders?.forEach({ email in
//
//    if  email.email ==  UserDefaultsManager.sharedInstance.getUserEmail()!
//            {
//
//        renderCartData ()
//
//        addtoLine = email
//        UserDefaultsManager.sharedInstance.setUserCart(cartId: email.id)
//        lineAppend = email.line_items
//        renderCartData ()
//        lineAppend?.forEach({itemm in
//            if itemm.title == self.product?.title  {
//                renderCartData ()
//
//                itemtitle = itemm.title
//                Utilites.displayToast(message: "Already in cart" , seconds: 2.0, controller: self ?? UIViewController())
//                print ("done")
//                renderCartData ()
//            }
//        })
//            if itemtitle == nil {
//                renderCartData ()
//        newLineItem = LineItem()
//        newLineItem?.title = product?.title
//        newLineItem?.price = product?.variants![0].price
//        newLineItem?.sku = product?.image?.src
//        newLineItem?.vendor = product?.vendor
//        newLineItem?.product_id = product?.id
//        newLineItem?.grams = product?.variants![0].inventory_quantity
//        newLineItem?.quantity = 1
//        lineAppend?.append(newLineItem!)
//        let draftOrder = DrafOrder()
//        draftOrder.line_items = lineAppend
//        addtoLine = draftOrder
//        let draftOrderAppend : ShoppingCartPut = ShoppingCartPut(draft_order:addtoLine)
//        putCart(cartt: draftOrderAppend)
//                Utilites.displayToast(message: "Added to cart ✅" , seconds: 2.0, controller: self ?? UIViewController())
//        UserDefaultsManager.sharedInstance.setCartState(cartState: true)
//        print ("already used")
//                print ("put")
//                renderCartData ()
//                    }
//
//                    }
//
//                })
//
//            if addtoLine == nil
//                                {
//                                self.postCart()
//                print ("posted")
//                Utilites.displayToast(message: "Added to cart ✅" , seconds: 2.0, controller: self ?? UIViewController())
//                UserDefaultsManager.sharedInstance.setCartState(cartState: true)
//                    }
//
//        renderCartData ()
//
    }
    
    }
    
    

//extension DetailsViewController {
//    func renderCart() {
//        DispatchQueue.main.async {
//            self.cartcount = self.cartVM.cartResult ?? ShoppingCart()
//
//
//        }
//
//
//    }
//
//
//}
//
//extension DetailsViewController {
//
//    func renderCartData () {
//        cartVM.cartsUrl = self.AllDraftsUrl
//        cartVM.getAllDrafts()
//        cartVM.bindingCartt = {()in
//            self.renderCart()
//
//        }
//
//    }
//
//
//}
//
//
//extension DetailsViewController {
//
//    func putCart(cartt:ShoppingCartPut){
//
//        self.cartVM.putNewCart(userCart: cartt) { data, response, error in
//                guard error == nil else {
//                    DispatchQueue.main.async {
//                        print ("carrt Error \n \(error?.localizedDescription ?? "")" )
//                    }
//                    return
//                }
//
//            guard response?.statusCode ?? 0 >= 200 && response?.statusCode ?? 0 < 300   else {
//                    DispatchQueue.main.async {
//                        print ("cart Response \n \(response ?? HTTPURLResponse())" )
//
//                    }
//                    return
//                }
//
//                print("cart was added successfully")
//
//                DispatchQueue.main.async {
//                    print("cart Saved")
//                }
//            }
//    }
//
//
//}
//
//extension DetailsViewController {
//    func postCart(){
//        let newdraft  : [String : Any] =  [ "draft_order" :
//                                                [
//
//                                                    "email": UserDefaultsManager.sharedInstance.getUserEmail()!,
//
//                                                    "currency": "Egp",
//
//                                                    "line_items" : [
//                                                        [
//
//                                                            "product_id": (self.product?.id)!,
//                                                            "title": (self.product?.title)! ,
//
//                                                            "sku": (product?.image?.src)!,
//                                                            "vender" : (self.product?.vendor)!,
//                                                            "quantity": 1,
//
//                                                            "grams":self.product!.variants![0].inventory_quantity!,
//
//                                                            "price": (self.product?.variants![0].price)!,
//
//                                                        ]
//                                                    ],
//                                                    "customer": [
//                                                        "id":UserDefaultsManager.sharedInstance.getUserID()
//                                                    ]
//
//                                                ]
//        ]
//        //        let customerCart : ShoppingCart = ShoppingCart()
//        //        customerCart.draft_order = cart
//
//        //(customer_address: address)
//        self.cartVM.postNewCart(userCart:newdraft){ data, response, error in
//            guard error == nil else {
//                DispatchQueue.main.async {
//                    print ("cart Error \n \(error?.localizedDescription ?? "")" )
//                }
//                return
//            }
//
//            guard response?.statusCode ?? 0 >= 200 && response?.statusCode ?? 0 < 300   else {
//                DispatchQueue.main.async {
//                    print ("cart Response \n \(response ?? HTTPURLResponse())" )
//
//                }
//                return
//            }
//            print ("this is response\(String(describing: response?.statusCode))")
//            print("cart was added successfully")
//
//            DispatchQueue.main.async {
//                print("cart Saved")
//            }
//        }
//    }
//}
