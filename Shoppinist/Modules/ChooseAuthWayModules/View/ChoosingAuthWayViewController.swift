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

    }

    @IBAction func enterAsGuest(_ sender: Any) {
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
