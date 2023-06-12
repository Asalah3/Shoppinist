//
//  ChoosingAuthWayViewController.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 02/06/2023.
//

import UIKit

class ChoosingAuthWayViewController: UIViewController {

    @IBOutlet weak var choosingAuthImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    @IBAction func enterAsGuest(_ sender: Any) {
        
        UserDefaults.standard.set("Guest", forKey: "customerFirsttName")
        UserDefaults.standard.set("", forKey: "customerEmail")
        UserDefaults.standard.set(0, forKey: "customerID")
        let tabBar = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
        tabBar?.modalTransitionStyle = .crossDissolve
        tabBar?.modalPresentationStyle = .fullScreen
        self.present(tabBar!, animated: true)
    }
    
    @IBAction func navigateToSignUp(_ sender: Any) {
        let signViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(signViewController, animated: true)
    }
   
    
    @IBAction func navigateToLogin(_ sender: Any) {
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(loginViewController, animated: true)
    }

}
