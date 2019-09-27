//
//  SearchPopUpViewController.swift
//  ValetParking
//
//  Created by My Technology on 25/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import DropDown

protocol SearchPopUpViewControllerDelegate {
    func didSelectSearchBtn(name:String?,carNumber:String?,status:String?)
    
    func didSelectCancelBtn()
    
    
}

class SearchPopUpViewController: UIViewController {

    @IBOutlet var nameTxtField: UITextField!
    @IBOutlet var carNumberTxtField: UITextField!
    @IBOutlet var dropDownBtn: UIButton!
    @IBOutlet var statusBtn: UILabel!
    
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var feedBackView: UIView!
    @IBOutlet var searchBtn: UIButton!
    var delegate : SearchPopUpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.addTapToDismiss()
        
        searchBtn.addTarget(self, action: #selector(positiveBtnAction(_:)), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction(_:)), for: .touchUpInside)
        
        feedBackView.setBorderColor(color: Colors.lightGrey)
        feedBackView.setBorderWidth(width: 0.5)
        
        searchBtn.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        cancelBtn.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
    }
    
    @objc func positiveBtnAction(_ sender: UIButton) {
        
 delegate?.didSelectSearchBtn(name: nameTxtField.text!, carNumber: carNumberTxtField.text!, status: statusBtn.text)
        
//        delegate?.didSelect2PositiveBtn(oldPassword: oldPassword.text, newPassword: newPassword.text, confirmNewPassword: confirmNewPassword.text)
        
    }
    
    @objc func cancelBtnAction(_ sender: UIButton) {
        
       delegate?.didSelectCancelBtn()
        
    }
    
    @IBAction func statusBtnAction(_ sender: UIButton) {
        let dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = feedBackView // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Release","In Progress"]
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
                    self.statusBtn.text = item
            //self.feedBackLbl.textColor = Colors.black
    }
    
    }

}
