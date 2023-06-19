//
//  ShoppingCardTableViewCell.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 04/06/2023.
//

import UIKit

protocol CartCellDelegate: AnyObject{
    func showToast(message: String)
    func startAnimating()
    func stopAnimating()
}

class ShoppingCardTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    var counter = 1
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var priceButton: UILabel!
    @IBOutlet weak var plusButton: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var increaseItem: UIButton!
    @IBOutlet weak var decreseItem: UIButton!
    
    weak var delegate : CartCellDelegate?
    var indexPath: IndexPath!
    var lineItem : LineItem!
    var cartDraft : Drafts? = Drafts()
    var myDraftOrder : DrafOrder?
    var cartVM : ShoppingCartViewModel!
    var quantityVal : Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func minusButton(_ sender: Any) {
        decreaseQuantity()
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    func setUpCell(){
        if lineItem.quantity == 1{
            decreseItem.isEnabled = false
        }else{
            decreseItem.isEnabled = true
        }
        cartVM = ShoppingCartViewModel()
        var unwrappedImage : String = ""
        priceButton.text = lineItem?.price
        let myString = lineItem?.sku ?? ""
        print("myString\(myString)")
        let myArray = myString.split(separator: ",")
        unwrappedImage = String(myArray[1])
        print("unwrappedImage\(unwrappedImage)")
        name.text = lineItem?.title
        quantityLabel.text = "\(lineItem?.quantity ?? 1)"
        img.sd_setImage(with: URL(string: unwrappedImage), placeholderImage: UIImage(named: "placeHolder"))
    }
    @IBAction func plusButton(_ sender: Any) {
        addItemToCart()
    }
    
    func addItemToCart(){
        self.delegate?.startAnimating()
        cartVM?.getAllDrafts()
        cartVM?.bindingAllDrafts = { [weak self] in
            DispatchQueue.main.async {
                
                let draft = self?.cartVM?.getMyCartDraft()
                self?.myDraftOrder = draft?[0]
                self?.cartDraft?.draftOrder = self?.myDraftOrder
                for i in 0..<(self?.cartDraft?.draftOrder?.lineItems?.count ?? 0){
                    if self?.cartDraft?.draftOrder?.lineItems?[i].sku == self?.lineItem.sku{
                        if ((self?.cartDraft?.draftOrder?.lineItems?[i].quantity ?? 0) < self?.lineItem.grams ?? 0){
                            self?.cartDraft?.draftOrder?.lineItems?[i].quantity! += 1
                            self?.quantityLabel.text = "\((self?.cartDraft?.draftOrder?.lineItems?[i].quantity!)!)"
                            self?.decreseItem.isEnabled = true
                        }else{
                            self?.delegate?.showToast(message: "Out of stock")
                            self?.increaseItem.isEnabled = false
                        }
                    }
                }
                print("cartdraft\(self?.cartDraft)")
                self?.cartVM?.updateDraft(updatedDraft: self?.cartDraft ?? Drafts())
                self?.cartVM?.bindingDraftUpdate = { [weak self] in
                    print("view createddd")
                    DispatchQueue.main.async {
                        if self?.cartVM?.ObservableDraftUpdate  == 200 || self?.cartVM?.ObservableDraftUpdate  == 201{
                            self?.delegate?.stopAnimating()
                        }else{
                            self?.delegate?.stopAnimating()
                        }
                    }
                }
                
            }
        }
    }
    
    func decreaseQuantity(){
        self.delegate?.startAnimating()
        cartVM?.getAllDrafts()
        cartVM?.bindingAllDrafts = { [weak self] in
            DispatchQueue.main.async {
                
                let draft = self?.cartVM?.getMyCartDraft()
                self?.myDraftOrder = draft?[0]
                self?.cartDraft?.draftOrder = self?.myDraftOrder
                for i in 0..<(self?.cartDraft?.draftOrder?.lineItems?.count ?? 0){
                    if self?.cartDraft?.draftOrder?.lineItems?[i].sku == self?.lineItem.sku{
                        if ((self?.cartDraft?.draftOrder?.lineItems?[i].quantity ?? 0) != 1){
                            self?.cartDraft?.draftOrder?.lineItems?[i].quantity! -= 1
                            if self?.cartDraft?.draftOrder?.lineItems?[i].quantity! == 1{
                                self?.decreseItem.isEnabled = false
                            }
                            self?.quantityLabel.text = "\((self?.cartDraft?.draftOrder?.lineItems?[i].quantity!)!)"
                        }else{
                            self?.decreseItem.isEnabled = false
                        }
                    }
                }
                print("cartdraft\(self?.cartDraft)")
                self?.cartVM?.updateDraft(updatedDraft: self?.cartDraft ?? Drafts())
                self?.cartVM?.bindingDraftUpdate = { [weak self] in
                    print("view createddd")
                    DispatchQueue.main.async {
                        if self?.cartVM?.ObservableDraftUpdate  == 200 || self?.cartVM?.ObservableDraftUpdate  == 201{
                            self?.delegate?.stopAnimating()
                        }else{
                            self?.delegate?.stopAnimating()
                        }
                    }
                }
                
            }
        }
    }
}
