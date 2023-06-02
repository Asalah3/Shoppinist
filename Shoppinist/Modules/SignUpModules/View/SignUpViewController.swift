//
//  SignUpViewController.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 02/06/2023.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var signImage: UIImageView!
    @IBOutlet weak var signFirstName: UITextField!
    @IBOutlet weak var signLastName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signPassword: UITextField!
    @IBOutlet weak var signConfirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signFirstName.setupLeftSideImage(imageViewName: "person")
        signLastName.setupLeftSideImage(imageViewName: "person")
        signEmail.setupLeftSideImage(imageViewName: "envelope")
        signPassword.setupLeftSideImage(imageViewName: "key")
        signConfirmPassword.setupLeftSideImage(imageViewName: "key")
        signPassword.setupRightSideImage(imageViewOpened: "eye")
        signConfirmPassword.setupRightSideImage(imageViewOpened: "eye")

    }

    @IBAction func signUpCustomer(_ sender: Any) {
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
        self.tintColor = .lightGray
    }
    
    func setupRightSideImage(imageViewOpened: String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(systemName: imageViewOpened)
        let imageViewContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageViewContainerView.addSubview(imageView)
        rightView = imageViewContainerView
        rightViewMode = .always
        self.tintColor = .lightGray
        
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
