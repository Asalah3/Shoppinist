//
//  FavTableViewCell.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 10/06/2023.
//

import UIKit

class FavTableViewCell: UITableViewCell {

    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var backView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
