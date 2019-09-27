//
//  AgentsListingTableViewCell.swift
//  ValetParking
//
//  Created by My Technology on 10/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class AgentsListingTableViewCell: UITableViewCell {

    @IBOutlet var agentsListingView: UIView!
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        agentsListingView.setBorderWidth(width: 0.5)
        agentsListingView.setBorderColor(color:Colors.lightGrey)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
