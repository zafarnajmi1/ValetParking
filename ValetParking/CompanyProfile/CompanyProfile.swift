//
//  CompanyProfile.swift
//  ValetParking
//
//  Created by My Technology on 14/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SwiftyJSON

class CompanyProfile: UIViewController {
    
    //let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!
    @IBOutlet var adressLbl: UILabel!
    @IBOutlet var agentProfile: UIImageView!
    @IBOutlet var profileEditBtn: UIButton!
    
    @IBOutlet var aboutCompanyTxtView: UITextView!
    
    @IBOutlet var aboutCompanyView: UIView!
    @IBOutlet var mainTextView: UIView!
    @IBOutlet var disableProfileBtn: UIButton!
    @IBOutlet var viewStatsBtn: UIButton!
    
    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var password: UILabel!
    
    @IBOutlet var editAbout: UIButton!
    @IBOutlet var nameButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var phoneButton: UIButton!
    @IBOutlet var adressButton: UIButton!
    @IBOutlet var aboutCompany: UILabel!
    
    var reSet = ResetPasswordMain()
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var user = Shared.sharedInfo.userModel.data!
    
    var Agent = AgentListingAgents()
    var a:String?
    var imagePicker = UIImagePickerController()
    let fileName = "Profile_pic"
    var imageUrl : URL!
    var index = 0
    
    
    //var agent = AgentListingMain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Shared.sharedInfo.userModel.data?.role?.roleType == "valet"
        {
//            phoneButton.isHidden = true
//            adressButton.isHidden = true
//            phoneButton.isHidden = true
        }
     
        emailButton.isHidden = true
        nameButton.addTarget(self, action:#selector(openPopUp(_:)) , for: .touchUpInside)
        emailButton.addTarget(self, action:#selector(openPopUp(_:)) , for: .touchUpInside)
        phoneButton.addTarget(self, action:#selector(openPopUp(_:)) , for: .touchUpInside)
        adressButton.addTarget(self, action:#selector(openSecondPopUp(_:)) , for: .touchUpInside)
        profileEditBtn.addTarget(self, action:#selector(openGallery(_:)) , for: .touchUpInside)
        viewStatsBtn.isHidden = true //menow
        viewStatsBtn.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        viewStatsBtn.setTitle("ViewStats".localized, for: .normal)
        viewStatsBtn.tintColor = Colors.white
        
        editAbout.addTarget(self, action:#selector(openPopUp(_:)) , for: .touchUpInside)
        
        nameLbl.text = user.fullName!
        emailLbl.text = user.email!
        phoneLbl.text = user.phone
        adressLbl.text = "********"
        
        
        mainTextView.setCornerRadius(r:5)
        mainTextView.setBorderColor(color:Colors.lightGrey)
        
        aboutCompanyView.setCornerRadius(r: 5)
        aboutCompanyView.setBorderWidth(width: 0.5)
        aboutCompanyView.setBorderColor(color: Colors.lightGrey)
        
        mainTextView.setBorderWidth(width:0.5)
        
        if Shared.sharedInfo.userModel.data?.role?.roleType == "Company" {
            aboutCompanyTxtView.text = "  " + user.about!
            viewStatsBtn.isHidden = true
        }
        else {
            aboutCompanyTxtView.isHidden = true
            aboutCompanyView.isHidden = true
        }
       
        
        
        
        self.navigationItem.hidesBackButton = true
        //self.title = "Agent Profile"
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
        
        // Do any additional setup after loading the view.
        
        
        
        let imageUrl = user.image
        print(imageUrl!)
        let url = URL(string: imageUrl!)
        //  print(url!)
        agentProfile.af_setImage(withURL: url!)
        localized()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewStatsBtn.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
    }
    
    @objc func back(_ sender:Any) {
        
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    func localized() {
        name.text = "Name: ".localized
        email.text = "Email: ".localized
        phone.text = "Phone: ".localized
        password.text = "Password:".localized
        aboutCompany.text = "About Company :".localized
       
        if let type = user.role?.title {
            self.title = "\(String(describing: type)) Profile".localized
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        let a = Agent.isActive!
        //        if a == 0 {
        //            disableProfileBtn.setTitle("Disable", for: .normal)
        //        }
        //        else {
        //            disableProfileBtn.setTitle("Enable Agent", for: .normal)
        //        }
        
    }
    @objc func back(sender: UIBarButtonItem) {
        
        // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    // Do any additional setup after loading the view.
    @objc func openPopUp(_ sender:UIButton) {
        print(sender.tag)
        let popupViewControllerIdentifier = "popupViewController"
        let main = UIStoryboard(name: "Main", bundle: nil)
        let controller = main.instantiateViewController(withIdentifier: popupViewControllerIdentifier) as! PopupViewController
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overFullScreen
        controller.negativeText = "Save".localized
        controller.positiveText = "Cancel".localized
        
        if sender.tag == 0 {
            
            controller.popupTitle = "Name".localized
            controller.placeHolder = "Name".localized
            controller.popupDescription = "Enter Name Here".localized
            controller.TextFiled = Shared.sharedInfo.userModel.data?.fullName
            index = 0
            controller.tfIndex = 0
        }
        else if sender.tag == 1{
            
            controller.popupTitle = "Email".localized
            controller.placeHolder = "Email".localized
            controller.popupDescription = "Enter Email Here".localized
            controller.TextFiled = Shared.sharedInfo.userModel.data?.email
            index = 1
            controller.tfIndex = 1
        }
        else if sender.tag == 2{
            
            controller.popupTitle = "Phone".localized
            controller.placeHolder = "Phone".localized
            controller.popupDescription = "Enter Phone no Here".localized
            controller.TextFiled = Shared.sharedInfo.userModel.data?.phone
            index = 2
            controller.tfIndex = 2
        }
        else {
            
            //controller.popupTitle = "Adress".localized
            //controller.popupDescription = "Enter Adress Here".localized
            //index = 3
        }
        
        if(sender.tag == 5)
        {
            controller.popupTitle = "About Company".localized
            controller.placeHolder = "About Company".localized
            controller.popupDescription = "Enter About Company Here".localized
            controller.TextFiled = Shared.sharedInfo.userModel.data?.about
            index = 5
            controller.tfIndex = 5
        }
        controller.delegate = self
        controller.identifier = sender.tag
        //a = controller.edit.text!
        self.present(controller, animated: false, completion: nil)
    }
    
    @objc func openSecondPopUp(_ sender:UIButton) {
        print(sender.tag)
        let popupViewControllerIdentifier = "popUp2"
        let main = UIStoryboard(name: "Main", bundle: nil)
        let controller = main.instantiateViewController(withIdentifier: popupViewControllerIdentifier) as! Popup2ViewController
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overFullScreen
        controller.negativeText = "Save".localized
        controller.positiveText = "Cancel".localized
        
      
            
            controller.popupTitle = "Password".localized
            //controller.popupDescription = "Enter Name Here".localized
            //index = 0
        
        controller.delegate = self
        controller.identifier = sender.tag
        //a = controller.edit.text!
        self.present(controller, animated: false, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @objc func disableBtnAction(_ button:UIButton) {
        LoaderManager.show(self.view, message: "Please Wait")
        ApiManager.shared.disableAgents(agentId:Agent._id!, auth: "", success: { disable in
            LoaderManager.hide(self.view)
            
            let alertController = UIAlertController(title: "Hurray", message: disable.message?.en, preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
                self.navigationController?.popViewController(animated: true)
            }
            // Add the actions
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            //self.dismiss(animated: true, completion: nil)
            
        }, failure: {
            error in
        })
    }
    
    func updateAgent(_ paramString:String) {
        
    }
    
    func myImageUploadRequest(_ text:String, Index: Int?)
    {
        
        //        guard let name = nameLbl else {return Agent.fullName}
        //        guard let email = emailLbl else {return Agent.email}
        //        guard let phone = phoneLbl else {return Agent.phone}
        //        guard let adress = adressLbl.text else {return}
        //        guard let REpassword = rePasswordTxtField.text else {return}
        //        guard let adress = adressTxtField.text else {return}
        
        var name:String?
        var email:String?
        var Phone:String?
        var Adress:String?
        
        switch Index {
        case 0:
            nameLbl.text! = text
        case 1:
            emailLbl.text! = text
        case 2:
            phoneLbl.text! = text
        case 5:
            aboutCompanyTxtView.text = text
        default:
            adressLbl.text = text
        }
        
        
        
        
        let url = "http://216.200.116.25/valet-parking/api/auth/update/profile"
        
        let myUrl = URL(string: url)
        //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
        
        let request = NSMutableURLRequest(url:myUrl!);
        request.httpMethod = "POST";
        let userToken = user.authorization!
        
        
        
        let param = [
            "token":userToken,
            "fullName": name ?? nameLbl.text!/*user.fullName!*/,
            "email" : email ?? emailLbl.text!/*user.email!*/,
            "phone" : Phone ?? phoneLbl.text!/*user.phone!*/,
            "about" : Phone ?? aboutCompanyTxtView.text!/*user.phone!*/
            ] as [String : Any]
        
        print(param)
        let boundary = generateBoundaryString()
        
        request.setValue("Bearer \(userToken)", forHTTPHeaderField: "Authorization")
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        print(request)
        
        //let imageData = UIImageJPEGRepresentation(agentProfile.image!, 1)
        
        let imageData = self.compressImageWithAspectRatio(image: agentProfile.image!) as Data
        
        print(imageData)
        if(imageData==nil)  { return;}
        
        request.httpBody = createBodyWithParameters(with: param as? [String : String], filePathKey: "image", imageDataKey: (imageData as! NSData) as Data, boundary: boundary) as Data
        DispatchQueue.main.async {
            LoaderManager.show(self.view)
        }
        let session = URLSession.shared
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
                    print(json)
                    let swiftY = JSON(json)
                    let sucess = swiftY["sucess"].bool
                    
                    
                    let a = swiftY["message"]["en"].string!
                    if swiftY["success"].int == 1 {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Profile Updated", message: a, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            
                            let user = swiftY["data"]["fullName"].string!
                            let email = swiftY["data"]["email"].string!
                            let phone = swiftY["data"]["phone"].string!
                            let image = swiftY["data"]["image"].string!
                            let about = swiftY["data"]["about"].string!
                            
                            
                            Shared.sharedInfo.userModel.data?.fullName = user
                            Shared.sharedInfo.userModel.data?.email = email
                            Shared.sharedInfo.userModel.data?.image = image
                            Shared.sharedInfo.userModel.data?.phone = phone
                            Shared.sharedInfo.userModel.data?.about = about
                            
                            if swiftY["success"].int == 1 {
                                //self.navigationController?.popViewController(animated: true)
                                self.dismiss(animated: true, completion: nil)
                            }
                            else {
                                return
                            }
                            
                            
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    }
                    
                    else {
                        let alertController = UIAlertController(title: "Error", message: a, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            
                        }
                            
                         
                            
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } catch {
                    print(error)
                }
            }
            
            }.resume()
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
extension CompanyProfile: PopupViewControllerDelegate {
    
    
  func didSelectNegativeBtn(text: String?, index: Int?) {


        if text?.isEmpty == true {
            ToastManager.showToastMessage(message: "Field Shouldn't be empty")
        }
        else {
            myImageUploadRequest(text!, Index: index)
            self.dismiss(animated: true, completion: nil)
        }


    }


    func didSelectPositiveBtn(text: String?) {

        self.dismiss(animated: true, completion: nil)

    }

}

extension CompanyProfile : Popup2ViewControllerDelegate {
    func didSelect2PositiveBtn(oldPassword: String?, newPassword: String?, confirmNewPassword: String?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didSelect2NegativeBtn(oldPassword: String?, newPassword: String?, confirmNewPassword: String?) {
        
        guard let auth = Shared.sharedInfo.userModel.data?.authorization else {return}
    
        if (oldPassword?.isEmpty)! || (newPassword?.isEmpty)! || (confirmNewPassword?.isEmpty)! {
            ErrorReporting.showMessage(title: "error", msg: "Fields Shouldn't be Empty")
        }
        
        else if newPassword! != confirmNewPassword! {
            ErrorReporting.showMessage(title: "error", msg: "Password Doesn't Match")
        }
        
        else {
            LoaderManager.show(self.view)
            ApiManager.shared.resetPassword(oldPassword: oldPassword!, newPassword: newPassword!, confirmNewPassword: confirmNewPassword!, auth: auth, success: { reset in
                LoaderManager.hide(self.view)
                self.reSet = reset
              
                
            
                ErrorReporting.showMessage(title: "Password Changed", msg: (reset.message?.en)!)
                
//                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                    UIAlertAction in
//                    print("some")
//                }
               
                
            }, failure: {
                error in
            })
        
            
            self.dismiss(animated: true, completion: nil)
        }
        
     
    }
    
    
    
   


}

extension CompanyProfile : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            agentProfile.image = img
            
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            agentProfile.image = img
        }
        dismiss(animated: true, completion: {
            self.myImageUploadRequest(self.nameLbl.text!, Index: 4)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //        self.profileBottomCst.constant = 15
        //        self.profileTopCst.constant = 15
        //        self.profileLeadingCst.constant = 15
        //        self.profileTrailngCst.constant = 15
        
        dismiss(animated: true, completion: {
            //self.myImageUploadRequest(self.nameLbl.text!)
        })
    }
    
    @objc func openGallery(_ sender:UIButton) {
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


