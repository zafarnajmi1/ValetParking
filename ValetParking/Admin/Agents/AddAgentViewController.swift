//
//  ViewController.swift
//  hitThatApi
//
//  Created by macbook on 08/09/2018.
//  Copyright © 2018 macbook. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessageBar
import SocketIO
import Starscream
import NotificationBannerSwift






class AddAgentViewController: UIViewController {
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    @IBOutlet var profileView: UIView!
    @IBOutlet var addAgentBtn: UIButton!
    @IBOutlet var nameTxtField: UITextField!
    @IBOutlet var emailTxtField: UITextField!
    @IBOutlet var phoneTxtField: UITextField!
    @IBOutlet var passwordTxtField: UITextField!
    @IBOutlet var rePasswordTxtField: UITextField!
    @IBOutlet var adressTxtField: UITextField!
    @IBOutlet var uploadPicBtn: UIButton!
    @IBOutlet var profileImage: UIImageView!
    
    
    
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!
    @IBOutlet var passwordLbl: UILabel!
    @IBOutlet var confirmPasswordLabel: UILabel!
    @IBOutlet var adressLbl: UILabel!
    
    var manager:SocketManager!
    var socket:SocketIOClient!
    
    @IBOutlet var profileBottomCst: NSLayoutConstraint!
    @IBOutlet var profileTrailngCst: NSLayoutConstraint!
    @IBOutlet var profileTopCst: NSLayoutConstraint!
    @IBOutlet var profileLeadingCst: NSLayoutConstraint!
    
    let fileName = "Profile_pic"
    var imageUrl : URL!
    
    var imagePicker = UIImagePickerController()
    var imagePickerFromCamera = UIImagePickerController()
    var successMessage = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
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
        localized()
        self.view.addTapToDismiss()
        addAgentBtn.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        addAgentBtn.addTarget(self, action: #selector(addAgentAction(_:)), for: .touchUpInside)
        uploadPicBtn.addTarget(self, action: #selector(openGallery(_:)), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileView.layer.cornerRadius = profileView.frame.height / 2
        profileView.clipsToBounds =  true
//        profileImage.layer.cornerRadius =  profileImage.frame.height / 2
//        profileImage.clipsToBounds =  true
        self.setsocketIOS()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addAgentBtn.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func localized() {
        self.title = "Add Valet".localized
        nameLbl.text = "Name".localized
        emailLbl.text = "Email".localized
     passwordLbl.text = "Password".localized
        confirmPasswordLabel.text = "Confirm Password".localized
        adressLbl.text = "Address".localized
        phoneLbl.text = "Phone".localized
        addAgentBtn.setTitle("Add Valet".localized, for: .normal)
    }
    
    @objc func back(_ sender:Any) {
        
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func addAgentAction(_ sender:UIButton) {
        
        //makeApiRequest()
        myImageUploadRequest()
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
    
    
    
    func myImageUploadRequest()
    {
        
        guard let name = nameTxtField.text else {return}
        guard let email = emailTxtField.text else {return}
        guard let phone = phoneTxtField.text else {return}
        guard let password = passwordTxtField.text else {return}
        guard let REpassword = rePasswordTxtField.text else {return}
        guard let adress = adressTxtField.text else {return}
        guard let company = Shared.sharedInfo.userModel.data?._id else {return}
        
       
        if profileImage.image == #imageLiteral(resourceName: "Camera") {
            let banner = NotificationBanner(title: "error", subtitle: "Please insert image", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        
       else if name.isEmpty {
            //ToastManager.showToastMessage(message: "please enter name")
            let banner = NotificationBanner(title: "error", subtitle: "please enter name", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else if email.isEmpty {
            //ToastManager.showToastMessage(message: "please enter email")
            let banner = NotificationBanner(title: "error", subtitle: "please enter email", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else if phone.isEmpty {
            //ToastManager.showToastMessage(message: "please enter Phone#")
            let banner = NotificationBanner(title: "error", subtitle: "please enter Phone#", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
            
        else if password.isEmpty {
            //ToastManager.showToastMessage(message: "please enter Password")
            let banner = NotificationBanner(title: "error", subtitle: "please enter Password", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else if REpassword.isEmpty {
            //ToastManager.showToastMessage(message: "please enter RePassword")
            let banner = NotificationBanner(title: "error", subtitle: "please enter RePassword", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else if password != REpassword {
            //ToastManager.showToastMessage(message: "Password doesn't match")
            let banner = NotificationBanner(title: "error", subtitle: "Password doesn't match", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else if adress.isEmpty {
            //ToastManager.showToastMessage(message: "please enter Adress")
            let banner = NotificationBanner(title: "error", subtitle: "please enter Adress", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
            
        else if email.isValidEmail() != true{
            //ToastManager.showToastMessage(message: "Enter Valid Email")
            let banner = NotificationBanner(title: "error", subtitle: "Enter Valid Email", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else if phone.count < 6 {
            //ToastManager.showToastMessage(message: "please enter Phone#")
            let banner = NotificationBanner(title: "error", subtitle: "Password must be atleast 6 character", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        
//        else if passwordTextField.text?.isEmpty ?? true {
//            ToastManager.showToastMessage(message: "please enter password")
//        }
//        else if confirmPasswordTextField.text?.isEmpty ?? true
//        {
//            ToastManager.showToastMessage(message: "please enter Repassword")
//        }
//        else if passwordTextField.text != confirmPasswordTextField.text {
//            ToastManager.showToastMessage(message: "Password doesn't match")
//        }
//
//        else if pmdcTextField.text?.isEmpty ?? true {
//            ToastManager.showToastMessage(message: "please enter password")
//        }
        else {
         
        
        
        
        let url = "http://216.200.116.25/valet-parking/api/auth/agent/store"
        
        let myUrl = URL(string: url)
        //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
        
        let request = NSMutableURLRequest(url:myUrl!);
        request.httpMethod = "POST";
        let userToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7Il9pZCI6IjViODgwMTQ3OTc1ODc3MzM5ZjAwNDBiZSJ9LCJpYXQiOjE1MzYzMDM4NDB9.FunAJPR6U1amKZQE8zDDX094G_hKQEgX4gW30ZDbN3I"
        let param = [
            //   "token":userToken,
            "fullName": name,
            "email" : email,
            "phone" : phone,
            "address" : adress,
            "password" : password,
            "passwordConfirmation" : REpassword,
            "company" : company
            ] as [String : Any]
        
        print(param)
        let boundary = generateBoundaryString()
        
        request.setValue("Bearer \(userToken)", forHTTPHeaderField: "Authorization")
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        print(request)
        
        //                let imageData = UIImageJPEGRepresentation(imgProfile.image!, 1)
        
        let imageData = self.compressImageWithAspectRatio(image: profileImage.image!) as Data
        
        print(imageData)
        if(imageData==nil)  { return; }
        
         request.httpBody = createBodyWithParameters(with: param as? [String : String], filePathKey: "image", imageDataKey: (imageData as NSData) as Data, boundary: boundary) as Data
        
        let session = URLSession.shared
        DispatchQueue.main.async {
            LoaderManager.show(self.view, message:"please Wait") }
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
            LoaderManager.hide(self.view)
            }
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //let message = json["message"]["en"]
                    print(json)
                    let swiftY = JSON(json)
                    let a = swiftY["message"]["en"].string!
                    
                   
                    self.successMessage = a
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Agent Created", message: a, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                           
                            if swiftY["success"].int == 1 {
                                self.navigationController?.popViewController(animated: true)
                            }
                            else {
                                return
                            }
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } catch {
                    print(error)
                }
            }
            
            }.resume()
        self.dismiss(animated: true, completion: nil)
            
        }
        
        
    }
    
    func createBodyWithParameters(with parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data
    {
        var body = ""
        
        if let params = parameters {
            for (key, value) in params {
                body += "--\(boundary)\r\n"
                body += "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
                body += "\(value)\r\n"
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
       
        
        body += "--\(boundary)\r\n"
        body += "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n"
        body += "Content-Type: \(mimetype)\r\n\r\n"
        
        var data = body.data(using: .utf8)!
        data.append(imageDataKey)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return data
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    
    
}





extension AddAgentViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            profileImage.image = img
            
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            profileImage.image = img
        }
        dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.profileBottomCst.constant = 15
//        self.profileTopCst.constant = 15
//        self.profileLeadingCst.constant = 15
//        self.profileTrailngCst.constant = 15
//
//        dismiss(animated: true, completion: nil)
//    }
    
    @objc func openGallery(_ sender:UIButton) {
        
        PicKImage()
    }
        
        func PicKImage()
        {
            
            let alert = UIAlertController(title: "Pick Image", message: "Select Image ", preferredStyle: .alert)
            
            
            let Gallry = UIAlertAction(title: "Gallery", style: .default){ (Picimg) in self.GalleryPic()
            }
            let camraimg = UIAlertAction(title: "Camera", style: .default){ (ac) in self.cameraPic()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel){(action) in self.cancel()
                
            }
            
            alert.addAction(Gallry)
            alert.addAction(camraimg)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            
        }
    
    func GalleryPic(){
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: {
//                self.profileBottomCst.constant = 0
//                self.profileTopCst.constant = 0
//                self.profileLeadingCst.constant = 0
//                self.profileTrailngCst.constant = 0
            })
            
        }
        else {
            print("Not Available")
        }
        
    }
    
    
    func cameraPic(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerFromCamera.delegate = self
            imagePickerFromCamera.sourceType = UIImagePickerController.SourceType.camera
            imagePickerFromCamera.allowsEditing = true
           
            present(imagePickerFromCamera, animated: true, completion: {
                //                self.profileBottomCst.constant = 0
                //                self.profileTopCst.constant = 0
                //                self.profileLeadingCst.constant = 0
                //                self.profileTrailngCst.constant = 0
            })
            
        }
        else {
            print("Not Available")
        }
        
        
    }
    
    func cancel()
    {
        
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
        func saveFileToDocumentDirectory(image: UIImage) {
            
            if let savedUrl = FileManager.default.saveFileToDocumentsDirectory(image: image, name: self.fileName, extention: ".png") {
                self.imageUrl = savedUrl
            }
        }
        
        func removeFileFromDocumentsDirectory(fileUrl: URL) {
            _ = FileManager.default.removeFileFromDocumentsDirectory(fileUrl: fileUrl)
        }
        
    }
    


