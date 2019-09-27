//
//  ReleaseCar.swift
//  ValetParking
//
//  Created by Zafar Najmi on 11/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class ReleaseCar: UITableViewCell {

    
    @IBOutlet weak var CarOwner: UILabel!
    @IBOutlet weak var CarNumber: UILabel!
    
    @IBOutlet var lblViewDetail: UILabel!
    @IBOutlet var realseView: UIView!
    @IBOutlet var releaseTitle: UILabel!
    @IBOutlet var cellOuterView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
     //self.Release.clipsToBounds = true
        cellOuterView.setBorderColor(color:Colors.lightGrey)
        cellOuterView.setBorderWidth(width: 0.4)
    
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setsubViewDesign()
        
        
       // cellOuterView.setTripleGradientBackground(colorOne: Colors.BlueStart, colorTwo: Colors.BlueMiddle, colorThree: Colors.BlueLast)
    }
    
    func setsubViewDesign()
    {
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

