//
//  ContactUsTableViewCell.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 01/06/2023.
//

import UIKit

class ContactUsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBack: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactimage: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
       
        
//        self.contactimage.layer.cornerRadius = contactimage.frame.size.width/2
//        self.contactimage.layer.cornerRadius = contactimage.frame.size.height/2
//        self.contactimage.layer.borderColor = UIColor.gray.cgColor
//        self.contactimage.clipsToBounds = true
//        self.layer.shadowColor = UIColor.white.cgColor
//        self.layer.shadowRadius = 0.5
//        self.contactimage.layer.borderWidth = 2
    }

}
