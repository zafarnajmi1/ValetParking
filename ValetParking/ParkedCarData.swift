//
//  ParkedCarData.swift
//  ValetParking
//
//  Created by Zafar Najmi on 12/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class ParkedCarData: UITableViewCell {

    
    @IBOutlet weak var UserDataField: UILabel!
    
    @IBOutlet weak var FormDataField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func FormFieldEdit(_ sender: Any) {
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
