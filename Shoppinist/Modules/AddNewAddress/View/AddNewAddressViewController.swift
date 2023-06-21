//
//  AddNewAddressViewController.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 03/06/2023.
//

import UIKit

class AddNewAddressViewController: UIViewController {
    var streetName, cityName, country:String?
    var isEdit = false
    var addressID: Int!
    var phone: String!
    var statusCode : Int?
    @IBOutlet weak var countryListButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    var ViewModel : AddAddressviewModel?
    var newAddress : Address?
    
    override func viewWillAppear(_ animated: Bool) {
        textfieldsStyles()
        setPopupButton()
        fillTextFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewModel = AddAddressviewModel()
        newAddress = Address()
        
        
    }
    
    func fillTextFields() {
        if isEdit{
            phoneTextField.text = (phone ?? ""  )
            addressTextField.text = (streetName ?? "")
            cityTextField.text = (cityName ?? "")
            countryTextField.text = (country ?? "")
        }
    }
    
    func setPopupButton(){
        let optionClosure = { [self](action: UIAction) in
            print(action.title)
            countryTextField.text = action.title
        }
        
            self.countryListButton.menu = UIMenu(children : [

                UIAction(title: "choose Country",state: .on , handler: optionClosure),
                UIAction(title: "Afghanistan", handler: optionClosure),
                UIAction(title: "Argentina",handler: optionClosure),
                UIAction(title: "Armenia", handler: optionClosure),
                UIAction(title: "Australia", handler: optionClosure),
                UIAction(title: "Austria", handler: optionClosure),
                UIAction(title: "Azerbaijan", handler: optionClosure),
                
                UIAction(title: "Bahamas", handler: optionClosure),
                UIAction(title: "Bahrain",handler: optionClosure),
                UIAction(title: "Bangladesh",handler: optionClosure),
                UIAction(title: "Barbados", handler: optionClosure),
                UIAction(title: "Belarus", handler: optionClosure),
                UIAction(title: "Brazil", handler: optionClosure),
                
                UIAction(title: "Canada", handler: optionClosure),
                UIAction(title: "China", handler: optionClosure),
                UIAction(title: "Cuba",handler: optionClosure),
                
                UIAction(title: "Denmark", handler: optionClosure),
                UIAction(title: "Djibouti", handler: optionClosure),
                UIAction(title: "Dominica",handler: optionClosure),
                
                UIAction(title: "Egypt",handler: optionClosure),
                UIAction(title: "Estonia", handler: optionClosure),
                UIAction(title: "Ecuador", handler: optionClosure),
                
                UIAction(title: "Fiji",handler: optionClosure),
                UIAction(title: "Finland", handler: optionClosure),
                UIAction(title: "France", handler: optionClosure),
               
                
            
            ])
        
        countryListButton.showsMenuAsPrimaryAction = true
        countryListButton.changesSelectionAsPrimaryAction = true

        }
    
    func checkData() {
        let titleMessage = "Missing Data"
        if countryTextField.text == "" {
            showAlertError(title: titleMessage, message: "Please enter your country name")
        }
        
        if cityTextField.text == "" {
            showAlertError(title: titleMessage, message: "Please enter your city name")
        }
        
        if addressTextField.text == "" {
            showAlertError(title: titleMessage, message: "Please enter your address")
        }
        
        if phoneTextField.text == "" {
            showAlertError(title: titleMessage, message: "Please enter you phone number")
            
        } else {
            let check: Bool = validate(value: phoneTextField.text!)
            if check == false {
                self.showAlertError(title: "invalid data!", message: "please enter you phone number in correct format")
            }
        }
        
    }
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{11}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: value)
        print("RESULT \(result)")
        return result
    }
    
    func showAlertError(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDone(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showEdit(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addNewAddressButton(_ sender: Any) {
        
        checkData()
        let id = UserDefaults.standard.integer(forKey:"customerID")
        if isEdit {
            if addressTextField.text != "" && cityTextField.text != "" && countryTextField.text != "" && phoneTextField.text != "" && validate(value: phoneTextField.text!){
                let params : [String: Any] = ["address" :["id": addressID ?? 0, "address1" :addressTextField.text ?? 0, "country" : countryTextField.text ?? 0, "phone" : phoneTextField.text ?? "" , "city": cityTextField.text ?? ""]]
                AddressNetworkServices.editAddress(customerId: id, addressID: addressID, address: params) { [weak self] code in
                    self?.statusCode = code
                    if self?.statusCode == 200{
                    }else{
                        print(self?.statusCode?.description ?? "")
                    }
                }
                
                self.showEdit(title: "Congrats", message: "You edit the address")
            }
        } else {
            
            if addressTextField.text != "" && cityTextField.text != "" && countryTextField.text != "" && phoneTextField.text != ""  && validate(value: phoneTextField.text!){
                newAddress?.country = countryTextField.text
                newAddress?.address1 = addressTextField.text
                newAddress?.phone = phoneTextField.text
                newAddress?.city = cityTextField.text
                guard let address = newAddress else { return }
                ViewModel?.CreateAddress(createAddress : address)
                self.showDone(title: "Congrats", message: "You added a new address")
            }
        }
    }
    
    func textfieldsStyles(){
     
        Utilites.setUpTextFeildStyle(textField: phoneTextField)
        Utilites.setUpTextFeildStyle(textField: addressTextField)
        Utilites.setUpTextFeildStyle(textField: cityTextField)
        Utilites.setUpTextFeildStyle(textField: countryTextField)
    }

}
