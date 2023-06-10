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
    
    var loginViewModel: LoginViewModel?
    let loginSuccess = "Login Success"
    let invalidMail = "Invalid Mail"
    let wrongPass = "Wrong Password"
    
    var cartVM = ShoppingCartViewModel()
    var AllDraftsUrl = "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/draft_orders.json"
    var cartcount = AllDraftss()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginViewModel = LoginViewModel()
        
        loginEmail.setupLeftSideImage(imageViewName: "envelope")
        loginPassword.setupLeftSideImage(imageViewName: "key")
        loginPassword.setupRightSideImage(imageViewOpened: "eye.slash")
        
        Utilites.setUpTextFeildStyle(textField: loginEmail)
        Utilites.setUpTextFeildStyle(textField: loginPassword)
        
        cartVM.cartsUrl = self.AllDraftsUrl
        cartVM.getAllDrafts()
        cartVM.bindingCartt = {()in
            self.renderCart()
            
        }
    
    }

    @IBAction func loginCustomer(_ sender: Any) {

        loginViewModel?.getAllCustomers()
        loginViewModel?.bindingLogin = { [weak self] in
            DispatchQueue.main.async {
                
                if self?.loginViewModel?.checkCustomerAuth(customerEmail: self?.loginEmail.text ?? "", customerPasssword: self?.loginPassword.text ?? "") == "Login Success" {
                    
                    let tabBar = self?.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
                    tabBar?.modalTransitionStyle = .crossDissolve
                    tabBar?.modalPresentationStyle = .fullScreen
                    self?.present(tabBar!, animated: true)
                    
                                        
                }
                else if self?.loginViewModel?.checkCustomerAuth(customerEmail: self?.loginEmail.text ?? "", customerPasssword: self?.loginPassword.text ?? "") == "Uncorrect Email or Password"{
                    Utilites.displayToast(message: "Uncorrect Email or Password" , seconds: 2.0, controller: self ?? UIViewController())
                }
                else{
                    Utilites.displayToast(message: "Enter Full data" , seconds: 2.0, controller: self ?? UIViewController())
                }
                
            }
        }
        
        
    }
    
    
    
    @IBAction func navigateToSignUp(_ sender: Any) {
        let signViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(signViewController, animated: true)
    }
}


extension LoginViewController {
    func renderCart() {
        DispatchQueue.main.async {
            self.cartcount = self.cartVM.cartResult!
        }
  
    }
    
}
