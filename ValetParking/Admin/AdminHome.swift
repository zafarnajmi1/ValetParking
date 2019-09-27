//
//  AdminHome.swift
//  ValetParking
//
//  Created by Zafar Najmi on 16/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
import SocketIO
import Starscream
import SwiftyJSON
import ObjectMapper
//false

class AdminHome: UIViewController, UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,agentProfileDelegate{
    
    
    @IBOutlet var lblNodata: UILabel!
    
    
    @IBOutlet var carCountLbl: UILabel!
    
     let lang = UserDefaults.standard.string(forKey:"i18n_language")
    
    @IBOutlet var activeAgentsCollectionView: UICollectionView!
    
    var agentsArray = [AgentListingAgents]()
    var navColor = UIColor(red: 38/255, green: 74/255, blue: 254/255, alpha: 1.0)

    @IBOutlet var carListingNewTableView: UITableView!
    @IBOutlet weak var addaagents: UIButton!
    
    @IBOutlet var currentlyParked: UILabel!
    @IBOutlet weak var DisableAgent: UIButton!
    
    @IBOutlet var titleDescriptionLbl: UILabel!
    @IBOutlet var ActiveAgentsLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    
    var isSearching = false
      var type = ""
    
    //var carArray = [Cars]()
    
    var checkActiveAgent : Bool = true
    var carCount = 0
    var pageCount = 1
    var cars = GetCars()
    var carArray = [Cars]()
    var manager:SocketManager!
    var socket:SocketIOClient!
    var isLogged = false
    var isLoggedInArray = [AgentListingAgents]()
    var uniqueMessages = [AgentListingAgents]()

    var carSearchArray = [Cars]()
    var filterdData = "" {
        didSet {
            //filterdData = cities.filter({$})
            print(filterdData)
            carSearchArray = carArray.filter({ (cars) -> Bool in
                print(filterdData)
                print(cars.status!)
                
                if type == "name" {
                   return (cars.userName?.lowercased().contains(st: filterdData.lowercased()))!
                }
                else if type == "car" {
                    return (cars.carNumber?.contains(st: filterdData))!
                }
                else {
                    return (cars.status?.contains(st: filterdData))!
                }
                
            })
           // myTableView.reloadData()
           // carListingNewTableView.reloadData()
        }
    }
    
    
    var Notificationbtn: MIBadgeButton?
    var Count = ""
    
    @IBOutlet var carsCount: UILabel!
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightBarButton()
       
        
        
        
        //getAgentsFromApi()
        carsCount.text = "\(carCount)Cars".localized
        currentlyParked.text = "Currently Parked Cars".localized
        addaagents.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        addaagents.setTitle("Add Valet".localized, for: .normal)
        titleDescriptionLbl.text = "What would you like to do?".localized
        DisableAgent.setTitle("Disable Valet".localized, for: .normal)
        titleLabel.text = Shared.sharedInfo.userModel.data?.fullName?.localized
        
        carListingNewTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        ActiveAgentsLabel.text = "Online Valet".localized
       self.setNavigationBar()
       // self.addMenu()
//        self.addaagents.ButtonDesign()
//        self.DisableAgent.ButtonDesign()
        
        
        
        
    }
    
    func setNavigationBar(){
        let headerImage = #imageLiteral(resourceName: "Bg 2")
        // self.navigationController?.navigationBar.setBackgroundImage(headerImage, for:.default)
        self.title = "Valet Parking"
        //let color: UIColor = navColor
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //self.navigationController!.navigationBar.barTintColor = color
        self.navigationController!.navigationBar.barStyle = .blackOpaque
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addaagents.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        if(checkActiveAgent == true)
        {
            self.getAgentsFromApi()
            self.setsocketIOS()
            carListingNewTableView.reloadData() //menow
            activeAgentsCollectionView.reloadData() //menow
        }
        else{
            checkActiveAgent = true
        }
        
        
        
        
        
        self.addMenu()
         print (carSearchArray.count)
        isSearching = false
        self.ApiCall()
        
        
        
        
        titleLabel.text = "Hey, " + (Shared.sharedInfo.userModel.data?.fullName)! + "!"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let ctrl = segue.destination as? CarDetailVC {
            
            if(isSearching)
            {
            if let index = sender as? Int {
                
                print(index)
                ctrl.car = carSearchArray[index]
            }
            }else
            {
                if let index = sender as? Int {
                    
                    print(index)
                    ctrl.car = carArray[index]
                }
            }
            
            
            
        }
        
        
    }
    
//    func setNavigationBar(){
//        self.title = "Valet Parking"
//        let color: UIColor = navColor
//        self.navigationController!.navigationBar.isTranslucent = false
//        self.navigationController!.navigationBar.tintColor = UIColor.white
//        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Poppins", size: 20)!]
//        self.navigationController!.navigationBar.barTintColor = color
//        self.navigationController!.navigationBar.barStyle = .blackOpaque
//    }
    
    func ApiCall() {
        print("adfdsaf")
        
        
        guard let auth = Shared.sharedInfo.userModel.data?.authorization else {return}
        guard let company = Shared.sharedInfo.userModel.data?._id else {return}
        
        print(auth)
        print(company)
        
        let page = String(1)
        
        LoaderManager.show(self.view, message: "Please wait")
        ApiManager.shared.getCars(companyId: company, page:page, auth:auth, success: { cars in
            LoaderManager.hide(self.view)
            print(cars.message?.en)
            self.cars = cars
            self.carArray = (cars.data?.cars!)!
            
            let car = String(self.carArray.count)
            self.carCountLbl.text = car + " Cars".localized
            
             self.carListingNewTableView.reloadData()
            
           
            
        }, failure: {error in
            print(error)
            return
        })
    }
    
    func ApiSocketCall() {
        print("adfdsaf")
        
        
        guard let auth = Shared.sharedInfo.userModel.data?.authorization else {return}
        guard let company = Shared.sharedInfo.userModel.data?._id else {return}
        
        print(auth)
        print(company)
        
        let page = String(1)
        
       // LoaderManager.show(self.view, message: "Please wait")
        ApiManager.shared.getCars(companyId: company, page:page, auth:auth, success: { cars in
            //LoaderManager.hide(self.view)
            print(cars.message?.en)
            self.cars = cars
            self.carArray = (cars.data?.cars!)!
            let car = String(self.carArray.count)
            self.carCountLbl.text = car + " Cars".localized
            
            self.carListingNewTableView.reloadData()
            
            
            
        }, failure: {error in
            print(error)
            return
        })
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if carArray[indexPath.row].status! == "inprogress" {
//             cell.backgroundColor = UIColor.blue
//            print(carArray[indexPath.row].status!)
//        }
        
        let data = tableView.dequeueReusableCell(withIdentifier: "ReleaseCar") as! ReleaseCar
        
//        data.cellOuterView.backgroundColor = Colors.white
//       data.backgroundColor = UIColor.clear
        
        
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = Colors.white
//        data.selectedBackgroundView = backgroundView
        
        
        
        guard let page = cars.data?.pagination?.page else {return }
        guard let pages = cars.data?.pagination?.pages else {return }
        
        
        
        
        
//        guard carArray.count<pager else {
//
//            if indexPath.row == carArray.count - 1  {
//
//               MoreApiCall()
//            }
//            else {
//                return
//            }
//            return
//        }
    }
    
    func MoreApiCall(_ page:Int) {
        
        
        
        guard let auth = Shared.sharedInfo.userModel.data?.authorization else {return}
        guard let company = Shared.sharedInfo.userModel.data?._id else {return}
        
        
        
        pageCount += 1
        let page = String(pageCount)
       
        LoaderManager.show(self.view, message: "Please wait")
        ApiManager.shared.getCars(companyId: company, page:page, auth:auth, success: { cars in
            LoaderManager.hide(self.view)
            print(cars.message?.en)
            self.carArray += (cars.data?.cars!)!
            
            
            self.carListingNewTableView.reloadData()
            
        }, failure: {error in
            
            print(error)
            return
        })
    }
    
    let buttonLeftMenu = UIButton (type: .custom)
    func addMenu() {
        let imageLeftmenu = UIImage (named: "Menu")
        let tintedLeftImage = imageLeftmenu?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        buttonLeftMenu.setImage(tintedLeftImage, for: .normal)
        buttonLeftMenu.tintColor = UIColor.white
        buttonLeftMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        buttonLeftMenu.addTarget(self, action: #selector(actionLeftMenu(_:)), for: .touchUpInside)
        let item = UIBarButtonItem(customView: buttonLeftMenu)
        
        self.navigationItem.setLeftBarButton(item, animated: true)
        

        
    }
    
    @objc func actionLeftMenu (_ sender: Any){
        print ("Menu Button")
        
        
       // self.toggleLeft()
        //self.toggleRight()
        
        if lang == "en" {
            //UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.toggleLeft()
        }else {
            //UIView.appearance().semanticContentAttribute = .forceRightToLeft
            self.toggleRight()

        }
        
        //AppDelegate.appDelegate.moveToAdmin()
        
    }
    
    @objc func notification_message(_ sender: Any)
    {
        self.performSegue(withIdentifier: "bell", sender: sender)
    }
    @IBAction func AddanAgentAction(_ sender: Any) {
        
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AgentProfile") as! AgentProfile
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
        self.performSegue(withIdentifier: "addAnAgent", sender: self)
        
    }
    
    // Marked:- Here is TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return carSearchArray.count
        }
        else {
            return carArray.count
        }
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
                let data = tableView.dequeueReusableCell(withIdentifier: "ReleaseCar") as! ReleaseCar
        
//                for car in carArray {
//                   data.carNumberLbl.text = car.carNumber
//                    data.userNamelbl.text = car.userName
//                }
//               data.carNumberLbl.text = carArray[indexPath.row].carNumber!
//               data.userNamelbl.text = carArray[indexPath.row].userName!
        data.selectionStyle = .none
        data.realseView.backgroundColor = Colors.blue
        
        if isSearching {
            
             data.CarOwner.text = carSearchArray[indexPath.row].carNumber!.localized
           data.CarNumber.text  = carSearchArray[indexPath.row].userName!.localized
            //data.releaseTitle.text = carSearchArray[indexPath.row].status!.localized
            
            if carSearchArray[indexPath.row].status! == "pending" {
                data.releaseTitle.text = "Detail".localized
                data.lblViewDetail.isHidden = true
                
            }
            else {
                data.releaseTitle.text = "In Progress".localized
                 data.lblViewDetail.isHidden = false
            }
            
            if carSearchArray[indexPath.row].status! == "inprogress" {
                 data.lblViewDetail.isHidden = false
                data.cellOuterView.backgroundColor = Colors.cellBlue
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
            }
           // return data
        }
        
        
        else {
            data.CarNumber.text = carArray[indexPath.row].carNumber!.localized
            data.CarOwner.text = carArray[indexPath.row].userName!.localized
            //data.releaseTitle.text = carArray[indexPath.row].status!.localized
            
            if carArray[indexPath.row].status! == "pending" {
                data.releaseTitle.text = "Detail".localized
                 data.lblViewDetail.isHidden = true
            }
            else {
                data.releaseTitle.text = "In Progress".localized
                 data.lblViewDetail.isHidden = false
            }
            
            if carArray[indexPath.row].status! == "inprogress" {
                 data.lblViewDetail.isHidden = false
                data.cellOuterView.backgroundColor = Colors.cellBlue
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
            }
        }
             return data
        
        
        print(carArray[indexPath.row].status!)
        //data.realseView.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        
        
        
       
        
        
        
            }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = tableView.dequeueReusableCell(withIdentifier: "ReleaseCar") as! ReleaseCar
        
        
        

        self.performSegue(withIdentifier: "CarDetail", sender: indexPath.row)
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
            self.rightBarButton()
            
            
        }
        
        self.socket.on("newNotification") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            self.socket.emit("unseenNotifications")
            
        }
        
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
            self.isLoggedInArray.removeAll()
            self.getAgentsFromApi()
            
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
        
        self.socket.on("agentLoggedOut") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            
            let swiftY = JSON(modified)
            
            //print(swiftY["data"]["email"].string)
            
            
            var email = swiftY["data"]["email"].string
           // print(email!)
            //print(self.isLoggedInArray.count)
            for i in 0 ..< self.isLoggedInArray.count {
                
                if email == self.isLoggedInArray[i].email!
               {
                self.isLoggedInArray.remove(at: i)
                }
                
                
            }
            
            self.activeAgentsCollectionView.reloadData()
            //self.isLoggedInArray.removeAll()
           // self.getAgentsFromApi()
            
            
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
    
    func rightBarButton() {
        
        let button2 = UIButton.init(type: .custom)
        button2.setImage(UIImage.init(named: "Search"), for: UIControl.State.normal)
        button2.addTarget(self, action:#selector(openPopUp(_:)), for: UIControl.Event.touchUpInside)
        button2.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25) //CGRectMake(0, 0, 30, 30)
        let barButton2 = UIBarButtonItem.init(customView: button2)
        
        
        
        Notificationbtn = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        Notificationbtn!.setImage(#imageLiteral(resourceName: "Notification"), for: .normal)
        if(Count == ""){
            Notificationbtn?.badgeString = nil
        }
        else if (Count == "0"){
            Notificationbtn?.badgeString = nil
            
        }
        else
        {
            Notificationbtn?.badgeString = Count
            
        }
        
        Notificationbtn?.addTarget(self, action:#selector(AdminHome.notification_message), for: UIControl.Event.touchUpInside)
        let notificationItem = UIBarButtonItem(customView: Notificationbtn!)
        Notificationbtn!.badgeEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        
        
        //self.navigationItem.rightBarButtonItems = [notificationItem]
        
         self.navigationItem.rightBarButtonItems = [notificationItem,barButton2]
    }
    
    @objc func openPopUp(_ sender:UIButton) {
        print("some")
        print(sender.tag)
        let popupViewControllerIdentifier = "searchPopUp"
        let main = UIStoryboard(name: "Main", bundle: nil)
        let controller = main.instantiateViewController(withIdentifier: popupViewControllerIdentifier) as! SearchPopUpViewController
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overFullScreen
        
        controller.delegate = self
        
       
        self.present(controller, animated: false, completion: nil)
        //controller.negativeText = "Save".localized
        //controller.positiveText = "Cancel".localized

//
//
//        controller.popupTitle = "Password".localized
//        //controller.popupDescription = "Enter Name Here".localized
//        //index = 0
//
//        controller.delegate = self
//        controller.identifier = sender.tag
//        //a = controller.edit.text!
//        self.present(controller, animated: false, completion: nil)
        
    }
    


        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            
                return isLoggedInArray.count
            
            
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            
                
                
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AgentsDataCell", for:
                indexPath) as! AgentsDataCell
            
            if((isLoggedInArray[indexPath.row].isLoggedIn) == "true"){
                print(isLoggedInArray[indexPath.row].isLoggedIn!)
             //menow
                cell.AgentName.text = isLoggedInArray[indexPath.row].fullName
            
               if isLoggedInArray[indexPath.row].isLoggedIn != nil
                {
                    cell.GreenDot.isHidden = false
                    cell.GreenDot.image = UIImage(named: "Green-dot")
               }else
               {
                cell.GreenDot.isHidden = true
               }
            
                if let imageUrl = isLoggedInArray[indexPath.row].image
                {
                    let url = URL(string: imageUrl)
                    
                    cell.AgentImage.af_setImage(withURL: url!)
                }
            }
            
           return cell
            
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //self.performSegue(withIdentifier: "profile", sender: indexPath.row)
        let vc = storyboard?.instantiateViewController(withIdentifier: "agentProfileForAdminViewController") as! agentProfileForAdminViewController
        vc.Agent.isActive = isLoggedInArray[indexPath.row].isActive
        vc.Agent.image = isLoggedInArray[indexPath.row].image
        vc.Agent.fullName = isLoggedInArray[indexPath.row].fullName
         vc.Agent.email = isLoggedInArray[indexPath.row].email
        vc.Agent.phone = isLoggedInArray[indexPath.row].phone
        vc.Agent.address = isLoggedInArray[indexPath.row].address
        vc.Agent._id = isLoggedInArray[indexPath.row]._id
        vc.delegate =  self
        checkActiveAgent = false
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteProfile(userID: String) {
        let indexPaths = activeAgentsCollectionView!.indexPathsForSelectedItems!
        for (index, item) in isLoggedInArray.enumerated()
        {
            

            print(userID)
            if(userID == item._id)
            {
                isLoggedInArray.remove(at: index)
                break
                
            }
        }
        self.activeAgentsCollectionView.deleteItems(at: indexPaths)
        activeAgentsCollectionView.reloadData()
    }
    func ReloadApiCall() {
        
        self.getAgentsFromApi()
        carListingNewTableView.reloadData()
        activeAgentsCollectionView.reloadData()
    }
    
    func getAgentsFromApi() {
            guard let auth = Shared.sharedInfo.userModel.data?.authorization else {return}
            
            self.uniqueMessages.removeAll()
            self.isLoggedInArray.removeAll()
            self.agentsArray.removeAll()
            
            //LoaderManager.show(Admin, message: "Please Wait")
            ApiManager.shared.getAgents(companyId: "some", page: "1", auth: auth, success: { agentList in
                //LoaderManager.hide(self.view)
                
                self.agentsArray = (agentList.data?.agents)!
                print(self.agentsArray)
                print(self.agentsArray.count)
            
                var noUserOnline = true
                for agent in self.agentsArray {
                    print(agent.isLoggedIn!)
                    if agent.isLoggedIn! == "true" && agent.isActive == 1  {
                       noUserOnline = false
                       
                        self.uniqueMessages.append(agent)
                        //self.isLoggedInArray.append(agent)
                    }
                    else {
                        
//                        self.lblNodata.isHidden = false
//                        self.activeAgentsCollectionView.isHidden = true
                    }
                    
                }
                if noUserOnline {
                    self.lblNodata.isHidden = false
                    self.activeAgentsCollectionView.isHidden = true
                }
                else{
                    self.lblNodata.isHidden = true
                    self.activeAgentsCollectionView.isHidden = false
                }
                
                print(self.isLoggedInArray.count)
              self.isLoggedInArray = self.uniqueMessages.unique{$0.email ?? ""}
                
                print(self.isLoggedInArray.count)
                
 
                self.activeAgentsCollectionView.reloadData()
                
                
                
            }, failure: {
                error in
            })
        }
        
}
        
    



extension AdminHome: SearchPopUpViewControllerDelegate {
    
    func didSelectCancelBtn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didSelectSearchBtn(name: String?, carNumber: String?, status: String?) {
        print(name,carNumber,status)
        
        var searchText = ""
        
        
        
            
            print(status!)
            isSearching = false
        
        if (name?.isNotEmpty)! {
            searchText = name!
            isSearching = true
            type = "name"
        }
        
        else if (carNumber?.isNotEmpty)! {
            searchText = carNumber!
            isSearching = true
            type = "car"
        }
        
        else if status! == "Release" {
            //status = "pending"
            searchText = "pending"
            print(searchText)
            isSearching = true
            type = "status"
        }
        else if status! == "In Progress" {
            searchText = "inprogress"
            isSearching = true
            type = "status"
        }
        
        
        
            
            filterdData = searchText
            //isSearching = true
           self.carListingNewTableView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
        
        
        
        
    }
    
    
}
    //extension AgentsCollectionView: UICollectionViewDelegateFlowLayout {
    //
    //    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        return CGSize(width: collectionView.frame.size.width/8.0 - 5 , height: collectionView.frame.size.width/8.0 - 5)
    //    }
    //}

    

//class AgentsCollectionView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource {
//
//
//
//    var agentsArray = [AgentListingAgents]()
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.delegate = self
//        self.dataSource = self
//    }
//
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return agentsArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AgentsDataCell", for:
//            indexPath) as! AgentsDataCell
//
//        cell.AgentName.text = agentsArray[indexPath.row].fullName
//        if let imageUrl = agentsArray[indexPath.row].image
//        {
//            let url = URL(string: imageUrl)
//            cell.AgentImage.af_setImage(withURL: url!)
//        }
//
//        return cell
//    }
//
//    func getAgentsFromApi() {
//        guard let auth = Shared.sharedInfo.userModel.data?.authorization else {return}
//
//
//
//        //LoaderManager.show(Admin, message: "Please Wait")
//        ApiManager.shared.getAgents(companyId: "some", page: "1", auth: auth, success: { agentList in
//            //LoaderManager.hide(self.view)
//            self.agentsArray = (agentList.data?.agents)!
//            //self.agentListingTableView.reloadData()
//
//
//        }, failure: {
//            error in
//        })
//    }
//
//
//
//}
////extension AgentsCollectionView: UICollectionViewDelegateFlowLayout {
////
////    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
////
////        return CGSize(width: collectionView.frame.size.width/8.0 - 5 , height: collectionView.frame.size.width/8.0 - 5)
////    }
////}



extension AdminHome: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 120)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}




