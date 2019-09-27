//
//  SplashVC.swift
//  ValetParking
//
//  Created by Zafar Najmi on 10/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    @IBOutlet var splashView: UIView!
    
    var Langchoice:Int?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fcmToken = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        
  splashView.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        let defaults = UserDefaults.standard
        Langchoice = defaults.value(forKey:"Language") as? Int
        
     perform(#selector(SplashVC.ShowSignInVC), with: nil, afterDelay: 1)
        //LoginChk()
    }
    
    
    
    @objc  func ShowSignInVC()
    {

        if Langchoice == 1 {
            LoginChk()
            //self.performSegue(withIdentifier: "SignIn", sender: self)
        }

        else {
            performSegue(withIdentifier: "splash", sender: self)
        }
    }
    
    func LoginChk()
    {
        if(Shared.sharedInfo.AutoLogin == true)
        {
            makeLoginUserApiCall()
        }else
        {
            
//            let vc = storyboard?.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
//               present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            
            //self.performSegue(withIdentifier: "SignIn", sender: self)
            
            
            if Langchoice == 1 {

                self.performSegue(withIdentifier: "SignIn", sender: self)
            }

            else {
                performSegue(withIdentifier: "splash", sender: self)
            }
            
        }
        
    }
    
    
    
    func makeLoginUserApiCall() {
        
        if let getToken = UserDefaults.standard.value(forKey: "fcmToken") as? String {
            self.fcmToken = getToken
            print(getToken)
        }
        
        LoaderManager.show(self.view, message: "please wait")
        ApiManager.shared.loginUser(email: Shared.sharedInfo.email!, password: Shared.sharedInfo.password!,fcm:self.fcmToken, success: { user in
            
            LoaderManager.hide(self.view)
            if user.success == true {
                
               
                Shared.sharedInfo.email = user.data?.email
                Shared.sharedInfo.authtoken = user.data?.authorization
                
                Shared.sharedInfo.userModel = user
                if let a = user.data?.role?.roleType {
                    if a == "valet" {
                        //self.socket.emit("agentLoggedIn")
                        self.appDelegate.moveToHome()
                    }
                    else {
                        //self.setsocketIOS()
                        //self.socket.emit("companyLoggedIn")
                        self.appDelegate.moveToAdmin()
                    }
                }
            }
            else {
                let alertController = UIAlertController(title: "Error", message: user.message?.en, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                }
                // Add the actions
                alertController.addAction(okAction)
                //alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
            
            //print(user.data?.role?.roleType)
            
            //UserDefaultManager.shared.writeUser(user)
            //self.performSegue(withIdentifier: self.mainScreenSegueIdentifier, sender: self)
        }, failure: { error in
            LoaderManager.hide(self.view)
            
            ToastManager.showToastMessage(message: error.message ?? "")
            return
        })
    }
    
    

}
