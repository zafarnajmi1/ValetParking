//
//  ParkedCarInfo.swift
//  ValetParking
//
//  Created by Zafar Najmi on 12/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SwiftyJSON
import SocketIO
import Starscream
import NotificationBannerSwift

class ParkedCarInfo: UIViewController {
    
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var vehicleNoLbl: UILabel!
    
    @IBOutlet var phoneNoLbl: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var AllfieldsView: UIView!
    @IBOutlet var CarImage: UIImageView!
    @IBOutlet weak var Parkcar: UIButton!
    @IBOutlet var parkCarImageButton: UIButton!
    @IBOutlet var nameTxtField: UITextField!
    @IBOutlet var vehicleNoTxtField: UITextField!
    @IBOutlet var emailTxtField: UITextField!
    @IBOutlet var phoneTxtField: UITextField!
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    @IBOutlet var parkCarHeaderLbl: UILabel!
    @IBOutlet var parkCarDetailLbl: UILabel!
    
    let fileName = "Profile_pic"
    var imagePicker = UIImagePickerController()
    var imageUrl : URL!
    var manager:SocketManager!
    var socket:SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        parkCarImageButton.addTarget(self, action: #selector(openGallery(_:)), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setsocketIOS()
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        Parkcar.setTitle("Park Car".localized, for: .normal)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated:true)
        //self.title = "Login or Create Account".localized
        setNavigationBar()
        
        nameLabel.text = "Name:".localized
        vehicleNoLbl.text = "Vehicle No:".localized
        emailLbl.text = "Email:".localized
        phoneNoLbl.text = "Phone No:".localized
        
        parkCarHeaderLbl.text = "Park A Car".localized
        parkCarDetailLbl.text = "Add Car Information".localized
        
        nameTxtField.placeholder = "e.g William Blake".localized
        vehicleNoTxtField.placeholder = "e.g ABC 1234".localized
        emailTxtField.placeholder = "e.g williamblake@gmail.com".localized
        phoneTxtField.placeholder = "e.g 123 4567890".localized
        
        AllfieldsView.setBorderColor(color: Colors.lightGrey)
        AllfieldsView.setBorderWidth(width: 0.5)
        
        self.title = "Car Parking".localized
        
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
    
    
    @objc func notification_message(_ sender: Any)
    {
        
        //self.dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated:true)
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
            
            //self.ApiSocketCall()
            
            
            
        }
        
        self.socket.on("carUpdated") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            //self.ApiSocketCall()
            
            
        }
        self.socket.on("carInProgress") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            //self.ApiSocketCall()
            
            
        }
        self.socket.on("carDelivered") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            //self.ApiSocketCall()
            
            
        }
        
        self.socket.on("companyStatus") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            
            let swiftY = JSON(modified)
            print(swiftY["data"]["isActive"].int!)
            Shared.sharedInfo.userModel.data?.isCompanyActive = swiftY["data"]["isActive"].int!
            
            guard let isActive = Shared.sharedInfo.userModel.data?.isCompanyActive else {return}
            
            
            if isActive == 0 {
                let alertController = UIAlertController(title: "Error", message: "your Company is disabled by SuperAdmin", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.performSegue(withIdentifier: "agentHome", sender: self)
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
    
    @IBAction func parkCarAction(_ sender: UIButton) {
        
        myImageUploadRequest()
        
      }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
         Parkcar.setGradientBackground(colorOne:Colors.blue, colorTwo: Colors.Mediumblue)
    }
    
    func myImageUploadRequest()
    {
        
        guard let name = nameTxtField.text else {return}
        guard let email = emailTxtField.text else {return}
        guard let phone = phoneTxtField.text else {return}
        guard let vehicle = vehicleNoTxtField.text else {return}
        guard let agendId = Shared.sharedInfo.userModel.data?._id else {return}
        guard let companyId = Shared.sharedInfo.userModel.data?.company else {return}
        guard let token = Shared.sharedInfo.userModel.data?.authorization else {return}
        
        if CarImage.image == #imageLiteral(resourceName: "Camera") {
            //ToastManager.showToastMessage(message: "please insert Image")
            let banner = NotificationBanner(title: "error", subtitle: "please insert Image", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else if name.isEmpty  {
            //ToastManager.showToastMessage(message: "please enter name")
            let banner = NotificationBanner(title: "error", subtitle: "please enter name", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else if email.isEmpty  {
            //ToastManager.showToastMessage(message: "please enter email")
            let banner = NotificationBanner(title: "error", subtitle: "please enter email", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else if phone.isEmpty  {
            //ToastManager.showToastMessage(message: "please enter Phone#")
            let banner = NotificationBanner(title: "error", subtitle: "please enter Phone#", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
            
        else if vehicle.isEmpty  {
            //ToastManager.showToastMessage(message: "please enter Vehicle No")
            let banner = NotificationBanner(title: "error", subtitle: "please enter Vehicle No", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else if email.isValidEmail() != true{
            //ToastManager.showToastMessage(message: "Enter Valid Email")
            let banner = NotificationBanner(title: "error", subtitle: "Enter Valid Email", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
            
        else {
            let url = "http://216.200.116.25/valet-parking/api/auth/car/store"
            
            let myUrl = URL(string: url)
            //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
            
            let request = NSMutableURLRequest(url:myUrl!);
            request.httpMethod = "POST";
            let userToken = token
            let param = [
                //   "token":userToken,
                "userName": name,
                "email" : email,
                "phone" : phone,
                "carNumber" : vehicle,
                "parkingStartAgent": agendId,
                "company" : companyId
                
                
                
                ] as [String : Any]
            
            print(param)
            let boundary = generateBoundaryString()
            
            request.setValue("Bearer \(userToken)", forHTTPHeaderField: "Authorization")
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            print(request)
            
            //                let imageData = UIImageJPEGRepresentation(imgProfile.image!, 1)
            
            let imageData = self.compressImageWithAspectRatio(image: CarImage.image!) as Data
            
            print(imageData)
            if(imageData==nil)  { return; }
            
            request.httpBody = createBodyWithParameters(with: param as? [String : String], filePathKey: "parkingStartImage", imageDataKey: (imageData as NSData) as Data, boundary: boundary) as Data
            
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
                        let success = swiftY["success"].bool
                        print(a)
                        // self.successMessage = a
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Car Parked", message: a, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                UIAlertAction in
                                if success == true {
                                    self.navigationController?.popViewController(animated: true)
                                }
                                else {return}
                                
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

extension ParkedCarInfo : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            CarImage.image = img
            
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            CarImage.image = img
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.profileBottomCst.constant = 15
//        self.profileTopCst.constant = 15
//        self.profileLeadingCst.constant = 15
//        self.profileTrailngCst.constant = 15
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openGallery(_ sender:UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.cameraCaptureMode =  UIImagePickerController.CameraCaptureMode.photo
            imagePicker.modalPresentationStyle = .custom
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
        
        
        
        
        func saveFileToDocumentDirectory(image: UIImage) {
            
            if let savedUrl = FileManager.default.saveFileToDocumentsDirectory(image: image, name: self.fileName, extention: ".png") {
                self.imageUrl = savedUrl
            }
        }
        
        func removeFileFromDocumentsDirectory(fileUrl: URL) {
            _ = FileManager.default.removeFileFromDocumentsDirectory(fileUrl: fileUrl)
        }
        
    }
    
}




