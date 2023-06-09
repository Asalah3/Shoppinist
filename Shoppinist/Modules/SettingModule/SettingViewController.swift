//
//  SettingViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 01/06/2023.
//

import UIKit
import Reachability

class SettingViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var modeLabel: UILabel!
    let reachability = try! Reachability()
    weak var delegate : MyCustomCellDelegate?
    let appDelegate = UIApplication.shared.windows.first
    
    var SettingsArr = ["Address" , "Currency" , "About Us" , "Contact Us" , "Logout"]
    
    @objc func reachabilityChanged(note: Notification){
        let reachability = note.object as! Reachability
    }
    override func viewWillAppear( _ animated: Bool){
       
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.stopNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
        
        if UserDefaults.standard.bool(forKey: "Dark"){
            modeSwitch.isOn = true
            appDelegate?.overrideUserInterfaceStyle = .dark

        }
        else{
            modeSwitch.isOn = false
            appDelegate?.overrideUserInterfaceStyle = .light

        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 16)
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
            if UserDefaults.standard.integer(forKey:"customerID") != 0{
                
                cell.textLabel?.text=SettingsArr[indexPath.row]
            }else{
                cell.textLabel?.text = "SignUp"
            }
            cell.imageView?.tintColor = .label
            cell.accessoryType = .disclosureIndicator
            
        default:
            break
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch reachability.connection {
    case .wifi , .cellular:
        switch (indexPath.row){
        case 0:
            if UserDefaults.standard.integer(forKey:"customerID") != 0{
                let addressVC = self.storyboard?.instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
                navigationController?.pushViewController(addressVC, animated: true)
            }else{
                let confirmAction = UIAlertAction(title: "Sign up", style: .default){ action  in
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                }
                                Utilites.displayAlert(title: "You must Sign up", message: "You must Sign up?", action: confirmAction, controller: self )
            }
        case 1 :
             let alert = UIAlertController(title: "Currency", message: "Choose the currency", preferredStyle: .alert)
             
             
             alert.addAction(UIAlertAction(title: "EGP", style: .default ,handler: { _ in
                 UserDefaults.standard.set("EGP", forKey: "Currency")
             }))
            alert.addAction(UIAlertAction(title: "USD", style: .cancel ,handler: { _ in
                UserDefaults.standard.set("USD", forKey: "Currency")
            }))
             
             present(alert, animated: true)
        case 2:
            let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
            self.present(aboutVC, animated: true)
            
        case 3 :
            let contactVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            self.present(contactVC, animated: true)
        case 4:
            UserDefaultsManager.sharedInstance.clearUserDefaults()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")as! SignUpViewController
            viewController.flag = true
           self.navigationController?.pushViewController(viewController, animated: true)
           
            
            
//            let logOut = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
//            let navigationController = UINavigationController(rootViewController: logOut)
//            navigationController.modalPresentationStyle = .fullScreen
//            self.present(navigationController, animated: true)
            
        default:
            break
            
        }
            
        case .unavailable , .none :
                    let alert = UIAlertController(title: "No internet !" , message: "make sure of internet connection" ,preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok" , style: .default , handler: nil))
                    self.present(alert, animated: true )
                    self.tabBarController!.tabBar.isHidden = true
                    navigationController?.setNavigationBarHidden(true ,animated: false)
                }
    }
    func showAlert(title: String , message: String){
        let alert = UIAlertController(title: title ,message : message
                                      , preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .destructive)
        alert.addAction(OkAction)
        self.present(alert, animated: true)
    }

    @IBAction func modeButton(_ sender: UISwitch) {
        
        if #available(iOS 13, *){
            if sender.isOn{
                UserDefaults.standard.set(true, forKey: "Dark")
                appDelegate?.overrideUserInterfaceStyle = .dark
                modeLabel.text = "Dark Mode"
                return
            }
            else{
                UserDefaults.standard.set(false, forKey: "Dark")
                appDelegate?.overrideUserInterfaceStyle = .light
                modeLabel.text = "light Mode"
            }
            
        }else{
            print("DarkMode is unAvailable")
        }
    }
    
}

