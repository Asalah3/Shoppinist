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

class ShoppingCardViewController: UIViewController {
    @IBOutlet weak var proccess_btn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var noData: AnimationView!
    private var productsList: [LineItem]?
    var lineItem = LineItem()
    private var shoppingCartVM: ShoppingCartViewModel?
    var myDraftOrder : DrafOrder?
    var draft : Drafts? = Drafts()
    var currency = 0.0
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    @IBOutlet weak var subTotalPrice: UILabel!
    @IBOutlet weak var cardTableView: UITableView!
    override func viewDidLoad() {
        self.shoppingCartVM?.bindingCheckConnectivity = { [weak self] in
            DispatchQueue.main.async {
                if self?.shoppingCartVM?.ObservableConnection == false{
                    Utilites.displayToast(message: "you are offline", seconds: 5, controller: self ?? ShoppingCardViewController())
                }
            }
        }
    }
    @IBAction func CheckOutButton(_ sender: Any) {
    }
    override func viewWillAppear(_ animated: Bool) {
        self.shoppingCartVM?.checkNetwork()
        
        noData.isHidden = true
        productsList = [LineItem]()
        shoppingCartVM = ShoppingCartViewModel()
        if Utilites.isConnectedToNetwork() == false{
            Utilites.displayToast(message: "you are offline", seconds: 4, controller: self)
        }
        
        //------------------load favourites from API------------------------
        noData.isHidden = true
        cardTableView.showsVerticalScrollIndicator = false
        cardTableView.showsHorizontalScrollIndicator = false
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
                activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        shoppingCartVM?.getAllDrafts()
        shoppingCartVM?.bindingAllDrafts = {() in self.renderView()}
    }
    func renderView(){
        DispatchQueue.main.async {
            let draftOrders = self.shoppingCartVM?.getMyCartDraft()
            if draftOrders != nil && draftOrders?.count != 0{
                print("draft not nil")
                self.myDraftOrder = draftOrders?[0]
                self.productsList = draftOrders?[0].lineItems
                self.cardTableView.reloadData()
            }else{
                self.productsList = nil
                print("draft is nil")
            }
            self.activityIndicator.stopAnimating()
            self.checkListCount()
        }
    }
    func checkListCount(){
        if productsList?.count == 0 || productsList == nil{
            cardTableView.isHidden = true
            noData.isHidden = false
            noData.contentMode = .scaleAspectFit
            noData.loopMode = .loop
            noData.play()
        }else{
            cardTableView.isHidden = false
            noData.isHidden = true
        }
    }
}
extension ShoppingCardViewController: UITableViewDataSource ,UITableViewDelegate{
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
        return productsList?.count ?? 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "shoppingCardCell", for: indexPath) as! ShoppingCardTableViewCell
        //assign values to cell
        var unwrappedImage : String = ""
        var productID : Int = 0
        cell.priceButton.text = productsList?[indexPath.row].price
        let myString = productsList?[indexPath.row].sku ?? ""
        print("myString\(myString)")
        let myArray = myString.split(separator: ",")
        productID = Int(myArray[0]) ?? 0
        unwrappedImage = String(myArray[1])
        print("unwrappedImage\(unwrappedImage)")
        productID = Int(productsList?[indexPath.row].sku ?? "") ?? 0
        cell.name.text = productsList?[indexPath.row].title
        cell.quantityLabel.text = "\(productsList?[indexPath.row].quantity ?? 1)"
        cell.img.sd_setImage(with: URL(string: unwrappedImage), placeholderImage: UIImage(named: "placeHolder"))
        return cell
    }
    
        
}

