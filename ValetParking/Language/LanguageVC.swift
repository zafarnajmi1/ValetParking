//
//  ViewController.swift
//  ValetParking
//
//  Created by Zafar Najmi on 10/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class LanguageVC: UIViewController {

    @IBOutlet var lblSelectLanguage: UILabel!
    @IBOutlet weak var Arabic: UIButton!
    @IBOutlet weak var English: UIButton!
    
    
    //let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet var selectContinueLbl: UILabel!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            UserDefaults.standard.set("en", forKey: "i18n_language")
        self.title = "Language".localized
        lblSelectLanguage.text = "Select language".localized
        selectContinueLbl.text = "Select language to continue with".localized
        let defaults = UserDefaults.standard
        defaults.set(1, forKey: "Language")
        
             
        if Shared.sharedInfo.userModel.data?.fullName == nil {
            return
        }
        else {
            let bell_button = UIButton(type: .system)
            if lang == "ar" {
                bell_button.setImage(#imageLiteral(resourceName: "Ar-back").withRenderingMode(.alwaysOriginal), for: .normal)
            }
            else {
                bell_button.setImage(#imageLiteral(resourceName: "back-2").withRenderingMode(.alwaysOriginal), for: .normal)
            }
            bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
            bell_button.addTarget(self, action: #selector( notification_message(_:)), for: .touchUpInside)
            
            navigationItem.leftBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
        }
        
        
        
        var colors = [UIColor]()
        colors.append(Colors.Mediumblue)
        colors.append(Colors.blue)
    
        //English.applyGradient(colours: colors)
        
        
        
        
        
       
//        Arabic.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
//        English.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        
       
        
     //self.navigationController?.navigationBar.setGradientBackground(colors: colors)
        //UINavigationBar.appearance().isTranslucent = false
        //UINavigationBar.appearance().clipsToBounds = false
       // appDelegate.customizeNavigationBar()
        //self.title = "Language"
        
//        self.Arabic.ButtonDesign()
//        self.English.ButtonDesign()
//        var colors = [UIColor]()
//        colors.append(Colors.blue)
//        colors.append(Colors.Mediumblue)
//        UINavigationBar.appearance().setGradientBackground(colors: colors)
        //appDelegate.customizeNavigationBar()
        
//        var colors = [UIColor]()
//        colors.append(Colors.blue)
//        colors.append(Colors.Mediumblue)
//        navigationController?.navigationBar.setGradientBackground(colors: colors)
//        
//        let backButtonImage = #imageLiteral(resourceName: "back-1")
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonAction(_:)))
//        backButton.imageInsets = UIEdgeInsetsMake(0, -13, 0, -5)
//        self.navigationItem.leftBarButtonItem = backButton
    
    
    // MARK: Action
     
       // lblSelectLanguage.text = "Select language".localized
        
        
    }
    
    @objc func notification_message(_ sender: Any)
    {
        
        self.dismiss(animated: true, completion: nil)
        
        //self.navigationController?.popViewController(animated:true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var colors = [UIColor]()
        colors.append(Colors.Mediumblue)
        colors.append(Colors.blue)
        Arabic.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
       // English.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
    }
    
    
    
//    @objc func backButtonAction(_ sender: UIBarButtonItem) {
//       // self.navigationController?.popViewController(animated: true)
//    }
    
  
    override func viewWillAppear(_ animated: Bool) {
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func ArabicAction(_ sender: Any) {
        
        
        UserDefaults.standard.set("ar", forKey: "i18n_language")
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        
        if let a = Shared.sharedInfo.userModel.data?.role?.roleType
        {
            if a == "valet" {
                appDelegate.isFromMenuu = true
                self.appDelegate.moveToHome()
            }
            else {
                appDelegate.isFromMenuu = true
                self.appDelegate.moveToAdmin()
            }
            
        }
        else {
            self.performSegue(withIdentifier:"SignIn", sender: self)
        }
        
               }
    
    
        
    
        
        
    
    @IBAction func EnglishAction(_ sender: Any) {
        
            UserDefaults.standard.set("en", forKey: "i18n_language")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
        
        
        
            if let a = Shared.sharedInfo.userModel.data?.role?.roleType
            {
                if a == "valet" {
                    self.appDelegate.moveToHome()
                }
                else {

                    self.appDelegate.moveToAdmin()
                }
                
            }
            else {
                self.performSegue(withIdentifier:"SignIn", sender: self)
        }
        }
        
    }
    



