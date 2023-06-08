//
//  SelectAddressViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 08/06/2023.
//

import UIKit

class SelectAddressViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    
    @IBOutlet weak var selectTableView: UITableView!
    var addressViewModel : AddressViewModel?
    var customerAddressTable : CustomerAddress?
    var statusCode : Int?
    
    @IBOutlet weak var pageAddressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    override func viewWillAppear(_ animated: Bool) {
        checkCartIsEmpty()
        addressViewModel = AddressViewModel()
        addressViewModel?.getAddress()
        addressViewModel?.bindingGet = { [weak self] in
            DispatchQueue.main.async {
                self?.customerAddressTable = self?.addressViewModel?.ObservableGet
                     self?.selectTableView.reloadData()
            }
        }
    }
    func checkCartIsEmpty() {
     if customerAddressTable?.addresses?.count == 0{
        // tableView.isHidden = true
         pageAddressLabel.text = "ADD Your Address"
         
     } else {
   //  tableView.isHidden = false
         pageAddressLabel.text = "Select Address"
     }
 }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerAddressTable?.addresses?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectAddress", for: indexPath)as! SelectAddressTableViewCell
        cell.titleLabel.text = customerAddressTable?.addresses![indexPath.row].address1
        cell.subTitle.text = customerAddressTable?.addresses![indexPath.row].phone
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
        let payementVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        
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
        
        
        self.navigationController?.pushViewController(payementVC, animated: true)
    
    }
    

    @IBAction func addNewAddressButton(_ sender: Any) {
        
        let addresVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddress") as! AddNewAddressViewController
    
        self.navigationController?.pushViewController(addresVC, animated: true)
    }
    

}