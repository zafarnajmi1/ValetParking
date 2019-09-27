//
//  AgentsListingViewController.swift
//  ValetParking
//
//  Created by My Technology on 10/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SocketIO
import Starscream
import SwiftyJSON


class AgentsListingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    
    var isSearching = false
    var type = ""
    
    var agentsArray = [AgentListingAgents]()
    
    var agentsSearchArray = [AgentListingAgents]()
    var agentMain = AgentListingMain()
    
    
    @IBOutlet var agentListingTableView: UITableView!
    
    var manager:SocketManager!
    var socket:SocketIOClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        rightBarButton()
        getAgentsFromApi()
        self.navigationItem.hidesBackButton = true
        self.title = "Valet"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let bell_button = UIButton(type: .system)
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            bell_button.setImage(#imageLiteral(resourceName: "Ar-back").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else {
            bell_button.setImage(#imageLiteral(resourceName: "back-2").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        bell_button.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func back(_ sender:Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var filterdData = "" {
        didSet {
            //filterdData = cities.filter({$})
            print(filterdData)
            agentsSearchArray = agentsArray.filter({ (agents) -> Bool in
                print(filterdData)
                print(agents.isLoggedIn)
                
                if type == "name" {
                    
                    return  (agents.fullName?.lowercased().contains(st: filterdData.lowercased()))! //(agents.fullName?.contains(st: filterdData))!
                }
                else if (type == "isActive"){
                    
                    return ((agents.isActive != 0))
                    
                }else
                {
                    return ((agents.isActive == 0))
                }
                
                
            })
            // myTableView.reloadData()
            // carListingNewTableView.reloadData()
        }
    }
    
    
    
    
    func rightBarButton() {
        
        let button2 = UIButton.init(type: .custom)
        button2.setImage(UIImage.init(named: "Search"), for: UIControl.State.normal)
        button2.addTarget(self, action:#selector(openPopUp(_:)), for: UIControl.Event.touchUpInside)
        button2.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25) //CGRectMake(0, 0, 30, 30)
        let barButton2 = UIBarButtonItem.init(customView: button2)
        self.navigationItem.rightBarButtonItems = [barButton2]
    }
    
    
    
    
    @objc func openPopUp(_ sender:UIButton) {
        print("some")
        print(sender.tag)
        let popupViewControllerIdentifier = "searchPopUp"
        let main = UIStoryboard(name: "Main", bundle: nil)
        let controller = main.instantiateViewController(withIdentifier: "VCDisableActiveAgent") as! VCDisableActiveAgent
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overFullScreen
        
        controller.delegate = self
        
        
        self.present(controller, animated: false, completion: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAgentsFromApi()
        self.setsocketIOS()
        isSearching = false
        
    }
    func getAgentsFromApi() {
        guard let auth = Shared.sharedInfo.userModel.data?.authorization else {return}
        
        
        
        LoaderManager.show(self.view, message: "Please Wait")
        ApiManager.shared.getAgents(companyId: "some", page: "1", auth: auth, success: { agentList in
            LoaderManager.hide(self.view)
            self.agentsArray = (agentList.data?.agents)!
            self.agentListingTableView.reloadData()
            
        }, failure: {
            error in
        })
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender:sender)
        if let ctrl = segue.destination as? agentProfileForAdminViewController {
            if(isSearching){
                
                if let index = sender as? Int {
                    
                    ctrl.Agent = agentsSearchArray[index]
                    ctrl.delegate = self
                }
            }else{
                if let index = sender as? Int {
                    
                    ctrl.Agent = agentsArray[index]
                    ctrl.delegate = self
                }
            }
            
            
            
        }
    }
    
    func setsocketIOS(){
        
        
        
        guard let userToken = Shared.sharedInfo.userModel.data?.authorization else {return}
        
        
        
        
        // let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String
        
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
        
        
        self.socket.on("newNotification") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            self.socket.emit("unseenNotifications")
            
        }
        
        
        
        
        
        
        
        
        
        
        self.socket.on(clientEvent: .connect) {data, emitter in
            // handle connected
            //                self.socket.emit("newsFeed")
            //                self.socket.emit("popularBroadcasts")
            self.socket.emit("unseenNotifications")
            
            
            
            
        }
        
        
        
        
        
        //        self.socket.on("agentChanged") { (data,ack) in
        //            let modified =  (data[0] as AnyObject)
        //
        //
        //            let dictionary = modified as! [String: AnyObject]
        //            print(dictionary)
        //
        //            let swiftY = JSON(modified)
        //
        //            print(swiftY["success"].bool)
        //
        //            print(swiftY["data"]["isActive"].string!)
        //
        //            let a = swiftY["data"]["isActive"].string!
        //            if a == "false" {
        //                let alertController = UIAlertController(title: "Error", message: "your account is disabled by Admin", preferredStyle: .alert)
        //
        //                // Create the actions
        //                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
        //                    UIAlertAction in
        //                    self.performSegue(withIdentifier: "logOutt", sender: self)
        //                }
        //                // Add the actions
        //                alertController.addAction(okAction)
        //                //alertController.addAction(cancelAction)
        //
        //                // Present the controller
        //                self.present(alertController, animated: true, completion: nil)
        //            }
        //
        //        }
        
        //        self.socket.on("agentDeleted") { (data,ack) in
        //            let modified =  (data[0] as AnyObject)
        //
        //            let dictionary = modified as! [String: AnyObject]
        //            print(dictionary)
        //
        //            let swiftY = JSON(modified)
        //
        //            print(swiftY["success"].bool)
        //
        //            print(swiftY["data"]["isLoggedIn"].string!)
        //
        //            let a = swiftY["data"]["isLoggedIn"].string!
        //            if a == "false" {
        //                let alertController = UIAlertController(title: "Error", message: "your account is disabled by Admin", preferredStyle: .alert)
        //
        //                // Create the actions
        //                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
        //                    UIAlertAction in
        //                    self.performSegue(withIdentifier: "logOutt", sender: self)
        //                }
        //                // Add the actions
        //                alertController.addAction(okAction)
        //                //alertController.addAction(cancelAction)
        //
        //                // Present the controller
        //                self.present(alertController, animated: true, completion: nil)
        //            }
        //        }
        
        //        self.socket.on("agentStatus") { (data,ack) in
        //            let modified =  (data[0] as AnyObject)
        //
        //            let dictionary = modified as! [String: AnyObject]
        //            print(dictionary)
        //
        //            let swiftY = JSON(modified)
        //
        //            print(swiftY["success"].bool)
        //
        //            print(swiftY["data"]["isLoggedIn"].string!)
        //
        //            let a = swiftY["data"]["isLoggedIn"].string!
        //            if a == "false" {
        //
        //            }
        //
        //        }
        
        self.socket.on("companyLoggedIn") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            //self.isLoggedInArray.removeAll()
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            
            
            
        }
        
        self.socket.on("agentLoggedIn") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            
            let swiftY = JSON(modified)
            
            print(swiftY["success"].bool)
            
            print(swiftY["data"].string)
            //self.isLoggedInArray.removeAll()
            //self.getAgentsFromApi()
            
            //            let a = swiftY["data"] as! AgentListingAgents
            //            self.isLoggedInArray.append(a)
            
            //            if let user = Mapper<AgentListingAgents>().map(JSONObject:modified) {
            //                                //print(user.message)
            //                       print(user)
            //                               //self.isLoggedInArray.append(user)
            //                                //return
            //                            }
            //
            
            
            //self.activeAgentsCollectionView.reloadData()
            
            //            LoaderManager.hide(self.view)
            //            let modified =  (data[0] as AnyObject)
            //
            //            // let dictionary = modified as! [String: AnyObject]
            //            //print(dictionary)
            //
            //            let swiftY = JSON(modified)
            //            print(swiftY["success"].stringValue)
            //            if let user = Mapper<NotificationMain>().map(JSONObject:modified) {
            //                print(user.message)
            //                self.notificationObj = user
            //                self.notificationArray = (self.notificationObj?.data?.notifications)!
            //                self.seenArray()
            //                print(self.notificationArray.count)
            //                //return
            //            }
            //            self.notificationsTableView.delegate = self
            //            self.notificationsTableView.dataSource = self
            //
            //            self.notificationsTableView.reloadData()
            //
            //            //self.notificationsTableView.reloadData()
            
            
            
        }
        
        self.socket.on("companyLoggedOut") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            
            
            
        }
        
        
        
        self.socket.on("companyStatus") { (data,ack) in
            let modified =  (data[0] as AnyObject)
            
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            
            let swiftY = JSON(modified)
            
            print(swiftY["success"].bool)
            
            print(swiftY["data"]["isActive"].int!)
            
            let a = swiftY["data"]["isActive"].int!
            if a == 0 {
                let alertController = UIAlertController(title: "Error", message: "your Account is disabled by Admin", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.performSegue(withIdentifier: "logOutt", sender: self)
                }
                // Add the actions
                alertController.addAction(okAction)
                //alertController.addAction(cancelAction)
                
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            print(agentsSearchArray.count)
           return agentsSearchArray.count
        }else
        {
           return agentsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "agents", for: indexPath) as! AgentsListingTableViewCell
        
        if isSearching {
            
        cell.nameLbl.text = agentsSearchArray[indexPath.row].fullName
        cell.emailLbl.text = agentsSearchArray[indexPath.row].email
        
        if agentsSearchArray[indexPath.row].isActive == 1 {
            cell.statusLabel.text = "Active".localized
        }
        else {
            cell.statusLabel.text = "Disable".localized
        }
        cell.profileImage.image = nil
        let imageUrl = agentsSearchArray[indexPath.row].image
        print(imageUrl!)
        let url = URL(string: imageUrl!)
       cell.profileImage.af_setImage(withURL: url!)
            
    }else{
            cell.nameLbl.text = agentsArray[indexPath.row].fullName
            cell.emailLbl.text = agentsArray[indexPath.row].email
            
            if agentsArray[indexPath.row].isActive == 1 {
                cell.statusLabel.text = "Active".localized
            }
            else {
                cell.statusLabel.text = "Disable".localized
            }
            
            cell.profileImage.image = nil
            let imageUrl = agentsArray[indexPath.row].image
            print(imageUrl!)
            let url = URL(string: imageUrl!)
            //  print(url!)
            cell.profileImage.af_setImage(withURL: url!)
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
       
        
//            let destinationVC = agentProfileForAdminViewController()
//            destinationVC.sharedIndex = indexPath.row
//            destinationVC.performSegue(withIdentifier: "profile", sender: self)
       
           self.performSegue(withIdentifier: "profile", sender: indexPath.row)
    }
    
    
    
    

}
extension AgentsListingViewController: agentProfileDelegate
{
    func ReloadApiCall() {
        agentListingTableView.reloadData()
    }
    
    func deleteProfile(userID: String) {
//        for (index, item) in agentsArray.enumerated()
//        {
//            if(userID == item._id)
//            {
//                agentsArray.remove(at: index)
//                break
//            }
//        }
        agentListingTableView.reloadData()
    }
    
    
}


extension AgentsListingViewController: SearchDiableActiveAgentDelegate {
    
    
    func SearchBtnClicked(name: String?, status: String?) {
        print(name,status)
        
        var searchText = ""
        
        print(status!)
        isSearching = false
        
        if (name?.isNotEmpty)! {
            searchText = name!
            isSearching = true
            type = "name"
        }
        else if status! == "Active" {
            //status = "pending"
            searchText = "1"
            print(searchText)
            isSearching = true
            type = "isActive"
        }
        else if status! == "Disabled" {
            searchText = "0"
            isSearching = true
            type = "Disabled"
        }
        
        filterdData = searchText
        //isSearching = true
        agentListingTableView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func didCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    func didSelectSearchBtn(name: String?, carNumber: String?, status: String?) {
       
        
    }
    
    
}
