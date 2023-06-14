//
//  MeViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 01/06/2023.
//

import UIKit
import NVActivityIndicatorView
class MeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

}
