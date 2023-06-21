//
//  SignUpViewController.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 02/06/2023.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var signImage: UIImageView!
    @IBOutlet weak var signFirstName: UITextField!
    @IBOutlet weak var signLastName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signPassword: UITextField!
    @IBOutlet weak var signConfirmPassword: UITextField!
    
    var signViewModel:SignViewModel?
    var newCustomer:Customer?
    var checkConfirmPassword :String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signFirstName.setupLeftSideImage(imageViewName: "person")
        signLastName.setupLeftSideImage(imageViewName: "person")
        signEmail.setupLeftSideImage(imageViewName: "envelope")
        signPassword.setupLeftSideImage(imageViewName: "key")
        signConfirmPassword.setupLeftSideImage(imageViewName: "key")
        signPassword.setupRightSideImage(imageViewOpened: "eye")
        signConfirmPassword.setupRightSideImage(imageViewOpened: "eye")
        
        Utilites.setUpTextFeildStyle(textField: signFirstName)
        Utilites.setUpTextFeildStyle(textField: signLastName)
        Utilites.setUpTextFeildStyle(textField: signEmail)
        Utilites.setUpTextFeildStyle(textField: signPassword)
        Utilites.setUpTextFeildStyle(textField: signConfirmPassword)
        
        signViewModel = SignViewModel()
        newCustomer = Customer()

    }

    @IBAction func signUpCustomer(_ sender: Any) {
        newCustomer?.first_name = signFirstName.text
        newCustomer?.last_name = signLastName.text
        newCustomer?.email = signEmail.text
        newCustomer?.note = signPassword.text
        checkConfirmPassword = signConfirmPassword.text
        
        guard let customer = newCustomer else{
            return
        }
        
        
        if signFirstName.text != "" && signLastName.text != "" && signEmail.text != "" && signPassword.text != "" && signConfirmPassword.text != "" {
            
            if newCustomer?.note == checkConfirmPassword {
               signViewModel?.insertCustomer(customer: customer)
            }
            else{
                Utilites.displayToast(message: "Confirm Password and Password must be identical", seconds: 2.0, controller: self)
            }
        }else{
            Utilites.displayToast(message: "Enter Full Data", seconds: 2.0, controller: self)
        }
        
        
        
        signViewModel?.bindingSignUp = { [weak self] in
            DispatchQueue.main.async {
                                
                if self?.signViewModel?.ObservableSignUp  == 201{
                    self?.createFirebaseAccount()
                }
                else{
                    Utilites.displayToast(message: "This email was used before", seconds: 2.0, controller: self ?? UIViewController())
                }
            }
        }
    }
    
    @IBAction func navigateToLogin(_ sender: Any) {
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
}

extension UITextField {
    func setupLeftSideImage(imageViewName: String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(systemName: imageViewName)
        let imageViewContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageViewContainerView.addSubview(imageView)
        leftView = imageViewContainerView
        leftViewMode = .always
        self.tintColor = .gray
    }
    
    func setupRightSideImage(imageViewOpened: String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(systemName: imageViewOpened)
        let imageViewContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageViewContainerView.addSubview(imageView)
        rightView = imageViewContainerView
        rightViewMode = .always
        self.tintColor = .gray
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as? UIImageView
        isSecureTextEntry.toggle()
        if isSecureTextEntry{
            tappedImage?.image = UIImage(systemName: "eye.slash")
        }else{
            tappedImage?.image = UIImage(systemName: "eye")
        }
    }
}


extension SignUpViewController{
    func createFirebaseAccount(){
        Auth.auth().createUser(withEmail: newCustomer?.email ?? "", password: newCustomer?.note ?? "", completion: {[weak self] result, error in
            
            guard let strongSelf = self else{
                return
            }
            guard error == nil else{
                return
            }
            strongSelf.sendVerificationLink()
            strongSelf.navigateToLoginFirebase()
        })
    }
    
    func navigateToLoginFirebase(){
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func sendVerificationLink(){
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification { error in
                if let error = error {
                    // Handle the error
                    print("Error sending verification email: \(error.localizedDescription)")
                } else {
                    print("Verification email sent successfully")
                }
            }
        }
    }
}
