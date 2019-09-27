//
//  ResetPasswordVC.swift
//  ValetParking
//
//  Created by My Technology on 03/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import NotificationBannerSwift


class ResetPasswordVC: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var verificationTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var confirmNewPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        
    }
    
    func setNavigationBar(){
        self.title = "Reset Password"
        let headerImage = #imageLiteral(resourceName: "Bg 2")
        self.navigationController?.navigationBar.setBackgroundImage(headerImage, for:.default)
        
        //let color: UIColor = navColor
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //self.navigationController!.navigationBar.barTintColor = color
        self.navigationController!.navigationBar.barStyle = .blackOpaque
        
        let bell_button = UIButton(type: .system)
        bell_button.setImage(#imageLiteral(resourceName: "back-2").withRenderingMode(.alwaysOriginal), for: .normal)
        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        bell_button.addTarget(self, action: #selector( notification_message(_:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
    }
    
    @objc func notification_message(_ sender: Any)
    {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateBtnAction(_ sender: UIButton) {
        if (emailTextField.text?.isEmpty)!  {
            let banner = NotificationBanner(title: "error", subtitle: "Please Enter Email", style: .danger)
            banner.show()
            banner.duration = 0.3  }
        else if (verificationTextField.text?.isEmpty)! {
            //ToastManager.showToastMessage(message: "Please Enter Verification Code")
            let banner = NotificationBanner(title: "error", subtitle: "Please Enter Verification Code", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else if (newPasswordTextField.text?.isEmpty)! {
            //ToastManager.showToastMessage(message: "Please Enter Password")
            let banner = NotificationBanner(title: "error", subtitle: "Please Enter Password", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else if (confirmNewPasswordTextField.text?.isEmpty)! {
            //ToastManager.showToastMessage(message: "Please Enter Confirm Password")
            let banner = NotificationBanner(title: "error", subtitle: "Please Enter Confirm Password", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else if (confirmNewPasswordTextField.text != newPasswordTextField.text) {
            //ToastManager.showToastMessage(message: "Password Doesn't Match")
            let banner = NotificationBanner(title: "error", subtitle: "Password Doesn't Match", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else if emailTextField.text?.isValidEmail() != true{
            //ToastManager.showToastMessage(message: "Enter Valid Email")
            let banner = NotificationBanner(title: "error", subtitle: "Enter Valid Email", style: .danger)
            banner.show()
        }
        else {
            makeForgetPasswordApiCall()
        }
        
       
    }
    
    
    func makeForgetPasswordApiCall() {
        //        let email = LoginEmail.text ?? ""
        //        let password = LoginPassword.text ?? ""
        
        LoaderManager.show(self.view)
        ApiManager.shared.ResetPassword(email: emailTextField.text!, verificationCode: verificationTextField.text!, password: newPasswordTextField.text!, confirmPassword: confirmNewPasswordTextField.text!, success: { user in
            
           // self.password = user
            LoaderManager.hide(self.view)
            if let password = user.message?.en {
                
                // Create the alert controller
                let alertController = UIAlertController(title: "Alert", message: password, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    if user.success! == true {
                        Shared.sharedInfo.password = self.confirmNewPasswordTextField.text!
                        Shared.sharedInfo.email = self.emailTextField.text!
                        self.performSegue(withIdentifier: "login", sender: self)
                    }
                    else {
                        return
                    }
                }
                // Add the actions
                alertController.addAction(okAction)
                //alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
            
        }, failure: { error in
            LoaderManager.hide(self.view)
            
            ToastManager.showToastMessage(message: error.message ?? "")
            return
        })
        
    }
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
