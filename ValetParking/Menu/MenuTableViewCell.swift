//
//  MenuTableViewCell.swift
//  ValetParking
//
//  Created by Zafar Najmi on 15/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var MenuItemImage: UIImageView!
    @IBOutlet weak var MenuItemName: UILabel!
    @IBOutlet var outerBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
