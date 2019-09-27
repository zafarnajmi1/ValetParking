//
//  AgentsDataCell.swift
//  ValetParking
//
//  Created by Zafar Najmi on 17/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class AgentsDataCell: UICollectionViewCell {
    
   
    @IBOutlet var GreenDot: UIImageView!
    @IBOutlet weak var AgentImage: UIImageView!
    @IBOutlet weak var AgentName: UILabel!
    
    
    
    
//    override var bounds: CGRect {
//        didSet {
//            self.layoutIfNeeded()
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //self.setCircularImageView()
    }
    
    func setCircularImageView() {
        //self.AgentImage.layer.cornerRadius =  100 //CGFloat(roundf(Float(self.AgentImage.frame.size.width / 20.0)))
        
    }
}
