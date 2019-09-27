//
//  VCDisableActiveAgent.swift
//  ValetParking
//
//  Created by My Technology on 19/03/2019.
//  Copyright © 2019 Zafar Najmi. All rights reserved.
//

import UIKit
import DropDown
protocol SearchDiableActiveAgentDelegate {
    func SearchBtnClicked(name:String?,status:String?)
    
    func didCancel()
    
    
}

class VCDisableActiveAgent: UIViewController {

    @IBOutlet var btnImagedropDown: UIButton!
    @IBOutlet var lblbymaneuser: UILabel!
    @IBOutlet var backFeedView: UIView!
    @IBOutlet var lblSelectStatus: UILabel!
    @IBOutlet var lblBystatus: UILabel!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var lblByname: UIView!
    @IBOutlet var lblSearch: UILabel!
    
    var delegate : SearchDiableActiveAgentDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        backFeedView.setBorderColor(color: Colors.lightGrey)
        backFeedView.setBorderWidth(width: 0.5)
        
//        btnImagedropDown.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
//        btnImagedropDown.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func broddownAction(_ sender: UIButton) {
        
        let dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = backFeedView // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Active","Disabled"]
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.lblSelectStatus.text = item
            //self.feedBackLbl.textColor = Colors.black
        }
        
        
    }
    
    @IBAction func CancelAction(_ sender: UIButton) {
        delegate?.didCancel()
        
    }
    @IBAction func SearchAction(_ sender: UIButton) {
        
        delegate?.SearchBtnClicked(name: self.txtUserName.text!, status: self.lblSelectStatus.text)
    }
    
    
    
    
    

}
