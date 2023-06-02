//
//  ContactUsViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 01/06/2023.
//

import UIKit

class ContactUsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsCell", for: indexPath) as! ContactUsTableViewCell
        switch indexPath.row {
        case 0:
            cell.emailLabel.text = "esraa4255@gmail.com"
            cell.contactimage.image = UIImage(named:"Esraa")
            cell.accessoryType = .disclosureIndicator
        case 1:
            cell.emailLabel.text = "asalahsayed3@gmail.com"
            cell.contactimage.image = UIImage(named:"Asalah")
            cell.accessoryType = .disclosureIndicator
            cell.accessoryType = .disclosureIndicator
            
        case 2:

            cell.emailLabel.text = "soha7hmed@gmail.com"
            cell.contactimage.image = UIImage(named:"Soha")
            cell.accessoryType = .disclosureIndicator
            cell.accessoryType = .disclosureIndicator
            
        default:
            break
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
