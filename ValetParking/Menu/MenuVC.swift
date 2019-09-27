//
//  MenuVC.swift
//  ValetParking
//
//  Created by Zafar Najmi on 15/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import SocketIO
import Starscream
import SwiftyJSON


protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}
enum LeftMenu: Int {
    
    case History
    case AboutValetParking
    case contact
    case TermsAndCondition
    case Logout
    case aboutus
//    case home = 0
//    case changeLanguage
//    
}
class MenuVC: UIViewController {
    
    var manager:SocketManager!
    var socket:SocketIOClient!
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
   
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var SideMenuTableView: UITableView!

    @IBOutlet weak var UserEmail: UILabel!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet var profileDetailBtn: UIButton!
    
    var termsandcondition : UIViewController!
    var ValetParkingVC: UIViewController!
    var contactVC: UIViewController!
    var aboutVC: UIViewController!
    var HistoryVC: UIViewController!
    var LogoutVC: UIViewController!
    var companyProfileVC:UIViewController!
    
    var settingArray = [SettingsPages]()
    var setingObject = SettingsMain()
    var count = -1
    
    
    var imgArr = [UIImage(named: "History"), UIImage(named: "About"),UIImage(named: "Contact"),UIImage(named: "Terms"),UIImage(named: "Logout")]
    
    var imgArr2 = [#imageLiteral(resourceName: "Profile"),#imageLiteral(resourceName: "History"),#imageLiteral(resourceName: "Agent"),#imageLiteral(resourceName: "Language"),#imageLiteral(resourceName: "About"),#imageLiteral(resourceName: "Terms"),#imageLiteral(resourceName: "Contact"),#imageLiteral(resourceName: "Help"),#imageLiteral(resourceName: "Logout")]
    
    var imgArrForValet = [#imageLiteral(resourceName: "Profile"),#imageLiteral(resourceName: "History"),#imageLiteral(resourceName: "Language"),#imageLiteral(resourceName: "Terms"),#imageLiteral(resourceName: "About"),#imageLiteral(resourceName: "Contact"),#imageLiteral(resourceName: "Help"),#imageLiteral(resourceName: "Logout")]
    
    
    
     var nameArr = ["Profile".localized,"History".localized,"Valet".localized,"Change Language".localized,"Contact Us".localized,"Help".localized,"Logout".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setsocketIOS()
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        self.initializeVC()
        setData()
        self.ProfileDesign()
        self.makeSettingsApiCall()
        //self.navigationController?.navigationBar.isHidden = true
        
        self.SideMenuTableView.contentInset = UIEdgeInsets(top: 5,left: 0,bottom: 0,right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        print(Shared.sharedInfo.userModel.data?.fullName!)
        setData()
        setsocketIOS()
      // addMenu()
    }
    
//    func addMenu() {
//        let imageLeftmenu = UIImage (named: "Menu")
//        let tintedLeftImage = imageLeftmenu?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        buttonLeftMenu.setImage(tintedLeftImage, for: .normal)
//        buttonLeftMenu.tintColor = UIColor.white
//        buttonLeftMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        buttonLeftMenu.addTarget(self, action: #selector(actionLeftMenu(_:)), for: .touchUpInside)
//        let item = UIBarButtonItem(customView: buttonLeftMenu)
//        self.navigationItem.setLeftBarButton(item, animated: true)
//    }
    
    @objc func actionLeftMenu (_ sender: Any){
        print ("Menu Button")
        if lang == "ar" {
            self.toggleRight()
            
        }else {
            self.toggleLeft()
            
        }
    }
    
  

func ProfileDesign()
{
    
    self.ProfileImage.layer.cornerRadius = 50//self.ProfileImage.frame.size.width / 2;
    self.ProfileImage.clipsToBounds = true
    //self.ProfileImage.layer.borderWidth = 0.5
    //self.ProfileImage.layer.borderColor = UIColor.lightGray.cgColor
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func initializeVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let parkedhistory = storyBoard.instantiateViewController(withIdentifier: "ParkedCarHistoryVC") as! ParkedCarHistoryVC
        self.HistoryVC = UINavigationController(rootViewController: parkedhistory)
        
        let termcondition = storyboard?.instantiateViewController(withIdentifier: "TermsAndConditions") as! TermsAndConditions
        self.termsandcondition = UINavigationController(rootViewController: termcondition)
        
        let contact = storyBoard.instantiateViewController(withIdentifier: "ContactVC") as! ContactVC
        self.contactVC = UINavigationController(rootViewController: contact)
        
        let about = storyboard?.instantiateViewController(withIdentifier: "AboutUs") as! AboutUs
        self.aboutVC = UINavigationController(rootViewController: about)
        
        let company = storyBoard.instantiateViewController(withIdentifier: "CompanyProfileVC") as! CompanyProfileVC
        self.companyProfileVC = UINavigationController(rootViewController:company)
        
    }
 
    

    
    @objc func openAboutVC() {

        
//        Shared.sharedInfo.settingObj = button.tag
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUs") as! AboutUs
//        vc.isTermsAndCondition = true
        
        
        self.performSegue(withIdentifier: "AboutVC", sender:self)
    }
    
    
    @objc func openTermsAndCondition() {
        
        
        //        Shared.sharedInfo.settingObj = button.tag
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUs") as! AboutUs
        vc.isTermsAndCondition = true
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
//        self.navigationController?.pushViewController(UINavigationController(rootViewController: vc), animated: true)
        
        
//        self.performSegue(withIdentifier: "AboutVC", sender:self)
    }
    //termsandcondition
    @objc func openContactVC() {
        self.performSegue(withIdentifier: "Contact", sender:self)
    }
    
    @objc func openHelpVC() {
        self.performSegue(withIdentifier: "help", sender:self)
    }
    
    @objc func openHistoryVC() {
        self.performSegue(withIdentifier: "History", sender: self)
    }
    
    @objc func openSignINVC() {
        
        let user1 = Shared.sharedInfo.userModel.data
        let user = user1?.toJSON()
        //var dataChat = dictionary["data"] as! [String: AnyObject]
        
        //let dictionary = ["aKey": "aValue", "anotherKey": "anotherValue"]
//        if let theJSONData = try? JSONSerialization.data(
//            withJSONObject: user,
//            options: []) {
//            let theJSONText = String(data: theJSONData,
//                                     encoding: .ascii)
//            print("JSON string = \(theJSONText!)")
//
//
//            let conversationmessage = [
//                "user":  user//theJSONText
//            ]
//
//            print(conversationmessage)
//
//            self.socket.emit("userLoggedOut", with: [conversationmessage])
//
//        }
        print(user)
        let conversationmessage = [
            "user":  user!//theJSONText
        ]
        
       // print(conversationmessage)
        
        self.socket.emit("agentLoggedOut", with: [conversationmessage])
        

       
       self.performSegue(withIdentifier:"singIn" , sender: self)
        
        
    }
    
    @objc func openAgentsVC() {
        
        self.performSegue(withIdentifier:"agentListing" , sender: self)
        
    }
    
    @objc func openLanguageVC() {
        
        self.performSegue(withIdentifier:"Language" , sender: self)
        
    }
    
    @objc func openProfileVC() {
        self.performSegue(withIdentifier: "profile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        if let ctrl = segue.destination as? AboutUs {
            
                ctrl.countArray = settingArray
            
            
        }
    }
    
    
    func setData() {
        if let imageUrl = Shared.sharedInfo.userModel.data?.image {
            let url = URL(string: imageUrl)
            ProfileImage.af_setImage(withURL: url!)
        }
        
        
        //  print(url!)
        
        
        UserName.text = Shared.sharedInfo.userModel.data?.fullName
        UserEmail.text = Shared.sharedInfo.userModel.data?.email
        
    }
    
    func makeSettingsApiCall() {
        ApiManager.shared.getSettings(success: { setting in
            var nameArrs = ["Profile".localized,"History".localized,"Change Language".localized,"Contact".localized,"Logout".localized]
            Shared.sharedInfo.settingModel = setting
            
            if let arr = setting.data?.pages {
                 self.settingArray = arr
                for setting in self.settingArray {
                    if Shared.sharedInfo.userModel.data?.role?.roleType == "Company" {
                        if self.lang == "en" {
                            if let s = setting.title?.en {
                                
                                print(s)
                                
                                switch s {
                                case "About us":
                                   self.nameArr.insert(s, at:4) //4
                                case "Terms & Conditions":
                                    self.nameArr.insert(s, at:5) //4
                                default:
                                    print("data not found")
                                }
                        }
                        
                            if let img = setting.image {
                                let url = URL(string: img)
                                //self.imgArr2.insert(.af_setImage(withURL: url!), at:4)
                                
                            }
                            
                            
                        }
                        else {
                            if let s = setting.title?.ar {
                                self.nameArr.insert(s, at:4)  //4
                            }
                        }
                    }
                    else {
                        
                        //self.nameArr.removeAll()
                        if let s = setting.title?.en {
                            var a = ""
                            if s == "Terms & Conditions" {
                                a = "About Us".localized
                                nameArrs.insert(a, at: 3) //3
                                nameArrs.insert("Help", at: 6)
                            }
                            else {
                                a = "Terms & Conditions".localized
                                nameArrs.insert(a, at: 3)
                            }
                            
                            
                        }
                        
                        print(nameArrs)
                        self.nameArr = nameArrs
                    }
                    
                   
                }
                self.SideMenuTableView.reloadData()
            }
           
            
            
        }, failure: {
            error in
        })
    }
    
    @IBAction func profileBtnAction(_ sender: UIButton) {
        
        //self.performSegue(withIdentifier: "agentProfile", sender: sender)
    }
    
    @IBAction func cellButtonAction(_ sender: UIButton) {
        
    }
    
}
extension MenuVC : UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return nameArr.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        
        for title in settingArray {
            print(title.title?.en)
            //cell.MenuItemName.text = title.title?.en
        }
        cell.MenuItemName.text = nameArr[indexPath.row]
        
        
        if Shared.sharedInfo.userModel.data?.role?.roleType == "Company" {
            cell.MenuItemImage.image = imgArr2[indexPath.row]
        }
        else {
            cell.MenuItemImage.image = imgArrForValet[indexPath.row]
        }
        
        
        
//        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileTapped(tapGestureRecognizer:)))
        cell.outerBtn.tag = indexPath.row
        cell.outerBtn.isUserInteractionEnabled = true
        //cell.outerBtn.addGestureRecognizer(profileTapGestureRecognizer)
        

        
        

//        if Shared.sharedInfo.userModel.data?.role?.roleType == "Company" {
//            switch indexPath.row {
//            case 0:
//                cell.outerBtn.addTarget(self, action: #selector(openProfileVC(_:)), for: .touchUpInside)
//            case 1:
//                cell.outerBtn.addTarget(self, action: #selector(openHistoryVC(_:)), for: .touchUpInside)
//            case 2:
//                cell.outerBtn.addTarget(self, action: #selector(openAgentsVC(_:)), for: .touchUpInside)
//            case 3:
//                Shared.sharedInfo.languageBackButton = 1
//                cell.outerBtn.addTarget(self, action: #selector(openLanguageVC(_:)), for: .touchUpInside)
//            case 4:
//
//                cell.outerBtn.addTarget(self, action: #selector(openAboutVC(_:)), for: .touchUpInside)
//            case 5:
//
//                cell.outerBtn.addTarget(self, action: #selector(openAboutVC(_:)), for: .touchUpInside)
//
//            case 6:
//                   cell.outerBtn.addTarget(self, action: #selector(openContactVC(_:)), for: .touchUpInside)
//            case 7:
//                    cell.outerBtn.addTarget(self, action: #selector(openHelpVC(_:)), for: .touchUpInside)
//            case 8:
//                cell.outerBtn.addTarget(self, action: #selector(openSignINVC(_:)), for: .touchUpInside)
//            default:
//                break
//                //cell.outerBtn.addTarget(self, action: #selector(openAboutVC(_:)), for: .touchUpInside)
//            }
//
//        }
//        else {
//            switch indexPath.row {
//            case 0:
//                cell.outerBtn.addTarget(self, action: #selector(openProfileVC(_:)), for: .touchUpInside)
//            case 1:
//                cell.outerBtn.addTarget(self, action: #selector(openHistoryVC(_:)), for: .touchUpInside)
//            case 2:
//                Shared.sharedInfo.languageBackButton = 1
//                cell.outerBtn.addTarget(self, action: #selector(openLanguageVC(_:)), for: .touchUpInside)
//            case 5:
//                cell.outerBtn.addTarget(self, action: #selector(openContactVC(_:)), for: .touchUpInside)
//            case 6:
//                cell.outerBtn.addTarget(self, action: #selector(openHelpVC(_:)), for: .touchUpInside)
//            case 7:
//                cell.outerBtn.addTarget(self, action: #selector(openSignINVC(_:)), for: .touchUpInside)
//            default:
//                cell.outerBtn.addTarget(self, action: #selector(openAboutVC(_:)), for: .touchUpInside)
//            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Shared.sharedInfo.userModel.data?.role?.roleType == "Company" {
            switch indexPath.row {
            case 0:
                openProfileVC()
            case 1:
                openHistoryVC()
            case 2:
                openAgentsVC()
            case 3:
                Shared.sharedInfo.languageBackButton = 1
                openLanguageVC()
            case 4:
                
                openAboutVC()
            case 5:
                openTermsAndCondition()
                //openAboutVC()
                
            case 6:
                openContactVC()
            case 7:
                openHelpVC()
            case 8:
                Logout()//openSignINVC()
            default:
                
                openTermsAndCondition()//openAboutVC()
            }
            
        }
        else {
            switch indexPath.row {
            case 0:
                openProfileVC()
            case 1:
                openHistoryVC()
            case 2:
                Shared.sharedInfo.languageBackButton = 1
                openLanguageVC()
            case 3:
                openAboutVC()
            case 5:
                openContactVC()
            case 6:
                openHelpVC()
            case 7:
               Logout()
            default:
                openTermsAndCondition()
            }
        }
    }
    
    
    func Logout()
    {
        Shared.sharedInfo.AutoLogin = false
        openSignINVC()
    }
    func setsocketIOS(){
        
        
        
        
        //let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String
        guard let userToken = Shared.sharedInfo.userModel.data?.authorization else {return}
        
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
        let user = Shared.sharedInfo.userModel
        
        if let a = user.data?.role?.roleType {
            if a == "valet" {
                self.socket.on("agentLoggedout") { (data, ack) in
                    let modified =  (data[0] as AnyObject)
                    
                    let dictionary = modified as! [String: AnyObject]
                    print(dictionary)
                    
                    
                    
                }
            }
            else {
                
                self.socket.on("companyLoggedOut") { (data,ack) in
                    let modified =  (data[0] as AnyObject)
                    
                    let dictionary = modified as! [String: AnyObject]
                    print(dictionary)
                }
                
            }
        }
        
        
      
        
        
        
        
        
        
        self.socket.on(clientEvent: .connect) {data, emitter in
            // handle connected
            //                self.socket.emit("newsFeed")
            //                self.socket.emit("popularBroadcasts")
            //self.socket.emit("notificationsList")
            
            
            
            
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

  
    


