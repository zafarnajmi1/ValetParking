//
//  AgentHome.swift
//  ValetParking
//
//  Created by Zafar Najmi on 11/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SocketIO
import Starscream
import SwiftyJSON
import MIBadgeButton_Swift
//parkCar
class AgentHome: UIViewController {
    
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var Parkacar: UIButton!
    
    @IBOutlet var currentlyParkedLbl: UILabel!
    
    @IBOutlet var currentlyParkedCount: UILabel!
    //@IBOutlet var clView: AgentsCollectionView!
    @IBOutlet var carListingTableView: UITableView!
    @IBOutlet weak var ReleaseaCar: UIButton!
    @IBOutlet weak var NumberOfCars: UILabel!
    
    var cars = GetCars()
    var carArray = [Cars]()
    var index:String?
    var manager:SocketManager!
    var socket:SocketIOClient!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var isSearching = false
    var type = ""
    
    var carSearchArray = [Cars]()
    var filterdData = "" {
        didSet {
            //filterdData = cities.filter({$})
            //print(filterdData)
            
            carSearchArray = carArray.filter({ (cars) -> Bool in
                print(filterdData)
                print(cars.status!)
                
                if type == "name" {
                    return (cars.userName?.contains(st: filterdData))!
                }
                else if type == "car" {
                    return (cars.carNumber?.contains(st: filterdData))!
                }
                else {
                    return (cars.status?.contains(st: filterdData))!
                }
                
            })
            
        }
    }
    
    var Notificationbtn: MIBadgeButton?
    var Count = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var navColor = UIColor(red: 38/255, green: 74/255, blue: 254/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rightBarButton()
        
        //self.addMenu()
        ApiCall()
        carListingTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        Parkacar.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        
        var colors = [UIColor]()
        colors.append(Colors.Mediumblue)
        colors.append(Colors.blue)
        //self.navigationController?.navigationBar.setGradientBackground(colors: colors)
        self.title = "Valet Parking"
        
        UserName.text = "Hey, " + (Shared.sharedInfo.userModel.data?.fullName)! + "!"
        
        //self.navigationController!.viewControllers.removeAll()
   //self.setNavigationBar()
        
//        self.ReleaseaCar.ButtonDesign()
//        self.Parkacar.ButtonDesign()
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     print(lang)
        
    self.addMenu()
        
        
        Parkacar.setTitle("Park A Car".localized, for: .normal)
        ReleaseaCar.setTitle("Release A Car".localized, for: .normal)
        
        UserName.text = "Hey, " + (Shared.sharedInfo.userModel.data?.fullName)! + "!"
        ApiCall()
        setsocketIOS()
        currentlyParkedLbl.text = "Currently Parked Cars".localized
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated:true)
        //self.title = "Login or Create Account".localized
        setNavigationBar()
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let ctrl = segue.destination as? CarDetailVC {
            if let index = sender as? Int {
                
                print(index)
                ctrl.car = carArray[index]
            }
            
           
            
            
        }
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
        
        Notificationbtn?.addTarget(self, action:#selector(AgentHome.notification_message), for: UIControl.Event.touchUpInside)
        let notificationItem = UIBarButtonItem(customView: Notificationbtn!)
        Notificationbtn!.badgeEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        
        
        //self.navigationItem.rightBarButtonItems = [notificationItem]
        
        self.navigationItem.rightBarButtonItems = [notificationItem,barButton2]
    }
    
//    func setNavigationBar(){
//         self.title = "Valet Parking"
//        let color: UIColor = navColor
//        self.navigationController!.navigationBar.isTranslucent = false
//        self.navigationController!.navigationBar.tintColor = UIColor.white
//        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//       //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Poppins", size: 20)!]
//        self.navigationController!.navigationBar.barTintColor = color
//        self.navigationController!.navigationBar.barStyle = .blackOpaque
//    }
    
    //let buttonLeftMenu = UIButton (type: .custom)
    
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
    
    @IBAction func ParkacarAction(_ sender: Any) {

        guard let isActive = Shared.sharedInfo.userModel.data?.isCompanyActive else {return}
        
        if isActive == 0 {
            ErrorReporting.showMessage(title: "Error", msg: "your Company is disabled by SuperAdmin")
        }
        else {
            self.performSegue(withIdentifier: "parkCar", sender: self)
        }
        
        
        
        
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
            self.carArray = (cars.data?.cars!)!
            
            let car = String(self.carArray.count)
            //self.carCountLbl.text = car + " Cars".localized
            
            self.currentlyParkedCount.text = car + " Cars".localized
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
            
           // print(swiftY["success"].bool)
            
            //print(swiftY["data"]["isActive"].string!)
            
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
        
        self.socket.on("companyStatus") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            
            let swiftY = JSON(modified)
             print(swiftY["data"]["isActive"].int!)
            Shared.sharedInfo.userModel.data?.isCompanyActive = swiftY["data"]["isActive"].int!
            
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

extension AgentHome:UITableViewDataSource {
    
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
             data.CarNumber.text = carSearchArray[indexPath.row].userName!.localized
            //data.releaseTitle.text = carSearchArray[indexPath.row].status!.localized
            
            if carSearchArray[indexPath.row].status! == "pending" {
                data.releaseTitle.text = "Release".localized
            }
            else {
                data.releaseTitle.text = "In Progress".localized
            }
            
            if carSearchArray[indexPath.row].status! == "inprogress" {
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
             data.CarOwner.text = carArray[indexPath.row].carNumber!.localized
            data.CarNumber.text = carArray[indexPath.row].userName!.localized
            //data.releaseTitle.text = carArray[indexPath.row].status!.localized
            
            if carArray[indexPath.row].status! == "pending" {
                data.releaseTitle.text = "Release".localized
            }
            else {
                data.releaseTitle.text = "In Progress".localized
            }
            
            if carArray[indexPath.row].status! == "inprogress" {
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
        
    }
    
}

extension AgentHome:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "CarDetail", sender: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReleaseCar") as! ReleaseCar
//        cell.CarNumber.textColor = Colors.white
//        cell.CarOwner.textColor = Colors.white
//        cell.Release.backgroundColor = Colors.white
    }
}


extension AgentHome: SearchPopUpViewControllerDelegate {
    
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
        self.carListingTableView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
        
        
        
        
    }
    
    
}







