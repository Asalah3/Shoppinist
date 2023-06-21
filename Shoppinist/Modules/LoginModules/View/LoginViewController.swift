//
//  LoginViewController.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 02/06/2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    var loginViewModel: LoginViewModel?
    let loginSuccess = "Login Success"
    let invalidMail = "Invalid Mail"
    let wrongPass = "Wrong Password"
    
    var AllDraftsUrl = "https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/draft_orders.json"
    var cartcount = AllDrafts()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginViewModel = LoginViewModel()
        
        loginEmail.setupLeftSideImage(imageViewName: "envelope")
        loginPassword.setupLeftSideImage(imageViewName: "key")
        loginPassword.setupRightSideImage(imageViewOpened: "eye.slash")
        
        Utilites.setUpTextFeildStyle(textField: loginEmail)
        Utilites.setUpTextFeildStyle(textField: loginPassword)
    }

    @IBAction func loginCustomer(_ sender: Any) {

        loginViewModel?.getAllCustomers()
        loginViewModel?.bindingLogin = { [weak self] in
            DispatchQueue.main.async {
                
                if self?.loginViewModel?.checkCustomerAuth(customerEmail: self?.loginEmail.text ?? "", customerPasssword: self?.loginPassword.text ?? "") == "Login Success" {
                    self?.loginToFireBase(email: self?.loginEmail.text ?? "", password: self?.loginPassword.text ?? "")
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

extension LoginViewController{
    func loginToFireBase(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password, completion:{[weak self] result, error in
            guard let strongSelf = self else{
                return
            }
            guard error == nil else{
                
                
                return
            }
            strongSelf.checkVerification()

        })
    }
    
    func checkVerification(){
        if let user = Auth.auth().currentUser {
            if user.isEmailVerified {
                // User's email is verified, allow them to enter the app
                let tabBar = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
                tabBar?.modalTransitionStyle = .crossDissolve
                tabBar?.modalPresentationStyle = .fullScreen
                self.present(tabBar!, animated: true)
                print("User's email is verified")
            } else {
                // User's email is not verified, show an error message
                UserDefaults.standard.set(0, forKey: "customerID")
                let confirmAction = UIAlertAction(title: "OK", style: .default)
                Utilites.displayAlert(title: "⚠️ Your email is not verified", message: "click link sent to your mail and relogin!!", action: confirmAction, controller: self)
                print("User's email is not verified")
            }
        }
    }
    

}
