//
//  ParkedCarCell.swift
//  ValetParking
//
//  Created by Zafar Najmi on 17/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class ParkedCarCell: UITableViewCell {

    
    @IBOutlet weak var AdminRelease: UIButton!
    
    
    
    @IBOutlet var carNumberLbl: UILabel!
    
    @IBOutlet var userNamelbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       self.AdminRelease.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setsubViewDesign()
        
        
    }
    
    func setsubViewDesign()
    {
        self.AdminRelease.layer.cornerRadius = 6
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
