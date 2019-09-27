//
//  PopUp2ViewController.swift
//  ValetParking
//
//  Created by macbook on 22/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//
//  PopUpViewController.swift
//  ValetParking
//
//  Created by My Technology on 11/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

protocol Popup2ViewControllerDelegate {
    func didSelect2PositiveBtn(oldPassword:String?,newPassword:String?,confirmNewPassword:String?)
    func didSelect2NegativeBtn(oldPassword:String?,newPassword:String?,confirmNewPassword:String?)
    
    
    
}
class Popup2ViewController: UIViewController {
    
    var popupTitle: String?
    var popupDescription: String?
    var positiveText: String?
    var negativeText: String?
    var identifier: Int?
    var text:String?
    
    
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet var oldPassword: UITextField!
    @IBOutlet weak var confirmNewPassword: UITextField!
    
    
    var delegate : Popup2ViewControllerDelegate?
    @IBOutlet var popupView: Popup2View!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.positiveBtn.addTarget(self, action: #selector(positiveBtnAction(_:)), for: .touchUpInside)
        popupView.negativeBtn.addTarget(self, action: #selector(negativeBtnAction(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let popupTitle = popupTitle {
            popupView.headerLabel.text = popupTitle
        }
        
        if let popupDescription = popupDescription {
            popupView.descriptionLabel.text = popupDescription
            popupView.descriptionLabel.sizeToFit()
        }
        
        if let positiveText = positiveText {
            popupView.positiveBtn.setTitle(positiveText, for: .normal)
        }
        
        if let negativeText = negativeText {
            popupView.negativeBtn.setTitle(negativeText, for: .normal)
        }
        
        if let textField = newPassword {
            newPassword.placeholder = textField.placeholder
         
              //newPassword.keyboardType = UIKeyboardType.numberPad
            
            
        }
        
        if let textField = confirmNewPassword {
            confirmNewPassword.placeholder = textField.placeholder
            
           // confirmNewPassword.keyboardType = UIKeyboardType.numberPad
            
            
        }
        
    
        
        if let textField = oldPassword {
            oldPassword.placeholder = textField.placeholder
            
           // oldPassword.keyboardType = UIKeyboardType.numberPad
            
          
            
        }
        
      
        
        
        
        
        
        
        
        
    }
    
    // MARK: - Action
    @objc func positiveBtnAction(_ sender: UIButton) {
        
//        if newPassword! != confirmNewPassword!{
//            let alertController = UIAlertController(title: "Error", message: "password doesNot Match", preferredStyle: .alert)
//
//            // Create the actions
//            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                UIAlertAction in
//
//            }
//            // Add the actions
//            alertController.addAction(okAction)
//            //alertController.addAction(cancelAction)
//
//            // Present the controller
//            self.present(alertController, animated: true, completion: nil)
//        }
//
//        else {
//            delegate?.didSelect2PositiveBtn(oldPassword: oldPassword.text, newPassword: newPassword.text, confirmNewPassword: confirmNewPassword.text)
//        }
        
                
        
         delegate?.didSelect2PositiveBtn(oldPassword: oldPassword.text, newPassword: newPassword.text, confirmNewPassword: confirmNewPassword.text)
        
    }
    
    @objc func negativeBtnAction(_ sender: UIButton) {
        
     
            
        
            delegate?.didSelect2NegativeBtn(oldPassword: oldPassword.text, newPassword: newPassword.text, confirmNewPassword: confirmNewPassword.text)
        
        
    }
    
    
    
}
