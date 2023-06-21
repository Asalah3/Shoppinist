//
//  SelectAddressViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 08/06/2023.
//

import UIKit
import Lottie

class SelectAddressViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    
    @IBOutlet weak var noData: AnimationView!
    @IBOutlet weak var selectTableView: UITableView!
    var addressViewModel : AddressViewModel?
    var customerAddressTable : CustomerAddress?
    var statusCode : Int?
    var price:Int = 0
    @IBOutlet weak var pageAddressLabel: UILabel!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
                activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
        addressViewModel = AddressViewModel()
        addressViewModel?.getAddress()
        addressViewModel?.bindingGet = { [weak self] in
            DispatchQueue.main.async {
                self?.customerAddressTable = self?.addressViewModel?.ObservableGet
                     self?.selectTableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
        checkCartIsEmpty()
    }
    func checkCartIsEmpty() {
     if customerAddressTable?.addresses?.count == 0{
         self.activityIndicator.stopAnimating()
         selectTableView.isHidden = true
         pageAddressLabel.text = "ADD Your Address"
         self.noData.isHidden = false
         self.noData.contentMode = .scaleAspectFit
         self.noData.loopMode = .loop
         self.noData.play()
         
     } else {
      selectTableView.isHidden = false
         pageAddressLabel.text = "Select Address"
         self.noData.isHidden = true
     }
 }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerAddressTable?.addresses?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectAddress", for: indexPath) as! SelectAddressTableViewCell
//      
//        cell.imageView?.image=UIImage(systemName: "homekit")
//        cell.imageView?.tintColor = .systemPurple
//        cell.textLabel?.text = "\(customerAddressTable?.addresses![indexPath.row].address1 ?? "") , \(customerAddressTable?.addresses![indexPath.row].city ?? "") , \(customerAddressTable?.addresses![indexPath.row].country ?? "") "
//       
//        cell.accessoryType = .disclosureIndicator
        
        cell.countryLabel.text = "\(customerAddressTable?.addresses![indexPath.row].address1 ?? "") , \(customerAddressTable?.addresses![indexPath.row].city ?? "") , \(customerAddressTable?.addresses![indexPath.row].country ?? "") "
        
        cell.phoneLabel.text = customerAddressTable?.addresses![indexPath.row].phone
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)

        let orderVc = self.storyboard?.instantiateViewController(withIdentifier: "OrderModuleViewController") as? OrderModuleViewController
       
        
        UserDefaults.standard.set(customerAddressTable?.addresses![indexPath.row].address1, forKey: "address")

        AddressNetworkServices.updateAddress(customer_id: UserDefaults.standard.integer(forKey:"customerID")
                                 , address_id: customerAddressTable?.addresses?[indexPath.row].id ?? 0
                                 , address: customerAddressTable?.addresses?[indexPath.row].address1 ?? "") { [weak self] code in
            self?.statusCode = code
            print(self?.statusCode ?? 0)
            if self?.statusCode == 200 {
                print("updated successfully")
            }else{
                print(self?.statusCode?.description ?? "")
            }
        }
        
        orderVc?.shippingAddress = customerAddressTable?.addresses?[indexPath.row]
        self.navigationController?.pushViewController(orderVc ?? OrderModuleViewController(), animated: true)
    
    }
    

    @IBAction func addNewAddressButton(_ sender: Any) {
        
        let addresVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddress") as! AddNewAddressViewController
    
        self.navigationController?.pushViewController(addresVC, animated: true)
    }
    

}
