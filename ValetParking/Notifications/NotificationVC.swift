//
//  NotificationVC.swift
//  ValetParking
//
//  Created by Zafar Najmi on 18/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SocketIO
import Starscream
import SwiftyJSON
import ObjectMapper
import AlamofireImage
import SDWebImage
import MIBadgeButton_Swift

class NotificationVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var manager:SocketManager!
    var socket:SocketIOClient!
    var Notificationbtn: MIBadgeButton?
    var Count = ""
    
    @IBOutlet var notificationsTableView: UITableView!
    var notificationObj = NotificationMain()
    var notificationArray = [NotificationNotifications]()
    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.title = "Notifications"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let bell_button = UIButton(type: .system)
        bell_button.setImage(#imageLiteral(resourceName: "back-2").withRenderingMode(.alwaysOriginal), for: .normal)
        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        bell_button.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
        
        let deleteBtn = UIButton(type: .system)
        deleteBtn.setImage(#imageLiteral(resourceName: "Delete2").withRenderingMode(.alwaysOriginal), for: .normal)
        deleteBtn.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        deleteBtn.addTarget(self, action: #selector(removeAll), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems  = [UIBarButtonItem(customView: deleteBtn)]
        
        
        //self.setNavigationBar()
        //self.addMenu()
        LoaderManager.show(self.view)
        notificationsTableView.isHidden = true
        setsocketIOS()
        
    }
    
    @objc func removeAll() {
        
        self.removeNotificationAll()
        self.notificationArray.removeAll()
        self.notificationsTableView.reloadData()
    }
    

    @objc func back(_ sender:Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var navColor = UIColor(red: 38/255, green: 74/255, blue: 254/255, alpha: 1.0)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationDataCell
        
        
        if lang == "ar" {
            cell.notificationTitle.text = notificationArray[indexPath.row].title?.ar
            cell.notificationDescription.text = notificationArray[indexPath.row].description?.ar
        }
        else {
            cell.notificationTitle.text = notificationArray[indexPath.row].title?.en
            cell.notificationDescription.text = notificationArray[indexPath.row].description?.en
            
        }
       
        let imageUrl = notificationArray[indexPath.row].sender?.image
       
        if let url = URL(string: imageUrl!)
        {
            //print(url)
            //cell.imageView?.af_setImage(withURL: url)
            //cell.imageView?
            cell.notificationImage.sd_setImage(with: url, placeholderImage:UIImage(named: "Placeholder-3"))
            
        }
        
        let time = notificationArray[indexPath.row].createdAt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        let date = dateFormatter.date(from: time!)
        
        
        
        
        let outputFormatter =  DateFormatter()
        //outputFormatter.dateFormat = "yyyy-MM-dd"
        outputFormatter.dateFormat = "hh:mm a"
        let resultString = outputFormatter.string(from: date!)
       
        cell.timeLbl.text =  resultString
        
        cell.delteNotificationBtn.tag = indexPath.row
        cell.delteNotificationBtn.addTarget(self, action: #selector(myButtonMethod(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
  @objc func myButtonMethod(_ sender : UIButton!) {
    
       print(sender.tag)
    
    self.removeNotification(i: sender.tag)
    
    
    
    
    
       //self.dataSource.removeAtIndex(myIndex) // dataSource being your dataSource array
       // self.tableview!.reloadData()
        // you can also call this method if you want to reduce the load, will also allow you to choose an animation
        //self.tableView!.deleteRowsAtIndexPaths([NSIndexPath(forItem: myIndex, inSection: 0)], withRowAnimation: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        self.performSegue(withIdentifier: "CarDetail", sender: indexPath.row)
        Shared.sharedInfo.notificationId = (notificationArray[indexPath.row].extras?.carId!)!
        
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
        
        self.socket.on("notificationsList") { (data, ack) in
            
            LoaderManager.hide(self.view)
            self.notificationsTableView.isHidden = false
            let modified =  (data[0] as AnyObject)

          // let dictionary = modified as! [String: AnyObject]
           //print(dictionary)
            
            let swiftY = JSON(modified)
            print(swiftY["success"].stringValue)
            if let user = Mapper<NotificationMain>().map(JSONObject:modified) {
                print(user.message)
            
               self.notificationObj = user
                self.notificationArray = (self.notificationObj?.data?.notifications)!
                self.seenArray()
                print(self.notificationArray.count)
                //return
            }
            self.notificationsTableView.delegate = self
            self.notificationsTableView.dataSource = self
            
            self.notificationsTableView.reloadData()
            
            //self.notificationsTableView.reloadData()
            
            
        }
        
        self.socket.on(clientEvent: .connect) {data, emitter in
            // handle connected
            //                self.socket.emit("newsFeed")
            //                self.socket.emit("popularBroadcasts")
            self.socket.emit("notificationsList")
            
            
            
            
        }
        
        self.socket.on("newNotification") { (data, ack) in
            self.socket.emit("notificationsList")
          //self.notificationsTableView.reloadData()
        }
        
        self.socket.on("removeNotifications") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
             let dictionary = modified as! [String: AnyObject]
            print(dictionary)
        }
        
        
        
        self.socket.on("notificationsChanged") { (data, ack) in
            self.socket.emit("notificationsList")
           //self.notificationsTableView.reloadData()
        
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
    
    func seenArray() {
        var SeenArr = [String]()
        for i in 0 ..< self.notificationArray.count {
            let seenData = self.notificationArray[i]
            print(seenData.seen!)
            if(seenData.seen!){
                
            }
            else{
                SeenArr.append(seenData._id!)
            }
            
        }
        
        
        let json2 = [
            "notifications": SeenArr
        ]
        
        if(SeenArr.isEmpty){
            
        }else{
            self.socket.emit("notificationsSeen", with: [json2])
            
        }
        
    }
    
    func removeNotification(i:Int) {
        var SeenArr = [String]()
            let seenData = self.notificationArray[i]
            print(seenData.seen!)
        
                SeenArr.append(seenData._id!)
        
            
        
        
        
        let json2 = [
            "notifications": SeenArr
        ]
        
        if(SeenArr.isEmpty){
            
        }else{
            
            self.socket.emit("removeNotifications", with: [json2])
            self.notificationArray.remove(at:i)
            self.notificationsTableView.reloadData()
            
        }
        
    }
    
    func removeNotificationAll() {
        var SeenArr = [String]()
        //let seenData = self.notificationArray[i]
//        print(seenData.seen!)
//
//        SeenArr.append(seenData._id!)
        print(self.notificationArray.count)
        for i in 0 ..< self.notificationArray.count {
            let seenData = self.notificationArray[i]
            print(seenData.seen!)
           
                SeenArr.append(seenData._id!)
            
            
        }
        
        
        
        let json2 = [
            "notifications": SeenArr
        ]
        print(json2)
        if(SeenArr.isEmpty){
            
        }else{
            self.socket.emit("removeNotifications", with: [json2])
            
        }
        
    }
    
    
   

}
