//
//  AddressViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 03/06/2023.
//

import UIKit

class AddressViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressTableViewCell
        cell.countryLabel.text = "Egypt"
        cell.phoneLabel.text = "01094406437"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    


    @IBAction func addNewaddress(_ sender: Any) {
        let AddNewAddress = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddress") as! AddNewAddressViewController
        
        navigationController?.pushViewController(AddNewAddress, animated: true)
        
        
    }
}
