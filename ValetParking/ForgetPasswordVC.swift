//
//  ForgetPasswordVC.swift
//  ValetParking
//
//  Created by My Technology on 03/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import NotificationBannerSwift


class ForgetPasswordVC: UIViewController {
    
    @IBOutlet var cancelButton: UIButton!
    var password = ForgetPasswordMain()

    @IBOutlet var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       setNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func setNavigationBar(){
        
        cancelButton.setTitle("Cancel", for: .normal)
        self.title = "Forget Password"
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        if (emailTextField.text?.isEmpty)!  {
            let banner = NotificationBanner(title: "error", subtitle: "Please Enter Email", style: .danger)
            banner.show()
            banner.duration = 0.3 }
         else {
            makeForgetPasswordApiCall()
        }
    }
        
    
    @IBAction func cancellBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeForgetPasswordApiCall() {
        //        let email = LoginEmail.text ?? ""
        //        let password = LoginPassword.text ?? ""
        
        LoaderManager.show(self.view)
        ApiManager.shared.forgetPassword(email: emailTextField.text!, success: { user in
            self.password = user
            LoaderManager.hide(self.view)
            
            if let password = user.message?.en {
                // Create the alert controller
                let alertController = UIAlertController(title: "Email Sent", message: password, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style:UIAlertAction.Style.default) {
                    UIAlertAction in
                    if user.success! == true {
                        self.performSegue(withIdentifier: "verifyPassword", sender: self)
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

}
