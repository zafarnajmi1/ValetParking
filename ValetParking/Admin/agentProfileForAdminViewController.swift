//
//  agentProfileForAdminViewController.swift
//  ValetParking
//
//  Created by My Technology on 10/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol agentProfileDelegate :  class {
    func deleteProfile(userID : String)
    func ReloadApiCall()
}
extension agentProfileDelegate{
    func deleteProfile(userID : String){
        
    }
}
class agentProfileForAdminViewController: UIViewController {
    
    
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!
    @IBOutlet var adressLbl: UILabel!
    @IBOutlet var agentProfile: UIImageView!
    @IBOutlet var profileEditBtn: UIButton!
    
    @IBOutlet var nameTitleLbl: UILabel!
    @IBOutlet var emailTitleLbl: UILabel!
    @IBOutlet var phoneTitleLbl: UILabel!
    @IBOutlet var adressTitleLbl: UILabel!
    
    
    @IBOutlet var mainTextView: UIView!
    @IBOutlet var disableProfileBtn: UIButton!
    @IBOutlet var viewStatsBtn: UIButton!
    
    
    @IBOutlet var nameButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var phoneButton: UIButton!
    @IBOutlet var adressButton: UIButton!
    
    var Agent = AgentListingAgents()
    var a:String?
    var imagePicker = UIImagePickerController()
    let fileName = "Profile_pic"
    var imageUrl : URL!
    var index = 0
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    
    weak var delegate : agentProfileDelegate!
    
    var sharedIndex: Int?
    
    
    //var agent = AgentListingMain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailButton.isHidden = true
        nameTitleLbl.text = "Name: ".localized
        emailTitleLbl.text = "Email: ".localized
        phoneTitleLbl.text = "Phone: ".localized
        adressTitleLbl.text = "Address: ".localized
        viewStatsBtn.setTitle("View Stats".localized, for: .normal)
        
        
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
//        print(Agent.isLoggedIn)
      //  print(Agent.isActive)
        
        let a = Agent.isActive!
        if a == 0 {
            disableProfileBtn.setTitle("Enable Valet".localized, for: .normal)
        }
        else {
            disableProfileBtn.setTitle("Disable Valet".localized, for: .normal)
        }
        
        
        nameButton.addTarget(self, action:#selector(openPopUp(_:)) , for: .touchUpInside)
        emailButton.addTarget(self, action:#selector(openPopUp(_:)) , for: .touchUpInside)
        phoneButton.addTarget(self, action:#selector(openPopUp(_:)) , for: .touchUpInside)
        adressButton.addTarget(self, action:#selector(openPopUp(_:)) , for: .touchUpInside)
        profileEditBtn.addTarget(self, action:#selector(openGallery(_:)) , for: .touchUpInside)
        
        nameLbl.text = Agent.fullName
        emailLbl.text = Agent.email
        phoneLbl.text = Agent.phone
        adressLbl.text = Agent.address
        Shared.sharedInfo.userStatsName = Agent.fullName!
        mainTextView.setCornerRadius(r:5)
        mainTextView.setBorderColor(color:Colors.lightGrey)
        
        mainTextView.setBorderWidth(width:0.5)
        
        disableProfileBtn.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        viewStatsBtn.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        
        disableProfileBtn.addTarget(self, action: #selector(disableBtnAction(_:)), for: .touchUpInside)
        
        
        
        self.navigationItem.hidesBackButton = true
        self.title = "Valet Profile".localized
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
    
    
        
        let imageUrl = Agent.image
        print(imageUrl!)
        let url = URL(string: imageUrl!)
        //  print(url!)
       agentProfile.af_setImage(withURL: url!)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender:sender)
        if let ctrl = segue.destination as? StatsViewController {
            
            
            
                ctrl.agentId = Agent._id
          
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        disableProfileBtn.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        viewStatsBtn.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
    }
    

    
    @objc func back(_ sender:Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTitleLbl.text = "Name: ".localized
        emailTitleLbl.text = "Email: ".localized
        phoneTitleLbl.text = "Phone: ".localized
        adressTitleLbl.text = "Address: ".localized
        viewStatsBtn.setTitle("View Stats".localized, for: .normal)
        
        let a = Agent.isActive!
        if a == 0 {
            disableProfileBtn.setTitle("Enable Valet".localized, for: .normal)
        }
        else {
            disableProfileBtn.setTitle("Disable Valet".localized, for: .normal)
        }
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
        if sender.tag == 0 {
            
            controller.popupTitle = "Name".localized
            controller.popupDescription = "Enter Name Here".localized
            controller.TextFiled = Agent.fullName //Shared.sharedInfo.userModel.data?.fullName
           
            controller.placeHolder = "Name".localized
            controller.tfIndex = 0
            index = 0
        }
        else if sender.tag == 1{
            
            controller.popupTitle = "Email".localized
            controller.popupDescription = "Enter Email Here".localized
            controller.TextFiled = Agent.email//Shared.sharedInfo.userModel.data?.email
            controller.placeHolder = "Email".localized
            controller.tfIndex = 1
            index = 1
        }
        else if sender.tag == 2{
            
            controller.popupTitle = "Phone".localized
            controller.popupDescription = "Enter Phone no Here".localized
            
            controller.TextFiled = Agent.phone//Shared.sharedInfo.userModel.data?.phone
            controller.placeHolder = "Phone".localized
            controller.tfIndex = 2
            index = 2
        }
        else {
           
            controller.popupTitle = "Adress".localized
            controller.popupDescription = "Enter Adress Here".localized
            controller.placeHolder = "Adress".localized
            controller.TextFiled = Agent.address
            controller.tfIndex = 3
            index = 3
        }
        
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
        
        guard let auth = Shared.sharedInfo.userModel.data?.authorization else {return}
        
        LoaderManager.show(self.view, message: "Please Wait")
        ApiManager.shared.disableAgents(agentId:Agent._id!, auth: auth, success: { disable in
            LoaderManager.hide(self.view)
            print(disable.data?._id)
            let alertController = UIAlertController(title: "Alert", message: disable.message?.en, preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                if(disable.data?.isActive == 0){
                    print(disable.data?._id!)
                    self.delegate.deleteProfile(userID: disable.data?._id ?? "")
                 }else
                {
                    self.delegate.ReloadApiCall()
                }
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
    
    func myImageUploadRequest(_ text:String, Index: Int)
    {


        
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
        default:
            adressLbl.text! = text
        }
        
        
        
        
        let url = "http://216.200.116.25/valet-parking/api/auth/agent/update"

        let myUrl = URL(string: url)
        //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");

        let request = NSMutableURLRequest(url:myUrl!);
        request.httpMethod = "POST";
        guard let userToken = Shared.sharedInfo.userModel.data?.authorization else {return}
        guard let companyId = Shared.sharedInfo.userModel.data?._id else {return}
        guard let agentId = Agent._id else {return}
         //menow
        let param = [
            "token":userToken,
            "fullName": nameLbl.text!/*name ?? Agent.fullName!*/,
            "email" : emailLbl.text!/*email ?? Agent.email!*/,
            "phone" : phoneLbl.text!/*Phone ?? Agent.phone!*/,
            "address" :adressLbl.text!/*Adress ?? Agent.address!*/,
            "company" : companyId,
            "_id" : agentId
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
                    let a = swiftY["message"]["en"].string!
                    
                    
                    
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Agent Updated", message: a, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            //menow
                            let user = swiftY["data"]["fullName"].string!
                            let email = swiftY["data"]["email"].string!
                            let phone = swiftY["data"]["phone"].string!
                            let image = swiftY["data"]["image"].string!
                            
                            self.Agent.fullName = user
                            self.Agent.email = email
                            self.Agent.image = image
                            self.Agent.phone = phone
                            Shared.sharedInfo.userStatsName = user
                            self.navigationController?.popViewController(animated: true)
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
extension agentProfileForAdminViewController: PopupViewControllerDelegate {
    
    func didSelectNegativeBtn(text: String?, index: Int?) {
        
        if text?.isEmpty == true {
            ToastManager.showToastMessage(message: "Field Shouldn't be empty")
        }
        else {
            myImageUploadRequest(text!, Index: index!)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func didSelectPositiveBtn(text: String?) {
        
       self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    

    
//    func didSelectNegativeBtn(identifier: Int?) {
//        self.dismiss(animated: true, completion: nil)
//    }
}

extension agentProfileForAdminViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            agentProfile.image = img
            
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            agentProfile.image = img
        }
        dismiss(animated: true, completion: {self.myImageUploadRequest(self.nameLbl.text!, Index: 4)})
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.profileBottomCst.constant = 15
//        self.profileTopCst.constant = 15
//        self.profileLeadingCst.constant = 15
//        self.profileTrailngCst.constant = 15
        
        dismiss(animated: true, completion: {
           // self.myImageUploadRequest(self.nameLbl.text!)
            
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






