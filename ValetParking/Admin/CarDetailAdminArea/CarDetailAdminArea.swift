//
//  CarDetailAdminArea.swift
//  ValetParking
//
//  Created by Zafar Najmi on 18/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SwiftyJSON
import NotificationBannerSwift

class CarDetailAdminArea: UIViewController {

    @IBOutlet var lblReleasCar: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var FinishRequist: UIButton!
    @IBOutlet weak var UnderProcess: UIButton!
    @IBOutlet weak var StartRequist: UIButton!
    @IBOutlet weak var ExitingCarPicture: UIImageView!
    @IBOutlet weak var newCarPicture: UIImageView!
    @IBOutlet weak var CardetailadminAreaView: UIView!
    
    @IBOutlet var releaseACarHeader: UILabel!
    @IBOutlet var parkedCarHeader: UILabel!
    @IBOutlet var newCarView: UIView!
    @IBOutlet var existingCarView: UIView!
    @IBOutlet var getNewImage: UIButton!
    @IBOutlet var vehicleNoLbl: UILabel!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var phoneNoLbl: UILabel!
    @IBOutlet var parkTimeLbl: UILabel!
    
    @IBOutlet var startRequestView: UIView!
    @IBOutlet var underProgressView: UIView!
    @IBOutlet var finishRequestView: UIView!
    
    @IBOutlet var parklbl: UILabel!
    @IBOutlet var VehicleLbl: UILabel!
    
    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var phoneLbl: UILabel!
    
    var car = Cars()
    let fileName = "Profile_pic"
    var imagePicker = UIImagePickerController()
    var imageUrl : URL!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parklbl.text = "Park Time:"
        lblReleasCar.text = "Release Car".localized
        startRequestView.backgroundColor = UIColor(0x6CB53F)
        underProgressView.backgroundColor = UIColor(0xEE8002)
        finishRequestView.backgroundColor = UIColor(0xF41818)
        
        existingCarView.setBorderWidth(width: 0.5)
        existingCarView.setBorderColor(color: Colors.lightGrey)
        
//        newCarView.setBorderWidth(width: 0.5)
//        newCarView.setBorderColor(color: Colors.lightGrey)
        
        CardetailadminAreaView.setBorderColor(color: Colors.lightGrey)
        CardetailadminAreaView.setBorderWidth(width: 0.5)
        
       // startRequestView.setGradientBackground(colorOne: Colors.gradientGreenFirst, colorTwo: Colors.gradientGreenSecond)
       // underProgressView.setGradientBackground(colorOne: Colors.gradientOrangeFirst, colorTwo: Colors.gradientOrangeSecond)
       // finishRequestView.setGradientBackground(colorOne: Colors.gradientRedFirst, colorTwo: Colors.gradientRedSecond)
        
        
        if car.status == "inprogress" {
            //StartRequist.isHidden = true
            startRequestView.backgroundColor = UIColor(0xA9A9A9) //Colors.lightGrey
            
        }
        
        
        setApiData()
         StartRequist.addTarget(self, action: #selector(startRequest(_:)), for: .touchUpInside)
          FinishRequist.addTarget(self, action: #selector(endRequest(_:)), for: .touchUpInside)
         getNewImage.addTarget(self, action: #selector(openGallery(_:)), for: .touchUpInside)
        
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        startRequestView.backgroundColor = UIColor(0x6CB53F)
//        underProgressView.backgroundColor = UIColor(0xEE8002)
//        finishRequestView.backgroundColor = UIColor(0xF41818) //menow
        //pending
        print(car.status)
        if car.status == "inprogress" {
            //StartRequist.isHidden = true
            //startRequestView.isHidden = true
            //startRequestView.setGradientBackground(colorOne: Colors.white, colorTwo: Colors.lightGrey)
            StartRequist.isEnabled = false
          startRequestView.backgroundColor = UIColor(0xA9A9A9)//Colors.lightGrey
            
        }else if(car.status == "pending")
        {
            startRequestView.backgroundColor = UIColor(0x6CB53F)
            underProgressView.backgroundColor = UIColor(0xA9A9A9)
            finishRequestView.backgroundColor = UIColor(0xA9A9A9)
            FinishRequist.isEnabled = false
            UnderProcess.isEnabled = false
            
        }
        
        VehicleLbl.text = "Vehicle no:".localized
        nameLbl.text = "Name:".localized
        phoneLbl.text = "Phone no:".localized
        parklbl.text = "Park Time".localized
        releaseACarHeader.text = "Release A Car".localized
        parkedCarHeader.text = "Parked Car Information".localized
        
        
        
        StartRequist.setTitle("Start Request".localized, for: .normal)
        UnderProcess.setTitle("Under Process".localized, for: .normal)
        FinishRequist.setTitle("Finish Request".localized, for: .normal)
        
        
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //startRequestView.setGradientBackground(colorOne: Colors.gradientGreenFirst, colorTwo: Colors.gradientGreenSecond)
       // underProgressView.setGradientBackground(colorOne: Colors.gradientOrangeFirst, colorTwo: Colors.gradientOrangeSecond)
        //finishRequestView.setGradientBackground(colorOne: Colors.gradientRedFirst, colorTwo: Colors.gradientRedSecond)
        
        if car.status == "inprogress" {
            //StartRequist.isHidden = true
            //startRequestView.isHidden = true
            //startRequestView.setGradientBackground(colorOne: Colors.white, colorTwo: Colors.lightGrey)
            
            
            
        }
        
    }
    func setNavigationBar(){
        self.title = "Release Car"
        let headerImage = #imageLiteral(resourceName: "Bg 2")
        self.navigationController?.navigationBar.setBackgroundImage(headerImage, for:.default)
        
        //let color: UIColor = navColor
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //self.navigationController!.navigationBar.barTintColor = color
        self.navigationController!.navigationBar.barStyle = .blackOpaque
        
        let bell_button = UIButton(type: .system)
        if lang == "ar" {
            bell_button.setImage(#imageLiteral(resourceName: "Ar-back").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else {
            bell_button.setImage(#imageLiteral(resourceName: "back-2").withRenderingMode(.alwaysOriginal), for: .normal)
               bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        }
        bell_button.addTarget(self, action: #selector( notification_message(_:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
    }
    
    @objc func notification_message(_ sender: Any)
    {
        
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func endRequest(_ sender:Any) {
        
        if newCarPicture.image ==  #imageLiteral(resourceName: "place-holder")
        {
           // ToastManager.showToastMessage(message: "Please Insert Image")
            let banner = NotificationBanner(title: "error", subtitle: "Please Insert Image", style: .danger)
            banner.show()
            banner.duration = 0.3
        }
        else {
            myImageUploadRequest()
        }
        
    }
    
    @objc func startRequest(_ sender:Any) {
        
       
        guard let carId = car._id else {return}
       guard let endAgentId = car.parkingStartAgent?._id else {return}
        
      
        LoaderManager.show(self.view)
        
        ApiManager.shared.CarInProgress(carId:carId,endAgentId: endAgentId, success: { progressCar in
        LoaderManager.hide(self.view)
            
            let alertController = UIAlertController(title: "In Progress", message: progressCar.message?.en, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style:UIAlertAction.Style.default) {
                UIAlertAction in
                self.StartRequist.isEnabled = false
                self.startRequestView.backgroundColor = Colors.lightGrey
                //self.startRequestView.backgroundColor = UIColor(0x6CB53F)
                self.underProgressView.backgroundColor = UIColor(0xEE8002)
                self.finishRequestView.backgroundColor = UIColor(0xF41818)
                self.FinishRequist.isEnabled = true
                self.UnderProcess.isEnabled = true
                
                
            }
            // Add the actions
            alertController.addAction(okAction)
            //alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
         
        }, failure: {
            error in
        })
    }
    
    func setApiData() {
        
        //        let imageUrl = "http://themedicall.com/public/uploaded/img/specialities/" + dataSourceArray[indexPath.row].speciality_icon!
        //
        //        let url = URL(string: imageUrl)
        //        cell.findDoctorImage.af_setImage(withURL: url!)
       // print(car.parkingStartTiming!)
        
        //let dateFormatter = DateFormatter()
        
        //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        //dateFormatter.dateStyle = .medium
        
        
        //        let updatedAtStr = "2016-06-05T16:56:57.019+01:00"
        //        let updatedAt = dateFormatter.date(from: car.parkingStartTiming!) // "Jun 5, 2016, 4:56 PM"
        //        print(updatedAt!)
        
        
        
        
        let imageUrl = car.parkingStartImage
        print(imageUrl!)
        let url = URL(string: imageUrl!)
        //  print(url!)
        ExitingCarPicture.af_setImage(withURL: url!)
        
        let time = car.createdAt
        let secondTime = car.updatedAt
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        let date = dateFormatter.date(from: time!)
        let secondDate = dateFormatter.date(from: secondTime!)
        print(date!)
        
        
        let outputFormatter =  DateFormatter()
        //outputFormatter.dateFormat = "yyyy-MM-dd"
        outputFormatter.dateFormat = "hh:mm a dd-MM-yyyy"
        
        let resultString = outputFormatter.string(from: date!)
        let secondString = outputFormatter.string(from: secondDate!)
        
        vehicleNoLbl.text = car.carNumber
        userNameLbl.text = car.userName
        phoneNoLbl.text = car.phone
        parkTimeLbl.text = resultString
        
        
        
        
        
    }
    
    func myImageUploadRequest()
    {
       
        guard let id = car._id else {return}
        guard let token = Shared.sharedInfo.userModel.data?.authorization else {return}
        
        
        let url = "http://216.200.116.25/valet-parking/api/auth/car/completed"
        
        let myUrl = URL(string: url)
        
        
        let request = NSMutableURLRequest(url:myUrl!);
        request.httpMethod = "POST";
        let userToken = token
        let param = [
            "_id": id
            ] as [String : Any]
        
        print(param)
        let boundary = generateBoundaryString()
        
        request.setValue("Bearer \(userToken)", forHTTPHeaderField: "Authorization")
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        print(request)
        
        //                let imageData = UIImageJPEGRepresentation(imgProfile.image!, 1)
        
        let imageData = self.compressImageWithAspectRatio(image: newCarPicture.image!) as Data
        
        print(imageData)
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(with: param as? [String : String], filePathKey: "parkingEndImage", imageDataKey: (imageData as NSData) as Data, boundary: boundary) as Data
        
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
                    
                    print(a)
                    // self.successMessage = a
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Car Delivered", message: a, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style:UIAlertAction.Style.default) {
                            UIAlertAction in
                            
                            if let a = Shared.sharedInfo.userModel.data?.role?.roleType
                            {
                                if a == "valet" {
                                    self.appDelegate.moveToHome()
                                }
                                else {
                                   
                                    self.appDelegate.moveToAdmin()
                                }
                                
                            }
                            //self.navigationController?.popViewController(animated: true)
                            
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

extension CarDetailAdminArea : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            newCarPicture.image = img
            
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            newCarPicture.image = img
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

extension UIButton
{
    func buttonDesign()
    {
        self.layer.cornerRadius = 5
        
        self.clipsToBounds = true
    }
}
