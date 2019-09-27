//
//  ActiveAgentsCell.swift
//  ValetParking
//
//  Created by Zafar Najmi on 17/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class ActiveAgentsCell: UITableViewCell {

    
    @IBOutlet weak var CLView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
     CLView.showsHorizontalScrollIndicator  = false
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.setsubViewDesign()
//
//
//    }
//
//    func setsubViewDesign()
//    {
//     self.layer.cornerRadius = 8
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension ActiveAgentsCell
{
//    func setCollectionViewDelegateDatasource
//        <D : UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate : D , forRow row : Int)
//    {
//        CLView.delegate = dataSourceDelegate
//        CLView.dataSource = dataSourceDelegate
//        CLView.reloadData()
//
//    }

}
