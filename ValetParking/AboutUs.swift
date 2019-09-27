//
//  AboutUs.swift
//  ValetParking
//
//  Created by Zafar Najmi on 18/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class AboutUs: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
     var setting = SettingsMain()
    var countArray = [SettingsPages]()
    var isTermsAndCondition = false
    
    @IBOutlet var btnlinkedIn: UIButton!
    @IBOutlet var btnfb: UIButton!
    @IBOutlet var btntiwtier: UIButton!
    @IBOutlet var titleLbl: UILabel!
    var count = 0
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    @IBOutlet var detailLbl: UILabel!
    
    @IBOutlet var followUsLbl: UILabel!
    @IBOutlet var detailTxtView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followUsLbl.text = "Follow Us".localized
        
//        let aboutUs =
//
//        if Shared.sharedInfo.settingObj == 4 {
//            let aboutUs = Shared.sharedInfo.settingModel.data?.pages![0]
//        }
//        else {
//            let terms = Shared.sharedInfo.settingModel.data?.pages![0]
//        }
        
        var obj = Shared.sharedInfo.settingObj
        
        guard let role = Shared.sharedInfo.userModel.data?.role?.roleType else {return}
        
        print(obj)
        if  role == "company" {
            if obj == 5 {
                obj = 4
            }
            else {
                obj = 5
            }
        }
        else {
            
            if obj == 4 {
                obj = 3
            }
            else {
                obj = 4
            }
            
        }
        
        
        
        
        self.navigationItem.hidesBackButton = true
       
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let bell_button = UIButton(type: .system)
        if lang == "ar" {
            bell_button.setImage(#imageLiteral(resourceName: "Ar-back").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else {
            bell_button.setImage(#imageLiteral(resourceName: "back-2").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        bell_button.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
        
        
        // Do any additional setup after loading the view.
        
       // guard let role = Shared.sharedInfo.userModel.data?.role?.roleType else {return}
        
        var count = 0  //menow
        if role == "company" {
            count = 4
        }
        else {
            count = 3
        }
        if(isTermsAndCondition == true)
        {
            count = 3
        }else
        {
            count = 4
        }
        
        let arr = Shared.sharedInfo.settingModel.data?.pages![obj - count] //"About us"
        print(arr?.title?.en)
        print(arr?.title?.en)
        //"Terms & Conditions"
        if lang == "en" {
            
            if isTermsAndCondition == true {
                self.title = "Terms & Conditions"
                titleLbl.text = "Terms & Conditions"
                self.btnfb.isHidden = true
                self.btntiwtier.isHidden = true
                self.btnlinkedIn.isHidden = true
                self.followUsLbl.isHidden = true
            }
            
            else {
                self.title = "About us"
                titleLbl.text = "About us"
            }
//            self.title = arr?.title?.en?.localized
//            titleLbl.text = arr?.title?.en?.localized
            
            if let detail = arr?.detail?.en?.localized {
                
                detailTxtView.text = detail.html2String.localized
            }
        }
        else {
            if isTermsAndCondition == false {
                self.title = "Terms & Conditions"
                titleLbl.text = "Terms & Conditions"
            }
                
            else {
                self.title = "About us"
                titleLbl.text = "About us"
            }
            //self.title = arr?.title?.ar?.localized
            //titleLbl.text = arr?.title?.ar?.localized
            
            if let detail = arr?.detail?.ar?.localized {
                
                detailTxtView.text = detail.html2String
        }
            
        
        //self.setNavigationBar()
        //self.addMenu()
    }
    }

    @objc func back(_ sender:Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    var navColor = UIColor(red: 38/255, green: 74/255, blue: 254/255, alpha: 1.0)
    func setNavigationBar(){
        
        let color: UIColor = navColor
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Poppins", size: 20)!]
        self.navigationController!.navigationBar.barTintColor = color
        self.navigationController!.navigationBar.barStyle = .blackOpaque
    }
    
    
    
    func addMenu() {
        let buttonLeftMenu = UIButton (type: .custom)
        let imageLeftmenu = UIImage (named: "Menu")
        let tintedLeftImage = imageLeftmenu?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        buttonLeftMenu.setImage(tintedLeftImage, for: .normal)
        buttonLeftMenu.tintColor = UIColor.white
        buttonLeftMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        buttonLeftMenu.addTarget(self, action: #selector(actionLeftMenu(_:)), for: .touchUpInside)
        let item = UIBarButtonItem(customView: buttonLeftMenu)
        self.navigationItem.setLeftBarButton(item, animated: true)
        
        let bell_button = UIButton(type: .system)
        bell_button.setImage(#imageLiteral(resourceName: "Notification").withRenderingMode(.alwaysOriginal), for: .normal)
        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        bell_button.addTarget(self, action: #selector( notification_message(_:)), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
    }
    
    @objc func actionLeftMenu (_ sender: Any)
    {
        self.toggleLeft()
    }
    
    @objc func notification_message(_ sender: Any)
    {
        
    }
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion:nil)
    }
}
