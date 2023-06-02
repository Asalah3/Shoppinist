//
//  SettingViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 01/06/2023.
//

import UIKit
import Reachability

class SettingViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    let appDelegate = UIApplication.shared.windows.first
    var SettingsArr = ["Address" , "Currency" , "About Us" , "Contact Us" , "Logout"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.imageView?.image=UIImage(systemName: "homekit")
            cell.imageView?.tintColor = .label
            cell.textLabel?.text=SettingsArr[indexPath.row]
            cell.accessoryType = .disclosureIndicator
        case 1:
            cell.imageView?.image=UIImage(systemName: "dollarsign")
            cell.textLabel?.text=SettingsArr[indexPath.row]
            cell.imageView?.tintColor = .label
            cell.accessoryType = .disclosureIndicator
        case 2:
            cell.imageView?.image=UIImage(systemName: "info")
            cell.textLabel?.text=SettingsArr[indexPath.row]
            cell.imageView?.tintColor = .label
            cell.accessoryType = .disclosureIndicator
        case 3:
            cell.imageView?.image=UIImage(systemName: "contact.sensor")
            cell.textLabel?.text=SettingsArr[indexPath.row]
            cell.imageView?.tintColor = .label
            cell.accessoryType = .disclosureIndicator
        case 4:
            cell.imageView?.image=UIImage(systemName: "lock")
            cell.textLabel?.text=SettingsArr[indexPath.row]
            cell.imageView?.tintColor = .label
            cell.accessoryType = .disclosureIndicator
            
        default:
            break
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row){
        case 1 :
             let alert = UIAlertController(title: "Currency", message: "Choose the currency", preferredStyle: .alert)
             
             
             alert.addAction(UIAlertAction(title: "EGP", style: .default ,handler: {  [weak self ] _ in
                 UserDefaults.standard.set("EGP", forKey: "Currency")
             }))
            alert.addAction(UIAlertAction(title: "USD", style: .cancel ,handler: {  [weak self] _ in
                UserDefaults.standard.set("USD", forKey: "Currency")
            }))
             
             present(alert, animated: true)
        case 2:
            let contactVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
            self.present(contactVC, animated: true)
            
        case 3 :
            let contactVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            self.present(contactVC, animated: true)
            
        default:
            break
        }
        print(UserDefaults.standard.string(forKey: "Currency"))
    }
   

}
