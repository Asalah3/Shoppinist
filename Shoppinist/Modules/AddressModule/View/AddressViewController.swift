//
//  AddressViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 03/06/2023.
//

import UIKit

class AddressViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var addressTableView: UITableView!
    var customerAddressTable : CustomerAddress?
    var addressViewModel : AddressViewModel?
    var statusCode : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        addressViewModel = AddressViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addressViewModel?.getAddress()
        addressViewModel?.bindingGet = { [weak self] in
            DispatchQueue.main.async {
                self!.customerAddressTable = self!.addressViewModel?.ObservableGet
                self!.addressTableView.reloadData()
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerAddressTable?.addresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressTableViewCell
        cell.countryLabel.text = customerAddressTable?.addresses![indexPath.row].country ?? ""
        cell.phoneLabel.text = customerAddressTable?.addresses![indexPath.row].phone
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { action, _, handler in
            let alert = UIAlertController(title: "Delete", message: "Are you sure about deletion ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default , handler: { [self] action in
                addressViewModel?.deleteAddress(AddressId: customerAddressTable?.addresses?[indexPath.row].id ?? 0
                                        , CustomerId:  UserDefaults.standard.integer(forKey:"customerID"))
                addressViewModel?.bindingStatusCode = { [weak self] code in
                    self?.statusCode = code
                    if self?.statusCode == 200{
                        print("delete successfully")
                    }else{
                        print(self?.statusCode?.description ?? "")
                    }
                }

                self.customerAddressTable?.addresses?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel ))
            self.present(alert, animated: true)
        }
        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] action, _, handler in
            guard let self = self else {return}
            self.editAddress(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    
    func editAddress(indexPath:IndexPath) {
        let addressVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddress") as! AddNewAddressViewController
        addressVC.isEdit = true
        addressVC.phone = customerAddressTable?.addresses?[indexPath.row].phone
        addressVC.streetName = customerAddressTable?.addresses?[indexPath.row].address1
        addressVC.cityName = customerAddressTable?.addresses?[indexPath.row].city
        addressVC.country = customerAddressTable?.addresses?[indexPath.row].country
        addressVC.addressID = customerAddressTable?.addresses?[indexPath.row].id
        navigationController?.pushViewController(addressVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }


    @IBAction func addNewaddress(_ sender: Any) {
        let AddNewAddress = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddress") as! AddNewAddressViewController
        
        navigationController?.pushViewController(AddNewAddress, animated: true)
        
        
    }
    
}
