//
//  PopUp2View.swift
//  ValetParking
//
//  Created by macbook on 22/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class Popup2View: UIView {
    
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
