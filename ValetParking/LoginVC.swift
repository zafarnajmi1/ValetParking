//
//  LoginVC.swift
//  ValetParking
//
//  Created by Zafar Najmi on 11/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SocketIO
import Starscream
import SlideMenuControllerSwift
import NotificationBannerSwift

class LoginVC: UIViewController {
    
    var manager:SocketManager!
    var socket:SocketIOClient!
     var fcmToken = "0"
    
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var LoginPassword: UITextField!
    @IBOutlet weak var LoginEmail: UITextField!
    
    @IBOutlet weak var mainLogoHieghtCst: NSLayoutConstraint!
    @IBOutlet weak var mainLogoWidthCst: NSLayoutConstraint!
    
    
    @IBOutlet weak var mainLogo: UIImageView!
    @IBOutlet var signInLbl: UILabel!
    @IBOutlet var PasswordView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var userGradientView: UIView!
    @IBOutlet var passwordGradientView: UIView!
    
    @IBOutlet var forgotPasswordBtn: UIButton!
    lazy var user = LoginMain()
    
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    let yourAttributes : [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
        NSAttributedString.Key.foregroundColor : UIColor.lightGray,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    
    // let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainLogoWidthCst.constant = ip6(240*2)
        mainLogoHieghtCst.constant = ip6(240*2)
        
        let attributeString = NSMutableAttributedString(string: "Forgot Password?".localized,
                                                        attributes: yourAttributes)
       forgotPasswordBtn.setAttributedTitle(attributeString, for: .normal)
        
        self.view.addTapToDismiss()
        self.navigationItem.title = "Sign In".localized
        //self.appDelegate.moveToHome()
        //LoginEmail.text? = "testcompany@gmail.com"
        //LoginPassword.text? = "123456"
        signInLbl.text = "Sign In".localized
        LoginEmail.placeholder = "Enter Email".localized
        LoginPassword.placeholder = "Enter Password".localized
        SignInButton.setTitle("Sign in".localized, for: .normal)
        
        forgotPasswordBtn.setTitle("Forgot Password?".localized, for: .normal)
        emailView.setBorderColor(color: Colors.lightGrey)
        emailView.setBorderWidth(width: 0.5)
        emailView.setCornerRadius(r: 7)
        
        PasswordView.setBorderColor(color: Colors.lightGrey)
        PasswordView.setBorderWidth(width: 0.5)
        PasswordView.setCornerRadius(r: 7)
        
       // self.setsocketIOS()
        
        userGradientView.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        passwordGradientView.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        
        leftMarginToPlaceHolder()
        rightMarginToPlaceHolder()

        var colors = [UIColor]()
        colors.append(Colors.blue)
        colors.append(Colors.Mediumblue)
       // self.navigationController?.navigationBar.setGradientBackground(colors: colors)
        
//        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
//        self.view.addSubview(navBar);
//        let navItem = UINavigationItem(title: "SomeTitle");
//        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(getter: UIAccessibilityCustomAction.selector));
//        navItem.rightBarButtonItem = doneItem;
//        navBar.setItems([navItem], animated: false);
//        let yourBackImage = #imageLiteral(resourceName: "back-2")
//        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
//        self.navigationController?.navigationBar.backItem?.title = "Custom"
        
//        let bell_button = UIButton(type: .system)
//        bell_button.setImage(#imageLiteral(resourceName: "back-2").withRenderingMode(.alwaysOriginal), for: .normal)
//        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
//        bell_button.addTarget(self, action: #selector( notification_message(_:)), for: .touchUpInside)
//        
//        navigationItem.leftBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
        setNavigationBar()
//        let headerImage = #imageLiteral(resourceName: "Bg 2")
//        UINavigationBar.appearance().setBackgroundImage(headerImage, for:.default)
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
//        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
//        UINavigationBar.appearance().titleTextAttributes = textAttributes
        
    }
    
    
    
   
    func setNavigationBar(){
        let headerImage = #imageLiteral(resourceName: "Bg 2")
       // self.navigationController?.navigationBar.setBackgroundImage(headerImage, for:.default)
        
        //let color: UIColor = navColor
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //self.navigationController!.navigationBar.barTintColor = color
        self.navigationController!.navigationBar.barStyle = .blackOpaque
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
        self.slideMenuController()?.openRight()
        self.slideMenuController()?.closeRight()
        self.slideMenuController()?.leftPanGesture?.isEnabled = false
        self.slideMenuController()?.rightPanGesture?.isEnabled = false
        
        

        //setsocketIOS()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated:true)
        //self.title = "Login or Create Account".localized
        setNavigationBar()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        SignInButton.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        
        var colors = [UIColor]()
        colors.append(Colors.Mediumblue)
        colors.append(Colors.blue)
       // self.navigationController?.navigationBar.setGradientBackground(colors: colors)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
//    override func viewWillAppear(_ animated: Bool) {
//        let bell_button = UIButton(type: .system)
//        bell_button.setImage(#imageLiteral(resourceName: "back-2").withRenderingMode(.alwaysOriginal), for: .normal)
//        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
//        bell_button.addTarget(self, action: #selector( notification_message(_:)), for: .touchUpInside)
//        
//        navigationItem.leftBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//       //self.navigationItem.titleView?.isHidden = true
//    }
    
    @objc func notification_message(_ sender: Any)
    {
      self.navigationController?.popViewController(animated: true)
    } 

    @IBAction func forgetPassword(_ sender: UIButton) {
        
    }
    @IBAction func signInBtnAction(_ sender: UIButton) {
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        if LoginEmail.text?.isEmpty == true {
            let banner = NotificationBanner(title: "error", subtitle: "Please Enter Email", style: .danger)
            banner.show()
            banner.duration = 0.3
            //ToastManager.showToastMessage(message: "Please Enter Email")
        }
        else if LoginPassword.text?.isEmpty == true {
            let banner = NotificationBanner(title: "error", subtitle: "Please Enter Password", style: .danger)
            banner.show()
             banner.duration = 0.3
            //ToastManager.showToastMessage(message: "Please Enter Password")
        }
        else {
            makeLoginUserApiCall()
        }
        
        
    }
    
    func makeLoginUserApiCall() {

        if let getToken = UserDefaults.standard.value(forKey: "fcmToken") as? String {
            self.fcmToken = getToken
            print(getToken)
        }
        
        LoaderManager.show(self.view, message: "please wait")
        ApiManager.shared.loginUser(email: LoginEmail.text!, password: LoginPassword.text!,fcm:self.fcmToken, success: { user in
            
            LoaderManager.hide(self.view)
            if user.success == true {
                
                Shared.sharedInfo.password = self.LoginPassword.text
                Shared.sharedInfo.email = self.LoginEmail.text!
                Shared.sharedInfo.authtoken = user.data?.authorization
                Shared.sharedInfo.AutoLogin = true
                
                
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
    func leftMarginToPlaceHolder() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 50))
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 50))
       LoginEmail.leftView = paddingView
        LoginPassword.leftView = paddingView2
        LoginEmail.leftViewMode = UITextField.ViewMode.always
        LoginPassword.leftViewMode = UITextField.ViewMode.always
    }
    
    func rightMarginToPlaceHolder() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 50))
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 50))
        LoginEmail.rightView = paddingView
        LoginPassword.rightView = paddingView2
        LoginEmail.rightViewMode = UITextField.ViewMode.always
        LoginPassword.rightViewMode = UITextField.ViewMode.always
    }
    
    
    
    
    
   
    
  
    
    func setsocketIOS(){
        
        
        
        
     let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String
            
            let usertoken = [
                "token":  userToken
            ]
            
            let specs: SocketIOClientConfiguration = [
                .forceWebsockets(true),
                .forcePolling(false),
                .path("/valet-parking/socket.io"),
                .connectParams(usertoken),
                .log(true)]
            
            
            
            
            self.manager = SocketManager(socketURL: URL(string:  "http://216.200.116.25/valet-parking")! , config: specs)
            
            self.socket = manager.defaultSocket
            
            self.manager.defaultSocket.on("connected") {data, ack in
                print(data)
            }
            
            
            
          
            
            
            self.socket.on("connected") { (data, ack) in
                if let arr = data as? [[String: Any]] {
                    if let txt = arr[0]["text"] as? String {
                        print(txt)
                    }
                }
                
            }
            
//            self.socket.on("companyLoggedIn") { (data, ack) in
//                let modified =  (data[0] as AnyObject)
//
//                let dictionary = modified as! [String: AnyObject]
//                print(dictionary)
//
//
//
//            }
        
        
            
          
            
            
            
            self.socket.on(clientEvent: .connect) {data, emitter in
                // handle connected
//                self.socket.emit("newsFeed")
//                self.socket.emit("popularBroadcasts")
                //self.socket.emit("notificationsList")
                
                let user1 = Shared.sharedInfo.userModel.data
                
                if user1 != nil {
                    let user = user1?.toJSON()
                    
                    let conversationmessage = [
                        "user":  user!//theJSONText
                    ]
                    
                     print(conversationmessage)
                    
                    //self.socket.emit("agentLoggedOut", with: [conversationmessage])
                    self.socket.disconnect()
                    
                }
               
           
                
            }
            
            self.socket.on(clientEvent: .disconnect, callback: { (data, emitter) in
                //handle diconnect
            })
            
            self.socket.onAny({ (event) in
                //handle event
            })
            
            self.socket.connect()
        
        
            // CFRunLoopRun()
            
            // Do any additional setup after loading the view.
        
    }
    
    
    
}


