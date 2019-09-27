//
//  ContactVC.swift
//  ValetParking
//
//  Created by Zafar Najmi on 18/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import DropDown

class ContactVC: UIViewController,UITextViewDelegate{
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    

    @IBOutlet var feedBackView: UIView!
    
    @IBOutlet var feedBackLbl: UILabel!
    @IBOutlet var nameTxtField: UITextField!
    @IBOutlet var emailTxtField: UITextField!
    
    @IBOutlet var whatLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var yourCommentLabel: UILabel!
    @IBOutlet var submitButton: UIButton!
    
    @IBOutlet var feedBackTextView: UITextView!
    override func viewDidLoad() {
        
        feedBackTextView.delegate = self
        
        super.viewDidLoad()
        submitButton.setTitle("Submit".localized, for: .normal)
        self.title = "Contact Us"
        whatLbl.text = "What can we help you with".localized
        nameLbl.text = "Name".localized
        emailLbl.text = "Email".localized
        yourCommentLabel.text = "Your Comment".localized
        
        feedBackTextView.setBorderWidth(width: 0.5)
        feedBackTextView.setBorderColor(color: Colors.lightGrey)
       
        //feedBackLbl.text = ""
   feedBackView.setBorderWidth(width: 0.5)
    feedBackView.setBorderColor(color:Colors.lightGrey)
        var colors = [UIColor]()
        colors.append(Colors.blue)
        colors.append(Colors.Mediumblue)
        
       //self.navigationItem.title = "Contact"
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
//         self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        self.navigationController?.navigationItem.title = "some"
     // self.navigationController?.navigationBar.setGradientBackground(colors: colors)

//        let gradient = CAGradientLayer()
//        gradient.frame = CGRect(x: 0, y: 0, width: UIApplication.shared.statusBarFrame.width, height: UIApplication.shared.statusBarFrame.height + self.navigationController!.navigationBar.frame.height)
//        gradient.locations = [0.0,1.0]
//        gradient.colors = colors
//        self.view.layer.addSublayer(gradient)
//        self.view.backgroundColor = UIColor.clear

        let bell_button = UIButton(type: .system)
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            bell_button.setImage(#imageLiteral(resourceName: "Ar-back").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else {
            bell_button.setImage(#imageLiteral(resourceName: "back-2").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        bell_button.addTarget(self, action: #selector( notification_message(_:)), for: .touchUpInside)

        navigationItem.leftBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
        
        
       //self.setNavigationBar()
//       self.addMenu()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        feedBackTextView.text = ""
    }
    
    @objc func notification_message(_ sender: Any)
    {
        self.dismiss(animated: true, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
var navColor = UIColor(red: 38/255, green: 74/255, blue: 254/255, alpha: 1.0)
    
    func setNavigationBar(){
        var colors = [UIColor]()
        colors.append(Colors.blue)
        colors.append(Colors.Mediumblue)
        
        //self.title = "Contact"
        //let color: [UIColor] = colors
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Poppins", size: 20)!]
        for color in colors {
            self.navigationController!.navigationBar.barTintColor = color
        }
        //self.navigationController?.navigationBar.setGradientBackground(colors: colors)
        
        self.navigationController!.navigationBar.barStyle = .blackOpaque
    }
    
    
    @IBAction func onDropDownBtnClick(_ sender: UIButton) {
        
        let dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = feedBackView // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["App Feedback","Complaint"]
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.feedBackLbl.text = item
            self.feedBackLbl.textColor = Colors.black
        }
        
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
    
    @IBAction func contactUsBtnAction(_ sender: UIButton) {
        
      
            
            LoaderManager.show(self.view, message: "Please Wait")
            ApiManager.shared.ContactUs(name:nameTxtField.text!, email: emailTxtField.text!, subject:feedBackLbl.text!, message: feedBackTextView.text!, success: { message in
                LoaderManager.hide(self.view)
                
                let alertController = UIAlertController(title: "Message Sent", message: message.message?.en!, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style:UIAlertAction.Style.default) {
                    UIAlertAction in
                    //self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                
            }, failure: {
                error in
                let alertController = UIAlertController(title: "Error", message: error.message, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    //self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            })
            
        
    
            
      }



}
