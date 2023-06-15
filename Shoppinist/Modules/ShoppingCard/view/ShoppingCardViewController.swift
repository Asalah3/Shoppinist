//
//  ShoppingCardViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 04/06/2023.
//

import UIKit
import Reachability
import SDWebImage
import Lottie

class ShoppingCardViewController: UIViewController,UITableViewDataSource ,UITableViewDelegate,CounterProtocol {
    @IBOutlet weak var proccess_btn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var noData: AnimationView!
    private var flag: Bool = true
    private var deletedLineItem : LineItem?
    private var cartArray: [LineItem]?
    var lineItem = LineItem()
    private var counter: Int8 = 1
    private var shoppingCartVM = ShoppingCartViewModel()
    @IBOutlet weak var subTotalPrice: UILabel!
    private static var subTotalPrice = 0.0
    @IBOutlet weak var cardTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
          print("viewDidLoad")
        ShoppingCardViewController.subTotalPrice = 0.0
 
        self.cardTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        self.cardTableView.reloadData()
        ShoppingCardViewController.subTotalPrice = 0.0
        
        getData()
        self.cardTableView.reloadData()
        
    
       
    }

    func getData(){
        shoppingCartVM.getShoppingCart()
        self.cardTableView.reloadData()
        shoppingCartVM.bindingCart = {
            self.renderView()
           
        }
        self.cardTableView.reloadData()
    }
    func renderView(){
        DispatchQueue.main.async {
            self.cardTableView.reloadData()
            self.cartArray = self.shoppingCartVM.cartList
            if self.cartArray?.count == 0 {
            self.cardTableView.isHidden = true
            self.subTotalPrice.isHidden = true
            self.proccess_btn.isHidden = true
                self.priceLabel.isHidden = true
            self.noData.isHidden = false
            self.noData.contentMode = .scaleAspectFit
            self.noData.loopMode = .loop
            self.noData.play()
            }
            else {
                self.cardTableView.isHidden = false
                self.proccess_btn.isHidden = false
                self.subTotalPrice.isHidden = false
                self.priceLabel.isHidden = false
                self.noData.isHidden = true
               
            }
            self.cardTableView.reloadData()
            self.configureView()
           // self.activityIndicator.stopAnimating()
            self.cardTableView.reloadData()
            print("sub total : \(Self.subTotalPrice)")
           
            
            }
   
    }

    func configureView(){
        if cartArray != nil {
            self.shoppingCartVM.cartList?.forEach({ item in
                Self.subTotalPrice += Double(item.price ?? "0") ?? 0.0
            })
            
            setSubTotal()
            UserDefaultsManager.sharedInstance.setCartState(cartState: true)
        }
        
    }
    @IBAction func CheckOutButton(_ sender: Any) {
        
        
        guard let cart = cartArray else {return}
        
            putDraftOrder(lineItems: cart)
             self.setSubTotal()
        let addresVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectedAddress") as! SelectAddressViewController
        
        addresVC.price = Int(Self.subTotalPrice)
        addresVC.LineItems = cartArray
        self.navigationController?.pushViewController(addresVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return cartArray?.count ?? 0
           
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell  = tableView.dequeueReusableCell(withIdentifier: "shoppingCardCell", for: indexPath) as! ShoppingCardTableViewCell
           cell.name.text = cartArray?[indexPath.row].title
           if UserDefaults.standard.string(forKey: "Currency")  == "EGP" {
               let price = (Double(cartArray?[indexPath.row].price ?? "0") ?? 0.0)  * 30
               let priceString = "\(price.formatted()) EGP"
               cell.priceButton.text = priceString
           }
           else
           {
               let priceString = "\(cartArray?[indexPath.row].price ?? "0") $"
               cell.priceButton.text = priceString
           }
            

           let image = URL(string: cartArray?[indexPath.row].sku ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
           cell.img.sd_setImage(with:image)
           cell.counterProtocol = self
          cell.indexPath = indexPath
           cell.lineItem = cartArray
           cell.quantityLabel.text = cartArray?[indexPath.row].quantity?.formatted()
           cell.disableDecreaseBtn()
           
          self.setSubTotal()
           return cell
       }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
     
          
                deleteLineItemProduct(indexPath: indexPath)
                 setSubTotal()
            self.cardTableView.reloadData()
        }
    }
    
    
    
    func setItemQuantityToPut(quantity: Int, index: Int) {
        self.cartArray?[index].quantity = quantity
    }
    
    func increaseCounter() {
        Self.subTotalPrice = 0.0
        for index in  0...(cartArray?.count ?? 0)-1
        {
            let itemPrice = (Double(cartArray?[index].price ?? "") ?? 0.0) * (Double (cartArray?[index].quantity ?? 0))
            ShoppingCardViewController.subTotalPrice = Self.subTotalPrice + itemPrice
        }
        print("subtotal :\(Self.subTotalPrice)")
        setSubTotal()
    }
    
    func decreaseCounter(price: String) {
        
        
        let itemPrice = Double(price) ?? 0.0
            Self.subTotalPrice = Self.subTotalPrice - itemPrice
        
        print("subtotal :\(Self.subTotalPrice)")
        setSubTotal()
    }
    
    func deleteItem(indexPath: IndexPath) {
        self.deleteLineItemProduct(indexPath: indexPath)
        setSubTotal()
    }
    func setSubTotal(){
        if UserDefaults.standard.string(forKey: "Currency") == "EGP" {
            let price = (Int(Self.subTotalPrice) )  * 30
            let priceString = "\(price.formatted()) EGP"
            subTotalPrice.text = priceString
            UserDefaultsManager.sharedInstance.setTotalPrice(totalPrice: ShoppingCardViewController.subTotalPrice)
            print("UserDefultTotal Price \(UserDefaultsManager.sharedInstance.getTotalPrice()) ")
        }
        else
        {
            let price = (Double(Self.subTotalPrice) )
            let priceString = "\(price.formatted()) $"
            DispatchQueue.main.async {
                self.subTotalPrice.text = priceString
                UserDefaultsManager.sharedInstance.setTotalPrice(totalPrice: ShoppingCardViewController.subTotalPrice)
                print("UserDefultTotal Price \(UserDefaultsManager.sharedInstance.getTotalPrice()) ")
            }
        }
    }
    func deleteLineItemProduct(indexPath : IndexPath)
    {
        
            deletedLineItem = cartArray?[indexPath.row]
            cartArray?.remove(at: indexPath.row)
        cardTableView.deleteRows(at: [indexPath], with: .automatic)
        setSubTotal()
            DispatchQueue.main.asyncAfter(deadline: .now()+3.5){
                if self.flag == true {
                    if !(self.cartArray?.count == 0){
                        self.putDraftOrder(lineItems: self.cartArray ?? [])
                    }
                    else
                    {
                        self.deleteCart()
                        if UserDefaults.standard.string(forKey: "Currency") == "EGP"{
                            self.subTotalPrice.text = "0 EGP"
                            self.cardTableView.isHidden = true
                            self.subTotalPrice.isHidden = true
                            self.proccess_btn.isHidden = true
                            self.priceLabel.isHidden = true
                            self.noData.isHidden = false
                            self.noData.contentMode = .scaleAspectFit
                            self.noData.loopMode = .loop
                            self.noData.play()
                        }
                        else{
                            self.subTotalPrice.text = "0 $"
                            self.cardTableView.isHidden = true
                            self.subTotalPrice.isHidden = true
                            self.proccess_btn.isHidden = true
                            self.priceLabel.isHidden = true
                            self.noData.isHidden = false
                            self.noData.contentMode = .scaleAspectFit
                            self.noData.loopMode = .loop
                            self.noData.play()
                        }
                    }
                }
            }
        
        
    }
    private func undoDeleting(index: Int){
        if let lineItem = deletedLineItem {
            cartArray?.insert(lineItem, at: index)
            cardTableView.reloadData()
            self.increaseCounter()
        }
    }
    
    func putDraftOrder(lineItems : [LineItem]){
        var draftOrder = DrafOrder()
             draftOrder.email = UserDefaultsManager.sharedInstance.getUserEmail()
              draftOrder.lineItems = lineItems
              var shoppingCart = Drafts()
              shoppingCart.draftOrder = draftOrder
             shoppingCartVM.putNewCart(userCart: shoppingCart) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    print ("delete cart Error \n \(error?.localizedDescription ?? "")" )
                }
                return
            }
            
            guard response?.statusCode ?? 0 >= 200 && response?.statusCode ?? 0 < 300   else {
                DispatchQueue.main.async {
                    print ("delete cart Response \n \(response ?? HTTPURLResponse())" )
                }
                return
            }
            self.increaseCounter()
            self.setSubTotal()
                 ShoppingCardViewController.subTotalPrice = UserDefaultsManager.sharedInstance.getTotalPrice()
            print("lineItem was added successfully")
                 
        }
    }
    func deleteCart(){
        shoppingCartVM.deleteCart { error in
            if error != nil {
                UserDefaultsManager.sharedInstance.setUserCart(cartId: nil)
                UserDefaultsManager.sharedInstance.setCartState(cartState:false)
                self.increaseCounter()
                self.subTotalPrice.text = "0"
           
                
            }
            else
            {
                print(error?.localizedDescription ?? "")
            }
        }
    }
}









//extension ShoppingCardViewController: UITableViewDataSource {
//
//
//
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cartArray?.count ?? 1
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell  = tableView.dequeueReusableCell(withIdentifier: "shoppingCardCell", for: indexPath) as! ShoppingCardTableViewCell
//        cell.name.text = cartArray?[indexPath.row].title
//        if UserDefaults.standard.string(forKey: "Currency")  == "EGP" {
//            let price = (Double(cartArray?[indexPath.row].price ?? "0") ?? 0.0)  * 30
//            let priceString = "\(price.formatted()) EGP"
//            cell.priceButton.text = priceString
//        }
//        else
//        {
//            let priceString = "\(cartArray?[indexPath.row].price ?? "0") $"
//            cell.priceButton.text = priceString
//        }
//
//
//        let image = URL(string: cartArray?[indexPath.row].sku ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
//        cell.img.sd_setImage(with:image)
//        cell.counterProtocol = self
//       cell.indexPath = indexPath
//        cell.lineItem = cartArray
//        cell.quantityLabel.text = "1"
//        cell.disableDecreaseBtn()
//
//     //   self.setSubTotal()
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//                deleteLineItemProduct(indexPath: indexPath)
//            }
//        }
//
//
//}
//
//extension ShoppingCardViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
//
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////
////        let vc = UIStoryboard(name: "ProductDetailsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "productDetails") as! ProductDetailsViewController
////        vc.product_ID = cartArray?[indexPath.row].product_id
////        self.navigationController?.pushViewController(vc, animated: true)
////        //self.navigationController?.pushViewController(vc, animated: true)
////    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//
//
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 5
//    }
//
//    func showAlert(msg: String ) {
//        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "close", style: .cancel))
//        self.present(alert, animated: true, completion: nil)
//    }
//}
//
//extension ShoppingCardViewController {
//    func deleteLineItemProduct(indexPath : IndexPath)
//    {
//
//        deletedLineItem = cartArray?[indexPath.row]
//        cartArray?.remove(at: indexPath.row)
//        cardTableView.deleteRows(at: [indexPath], with: .automatic)
//
//        DispatchQueue.main.asyncAfter(deadline: .now()+3.5){
//            if self.flag == true {
//                if !(self.cartArray?.count == 0){
//                    self.putDraftOrder(lineItems: self.cartArray ?? [])
//                }
//                else
//                {
//                    self.deleteCart()
//                }
//            }
//        }
//
//    }
//    private func undoDeleting(index: Int){
//        if let lineItem = deletedLineItem {
//            cartArray?.insert(lineItem, at: index)
//            cardTableView.reloadData()
//            self.increaseCounter()
//        }
//    }
//
//    func putDraftOrder(lineItems : [LineItems]){
//        var draftOrder = DrafOrders()
//        draftOrder.email = UserDefaultsManager.sharedInstance.getUserEmail()
//        draftOrder.line_items = lineItems
//        var shoppingCart = Draftss()
//        shoppingCart.draft_order = draftOrder
//        shoppingCartVM.putNewCart(userCart: shoppingCart) { data, response, error in
//            guard error == nil else {
//                DispatchQueue.main.async {
//                    print ("delete cart Error \n \(error?.localizedDescription ?? "")" )
//                }
//                return
//            }
//
//            guard response?.statusCode ?? 0 >= 200 && response?.statusCode ?? 0 < 300   else {
//                DispatchQueue.main.async {
//                    print ("delete cart Response \n \(response ?? HTTPURLResponse())" )
//                }
//                return
//            }
//            self.increaseCounter()
//            print("lineItem was added successfully")
//        }
//    }
//    func deleteCart(){
//        shoppingCartVM.deleteCart { error in
//            if error != nil {
//                UserDefaultsManager.sharedInstance.setUserCart(cartId: nil)
//                UserDefaultsManager.sharedInstance.setCartState(cartState:false)
//                self.increaseCounter()
//                self.subTotalPrice.text = "0"
//
//            }
//            else
//            {
//                print(error?.localizedDescription ?? "")
//            }
//        }
//    }
//}
//
//extension ShoppingCardViewController: CounterProtocol {
//
//    func setItemQuantityToPut(quantity: Int, index: Int) {
//        self.cartArray?[index].quantity = quantity
//    }
//
//    func increaseCounter() {
//        Self.subTotalPrice = 0.0
//        for index in  0...(cartArray?.count ?? 0) - 1
//        {
//            let itemPrice = (Double(cartArray?[index].price ?? "") ?? 0.0) * (Double (cartArray?[index].quantity ?? 0))
//            ShoppingCardViewController.subTotalPrice = Self.subTotalPrice + itemPrice
//        }
//        print("subtotal :\(Self.subTotalPrice)")
//      //  setSubTotal()
//    }
//
//    func decreaseCounter(price: String) {
//
//
//        let itemPrice = Double(price) ?? 0.0
//            Self.subTotalPrice = Self.subTotalPrice - itemPrice
//
//        print("subtotal :\(Self.subTotalPrice)")
//        //setSubTotal()
//    }
//
//
//}
