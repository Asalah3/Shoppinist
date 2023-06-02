//
//  SettingViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 01/06/2023.
//

import UIKit

class SettingViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
  
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
    
   

}
