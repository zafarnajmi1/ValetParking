//
//  ReleaseCarListingViewController.swift
//  ValetParking
//
//  Created by My Technology on 24/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//


import UIKit
import SocketIO
import Starscream
import SwiftyJSON
import MIBadgeButton_Swift



class ReleaseCarListingViewController: UIViewController {
    
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var Parkacar: UIButton!
    
    //@IBOutlet var clView: AgentsCollectionView!
    @IBOutlet var carListingTableView: UITableView!
    @IBOutlet weak var ReleaseaCar: UIButton!
    @IBOutlet weak var NumberOfCars: UILabel!
    
    var cars = GetCars()
    var carArray = [Cars]()
    var index:String?
    var manager:SocketManager!
    var socket:SocketIOClient!
    
    var Notificationbtn: MIBadgeButton?
    var Count = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var navColor = UIColor(red: 38/255, green: 74/255, blue: 254/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiCall()
        carListingTableView.isHidden = true
        carListingTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        //Parkacar.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        
        var colors = [UIColor]()
        colors.append(Colors.Mediumblue)
        colors.append(Colors.blue)
        self.navigationController?.navigationBar.setGradientBackground(colors: colors)
        
        
        //UserName.text = Shared.sharedInfo.userModel.data?.fullName
        
        //self.navigationController!.viewControllers.removeAll()
        //self.setNavigationBar()
        self.addMenu()
        //        self.ReleaseaCar.ButtonDesign()
        //        self.Parkacar.ButtonDesign()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Release A Car".localized
        //UserName.text = Shared.sharedInfo.userModel.data?.fullName
        ApiCall()
        setsocketIOS()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let ctrl = segue.destination as? CarDetailVC {
            if let index = sender as? Int {
                
                print(index)
                ctrl.car = carArray[index]
            }
            
            
            
            
        }
    }
//    func rightBarButton() {
//        Notificationbtn = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        Notificationbtn!.setImage(#imageLiteral(resourceName: "Notification"), for: .normal)
//        if(Count == ""){
//            Notificationbtn?.badgeString = nil
//        }
//        else if (Count == "0"){
//            Notificationbtn?.badgeString = nil
//
//        }
//        else
//        {
//            Notificationbtn?.badgeString = Count
//
//        }
//
//        Notificationbtn?.addTarget(self, action:#selector(AdminHome.notification_message), for: UIControlEvents.touchUpInside)
//        let notificationItem = UIBarButtonItem(customView: Notificationbtn!)
//        Notificationbtn!.badgeEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0)
//
//
//        self.navigationItem.rightBarButtonItems = [notificationItem]
//    }
    
    func setNavigationBar(){
        self.title = "Valet Parking"
        let color: UIColor = navColor
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Poppins", size: 20)!]
        self.navigationController!.navigationBar.barTintColor = color
        self.navigationController!.navigationBar.barStyle = .blackOpaque
    }
    
    //let buttonLeftMenu = UIButton (type: .custom)
    
    func addMenu()
    {
//        let buttonLeftMenu = UIButton (type: .custom)
//        let imageLeftmenu = UIImage (named: "Menu")
//        let tintedLeftImage = imageLeftmenu?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        buttonLeftMenu.setImage(tintedLeftImage, for: .normal)
//        buttonLeftMenu.tintColor = UIColor.white
//        buttonLeftMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        buttonLeftMenu.addTarget(self, action: #selector(actionLeftMenu(_:)), for: .touchUpInside)
//        let item = UIBarButtonItem(customView: buttonLeftMenu)
//        self.navigationItem.setLeftBarButton(item, animated: true)
        
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
        
        
        //rightBarButton()
        
        //        let bell_button = UIButton(type: .system)
        //        //bell_button.setImage(#imageLiteral(resourceName: "Notification"), for: .normal)
        //        bell_button.setImage(#imageLiteral(resourceName: "Notification").withRenderingMode(.alwaysOriginal), for: .normal)
        //        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        //        bell_button.addTarget(self, action: #selector( notification_message(_:)), for: .touchUpInside)
        //
        //        navigationItem.rightBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
    }
    
    @objc func actionLeftMenu (_ sender: Any)
    {
        self.toggleLeft()
    }
    
    @objc func notification_message(_ sender: Any)
    {
       // self.performSegue(withIdentifier: "bell", sender: sender)
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ParkacarAction(_ sender: Any) {
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParkedCarInfo") as! ParkedCarInfo
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func ReleaseParkedCar(_ sender: Any)
    {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "CarDetailVC") as! CarDetailVC
        //         self.navigationController?.pushViewController(vc, animated:true)
        
        
    }
    func ApiCall() {
        print("adfdsaf")
        
        
        guard let auth = Shared.sharedInfo.userModel.data?.authorization else {return}
        guard let companyId = Shared.sharedInfo.userModel.data?.company else  {return}
        
        print(auth)
        print(companyId)
        LoaderManager.show(self.view, message: "Please wait")
        ApiManager.shared.getCars(companyId: companyId, page: "1", auth:auth, success: { cars in
            LoaderManager.hide(self.view)
            self.carListingTableView.isHidden = false
            self.carArray = (cars.data?.cars!)!
            
            
            self.carListingTableView.reloadData()
            
        }, failure: {error in
            print(error)
            return
        })
    }
    
    func ApiSocketCall() {
        print("adfdsaf")
        
        
        guard let auth = Shared.sharedInfo.userModel.data?.authorization else {return}
        guard let companyId = Shared.sharedInfo.userModel.data?.company else  {return}
        
        print(auth)
        print(companyId)
        
        ApiManager.shared.getCars(companyId: companyId, page: "1", auth:auth, success: { cars in
            
            self.carArray = (cars.data?.cars!)!
            
            
            self.carListingTableView.reloadData()
            
        }, failure: {error in
            print(error)
            return
        })
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
        self.socket.on("unseenNotifications") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            let NotificationCount = NotificationCountModel.init(dictionary: dictionary as NSDictionary)
            
            
            self.Count = "\(String(describing: NotificationCount!.data!.unseenNotificationsCount!))"
            //self.rightBarButton()
            
            
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
        
        
        
        
        
        self.socket.on("agentChanged") { (data,ack) in
            let modified =  (data[0] as AnyObject)
            
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            
            let swiftY = JSON(modified)
            
            print(swiftY["success"].bool)
            
            print(swiftY["data"]["isActive"].string!)
            
            let a = swiftY["data"]["isActive"].string!
            if a == "false" {
                let alertController = UIAlertController(title: "Error", message: "your account is disabled by Admin", preferredStyle: .alert)
                
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
        
        self.socket.on("agentDeleted") { (data,ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            
            let swiftY = JSON(modified)
            
            print(swiftY["success"].bool)
            
            print(swiftY["data"]["isLoggedIn"].string!)
            
            let a = swiftY["data"]["isLoggedIn"].string!
            if a == "false" {
                let alertController = UIAlertController(title: "Error", message: "your account is disabled by Admin", preferredStyle: .alert)
                
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
        
        self.socket.on("agentStatus") { (data,ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            
            let swiftY = JSON(modified)
            
            print(swiftY["success"].bool)
            
            print(swiftY["data"]["isActive"].int!)
            
            let a = swiftY["data"]["isActive"].int!
            if a == 0 {
                let alertController = UIAlertController(title: "Error", message: "your account is disabled by Admin", preferredStyle: .alert)
                
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
        
        //        self.socket.on("companyLoggedIn") { (data, ack) in
        //            let modified =  (data[0] as AnyObject)
        //
        //            let dictionary = modified as! [String: AnyObject]
        //            print(dictionary)
        //
        //
        //
        //        }
        
        self.socket.on("carAdded") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            
            self.ApiSocketCall()
            
            
            
        }
        
        self.socket.on("carUpdated") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            self.ApiSocketCall()
            
            
        }
        self.socket.on("carInProgress") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            self.ApiSocketCall()
            
            
        }
        self.socket.on("carDelivered") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            self.ApiSocketCall()
            
            
        }
        
        //        self.socket.on("agentLoggedIn") { (data, ack) in
        //            let modified =  (data[0] as AnyObject)
        //
        //            let dictionary = modified as! [String: AnyObject]
        //            print(dictionary)
        //
        //            let swiftY = JSON(modified)
        //
        //            print(swiftY["success"].bool)
        //
        //            print(swiftY["data"].string)
        //
        //            //            let a = swiftY["data"] as! AgentListingAgents
        //            //            self.isLoggedInArray.append(a)
        //
        //            if let user = Mapper<AgentListingAgents>().map(JSONObject:modified) {
        //                //print(user.message)
        //                print(user)
        //                //self.isLoggedInArray.append(user)
        //                //return
        //            }
        //
        //
        //            self.activeAgentsCollectionView.reloadData()
        //
        //            //            LoaderManager.hide(self.view)
        //            //            let modified =  (data[0] as AnyObject)
        //            //
        //            //            // let dictionary = modified as! [String: AnyObject]
        //            //            //print(dictionary)
        //            //
        //            //            let swiftY = JSON(modified)
        //            //            print(swiftY["success"].stringValue)
        //            //            if let user = Mapper<NotificationMain>().map(JSONObject:modified) {
        //            //                print(user.message)
        //            //                self.notificationObj = user
        //            //                self.notificationArray = (self.notificationObj?.data?.notifications)!
        //            //                self.seenArray()
        //            //                print(self.notificationArray.count)
        //            //                //return
        //            //            }
        //            //            self.notificationsTableView.delegate = self
        //            //            self.notificationsTableView.dataSource = self
        //            //
        //            //            self.notificationsTableView.reloadData()
        //            //
        //            //            //self.notificationsTableView.reloadData()
        //
        //
        //
        //        }
        //
        //        self.socket.on("companyLoggedOut") { (data, ack) in
        //            let modified =  (data[0] as AnyObject)
        //
        //            let dictionary = modified as! [String: AnyObject]
        //            print(dictionary)
        //
        //
        //
        //        }
        
        //        self.socket.on("agentLoggedOut") { (data, ack) in
        //            let modified =  (data[0] as AnyObject)
        //
        //            let dictionary = modified as! [String: AnyObject]
        //            print(dictionary)
        //
        //
        //
        //        }
        
        
        
        
        
        
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

extension ReleaseCarListingViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = tableView.dequeueReusableCell(withIdentifier: "ReleaseCar") as! ReleaseCar
        //data.selectionStyle = .none
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.blue
        data.selectedBackgroundView = bgColorView
        
        
        
        data.selectionStyle = .none
        data.CarNumber.text = carArray[indexPath.row].userName!
        data.CarOwner.text = carArray[indexPath.row].carNumber!
        // data.Release.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        //data.releaseTitle.text = carArray[indexPath.row].status!.localized
        
        if carArray[indexPath.row].status! == "pending" {
            data.releaseTitle.text = "Release".localized
        }
        else {
            data.releaseTitle.text = "In Progress".localized
        }
        
        if carArray[indexPath.row].status! == "inprogress" {
            data.cellOuterView.backgroundColor = Colors.blue
            data.CarNumber.textColor = Colors.white
            data.CarOwner.textColor = Colors.white
            data.realseView.backgroundColor = Colors.white
            data.releaseTitle.textColor = Colors.black
            
            
        }
        else {
            data.cellOuterView.backgroundColor = Colors.white
            data.CarNumber.textColor = Colors.black
            data.CarOwner.textColor = Colors.black
            data.releaseTitle.textColor = Colors.white
            data.realseView.backgroundColor = Colors.blue
        }
        
        
        
        return data
    }
    
}

extension ReleaseCarListingViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "CarDetail", sender: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReleaseCar") as! ReleaseCar
        //        cell.CarNumber.textColor = Colors.white
        //        cell.CarOwner.textColor = Colors.white
        //        cell.Release.backgroundColor = Colors.white
    }
}


