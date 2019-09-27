//
//  CarDetailVC.swift
//  ValetParking
//
//  Created by Zafar Najmi on 16/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import AlamofireImage
import NVActivityIndicatorView


class CarDetailVC: UIViewController {
    @IBOutlet var lblemail: UILabel!
    @IBOutlet var UserEmailLbl: UILabel!
    
    @IBOutlet var carImage: UIImageView!
    @IBOutlet var VehicleNoLbl: UILabel!
    @IBOutlet var phoneNoLbl: UILabel!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var vehicleNoTitle: UILabel!
    @IBOutlet var userNameTitle: UILabel!
    
    @IBOutlet var parkTitle: UILabel!
    
    @IBOutlet var releaseTitle: UILabel!
    @IBOutlet var PhoneNoTitle: UILabel!
    @IBOutlet var parkTimeLbl: UILabel!
    @IBOutlet var ReleaseTimeLbl: UILabel!
    @IBOutlet weak var CarDetailView: UIView!
    @IBOutlet weak var ReleaseCarNow: UIButton!
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    
    var car = Cars()
    
    var index:String?
    override func viewDidLoad() {
        
        PhoneNoTitle.text = "Phone no:".localized
        releaseTitle.text = "Release Time".localized
        lblemail.text = "Email:".localized
        ReleaseCarNow.setTitle("Release Car Now".localized, for: .normal)
        
        vehicleNoTitle.text = "Vehicle no:".localized
        
        userNameTitle.text = "Name:".localized
        
        carImage.image = nil
        super.viewDidLoad()
        //parkTitle.text = "Park Time"
        if car.status == "completed" 
        {
            ReleaseCarNow.isHidden = true
        }
        
        print(car.status)
        
        parkTitle.text = "Park Time".localized
        
        guard let Role = Shared.sharedInfo.userModel.data?.role?.roleType else {return}
        
        if Role == "Company" {
            ReleaseCarNow.isHidden = true
        }
          
        if car.status == "pending" || car.status == "inprogress"
        {
            ReleaseTimeLbl.text = "Still Parked".localized
        }
        
        
      
        //self.CardetailNAbigationbar()
        
//        self.ReleasetimeView.UIViewDesign()
//        self.ParkedTimeView.UIViewDesign()
//        self.CarDetailView.UIViewDesign()
//
//       self.ReleaseCarNow.CarReleaseButton()
       
        
        setApiData()
        
        
        
       
       
        
        setNavigationBar()
        
        
    }
    
    
    
    func setNavigationBar(){
        self.title = "Car Detail"
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
        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        bell_button.addTarget(self, action: #selector( notification_message(_:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
    }
    
    @objc func notification_message(_ sender: Any)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func getTimeFromTimeStamp(timeStamp : Double) -> String
    {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let currentDate = Date()
        let second = currentDate.secondsInBetweenDate(date)
        let minutes : Int = Int(second/60)
        let hours : Int = Int(second/3600)
        let days  : Int = Int(second/(3600 * 24))
        
        if (days > 0 && days < 31)
        {
            return String(days) + " days ago"
        }
        
        if(hours > 0 && hours < 25)
        {
            return String(hours) + " hours ago"
        }
        if(minutes > 0 && minutes < 60)
        {
            return String(minutes) + " minutes ago"
        }
        
        if(second > 5 && second < 60)
        {
            let sec : Int = Int(round(second))
            return String(sec) + " second ago"
        }
        if(second <= 5)
        {
            return "just now"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    func getDiffernce(toTime:Date) -> Int{
        let elapsed = NSDate().timeIntervalSince(toTime)
        return Int(elapsed * 1000)
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let ctrl = segue.destination as? CarDetailAdminArea {
           
                
            
                ctrl.car = car
            }
        
        
            
            
            
            
        }
    
   
    

  
   
    func setApiData() {
 
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
            print(resultString)
            parkTimeLbl.text =  resultString
            if car.status == "pending" || car.status == "inprogress" {
                ReleaseTimeLbl.text = "Still Parked".localized
            }
            else {
                ReleaseTimeLbl.text = secondString
            }
        
        
//        self.activityIndicator.startAnimating()
//        self.listImageView.af_setImageWithURL(
//            NSURL(string: list!.image!)!,
//            placeholderImage: nil,
//            filter: nil,
//            imageTransition: .CrossDissolve(0.5),
//            completion: { response in
//                let image = response.result.value // UIImage Object
//                self.activityIndicator.stopAnimating()
//        }
//        )
        
            LoaderManager.show(carImage)
        
        if let imageUrl = car.parkingStartImage {
            let url = URL(string: imageUrl)
            self.carImage.af_setImage(withURL: url!, placeholderImage: nil, filter: nil,  imageTransition:.crossDissolve(0.5)) { response in
                let image = response.result.value
                LoaderManager.hide(self.carImage)
            }
            //LoaderManager.hide(self.view)
        }
           // print(imageUrl!)
        
            
            VehicleNoLbl.text = car.carNumber
            userNameLbl.text = car.userName
            phoneNoLbl.text = car.phone
            UserEmailLbl.text = car.email
        
    }
    
  
    
    @IBAction func ReleasCarAction(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdminHome") as! AdminHome
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    func CardetailNAbigationbar()
    {
        self.title = "Car Detail"
        let vc = navigationController?.viewControllers.first
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        let button = UIBarButtonItem(title: "Go Back", style: .plain, target: self, action: nil)
        
        vc?.navigationItem.backBarButtonItem = button
    }
    
}
extension UIButton
{
    func CarReleaseButton()
    {
        self.layer.cornerRadius = 8
    }
}
extension UIView
{
    func UIViewDesign()
    {
    self.layer.cornerRadius = 5
    self.layer.borderWidth = 0.5
    self.layer.borderColor = UIColor.lightGray.cgColor
    }
}

extension Date {
    public func secondsInBetweenDate(_ date: Date) -> Double {
        var diff = self.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff)
        return diff
    }
}




