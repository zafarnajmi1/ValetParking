//
//  PopupView.swift
//  ValetParking
//
//  Created by My Technology on 11/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class PopupView: UIView {
    
    //MARK: Outlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var positiveBtn: UIButton!
    @IBOutlet weak var negativeBtn: UIButton!
   
    @IBOutlet var headerView: UIView!
    override func layoutSubviews() {
        
        positiveBtn.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        negativeBtn.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        headerView.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
    }
}


