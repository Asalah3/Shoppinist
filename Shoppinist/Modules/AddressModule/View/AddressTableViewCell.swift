//
//  AddressTableViewCell.swift
//  Shoppinist
//
//  Created by Esraa AbdElfatah on 03/06/2023.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
