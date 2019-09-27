//
//  PopUpViewController.swift
//  ValetParking
//
//  Created by My Technology on 11/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

protocol PopupViewControllerDelegate {
    func didSelectPositiveBtn(text:String?)
    func didSelectNegativeBtn(text:String?, index: Int?)
    
    
    
}
class PopupViewController: UIViewController {
    
    var popupTitle: String?
    var popupDescription: String?
    var positiveText: String?
    var negativeText: String?
    var identifier: Int?
    var text:String?
    var placeHolder : String?
    var TextFiled : String?
    var  tfIndex : Int?
    
    @IBOutlet var edit: UITextField!
    var delegate : PopupViewControllerDelegate?
    @IBOutlet var popupView: PopupView!
    
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
        
        if let editplaceHodel = placeHolder
        {
            edit.placeholder = editplaceHodel
        }
        
        if let EditText = TextFiled
        {
            edit.text = EditText
        }
        
        if let textField = edit {
            edit.placeholder = textField.placeholder
            if popupTitle == "Phone" {
                edit.keyboardType = UIKeyboardType.numberPad
            }
            
        }
        
        
    }
    
    // MARK: - Action
    @objc func positiveBtnAction(_ sender: UIButton) {
        delegate?.didSelectPositiveBtn(text:edit.text)
         
        
        
        
    }
    
    @objc func negativeBtnAction(_ sender: UIButton) {
        delegate?.didSelectNegativeBtn(text:edit.text, index : tfIndex)
    }
    
    
    
}
