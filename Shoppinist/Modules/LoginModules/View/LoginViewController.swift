//
//  LoginViewController.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 02/06/2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loginEmail.setupLeftSideImage(imageViewName: "envelope")
        loginPassword.setupLeftSideImage(imageViewName: "key")
        loginPassword.setupRightSideImage(imageViewOpened: "eye.slash")

    }

    @IBAction func loginCustomer(_ sender: Any) {
//        let tabBar = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as?
//        navigationController?.pushViewController(tabBar, animated: true)
        let tabBar = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
        tabBar?.modalTransitionStyle = .crossDissolve
        tabBar?.modalPresentationStyle = .fullScreen
        self.present(tabBar!, animated: true)
    }
    
    @IBAction func navigateToSignUp(_ sender: Any) {
        let signViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(signViewController, animated: true)
    }
}
