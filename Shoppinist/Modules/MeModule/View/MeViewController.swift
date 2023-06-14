//
//  MeViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 01/06/2023.
//

import UIKit
import NVActivityIndicatorView
import BadgeSwift
class MeViewController: UIViewController {
    
    private var cartArray: [LineItem]?
    private var shoppingCartVM = ShoppingCartViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getData(){
        shoppingCartVM.getShoppingCart()
        shoppingCartVM.bindingCart = {
            self.renderView()
            
        }
    }
    func renderView(){
        DispatchQueue.main.async {
            
            self.cartArray = self.shoppingCartVM.cartList
          
           
            }
   
    }

    //ShoppingCard
    @IBAction func shoppingButton(_ sender: Any) {
        let cart = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingCard") as! ShoppingCardViewController
        
        navigationController?.pushViewController(cart, animated: true)
        
    }
    @IBAction func settingButton(_ sender: Any) {
        let setting = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        
        navigationController?.pushViewController(setting, animated: true)
    }
    
    override func viewWillAppear( _ animated: Bool){
        getData()
        let rightBarButton = self.navigationItem.rightBarButtonItem

        
        rightBarButton?.addBadge(text: "3" , withOffset: CGPoint(x: -100, y: 0))
      
    }
  
}
