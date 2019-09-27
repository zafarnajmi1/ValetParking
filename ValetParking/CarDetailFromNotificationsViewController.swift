//
//  CarDetailFromNotificationsViewController.swift
//  ValetParking
//
//  Created by My Technology on 17/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class CarDetailFromNotificationsViewController: UIViewController {

    
    @IBOutlet var btnReleaseNow: UIButton!
    @IBOutlet var userEmailLbl: UILabel!
    @IBOutlet var carImage: UIImageView!
    @IBOutlet var VehicleNoLbl: UILabel!
    @IBOutlet var phoneNoLbl: UILabel!
    @IBOutlet var userNameLbl: UILabel!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var releasedByLbl: UILabel!
    @IBOutlet var releasedByHeaderlbl: UILabel!
    @IBOutlet var parkedByHeaderLbl: UILabel!
    @IBOutlet var parkedByLbl: UILabel!
    @IBOutlet var parkTitle: UILabel!
    
    @IBOutlet var parkedStackView: UIStackView!
    @IBOutlet var parkTimeLbl: UILabel!
    @IBOutlet var ReleaseTimeLbl: UILabel!
    @IBOutlet weak var CarDetailView: UIView!
    @IBOutlet var releasedStackVIew: UIStackView!
    
    @IBOutlet var parktimeLbl: UILabel!
    @IBOutlet var vehicleNoTitle: UILabel!
    @IBOutlet var releasetimeLbl: UILabel!
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    @IBOutlet var userNameTitle: UILabel!
    
    @IBOutlet var phoneNoTitle: UILabel!
    
    @IBOutlet var emailTitle: UILabel!
    
    var carDetail = CarDetailMain()
    var Car = CarHistoryCars()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //This IS My Release
        //guard let car = Shared.sharedInfo.historyObj else { return }
        
        //Car = car
        
        btnReleaseNow.layer.cornerRadius = 5
        btnReleaseNow.clipsToBounds = true
        
//        if Shared.sharedInfo.historySugue == true {
//            self.setHistoryData()
//
//            print(Car?.carNumber)
//        }
        
//        if Shared.sharedInfo.notificationId.isNotEmpty {
//            let carId = Shared.sharedInfo.notificationId
//            guard let auth = Shared.sharedInfo.userModel.data?.authorization else {return}
//
//            print(carId,auth)
//            LoaderManager.show(self.view)
//            ApiManager.shared.carDetail(id: carId, auth: auth, success: { car in
//                self.mainView.isHidden = false
//                LoaderManager.hide(self.view)
//                self.carDetail = car
//                print(self.carDetail?.data?.carNumber)
//                self.setApiData()
//            }, failure: {
//                error in
//            })
//
//
//        }
        
        
        //setNavigationBar()

        // Do any additional setup after loading the view.
        
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(Shared.sharedInfo.notificationId) //menow
        vehicleNoTitle.text = "Vehicle no:".localized
        userNameTitle.text = "Name:".localized
        emailTitle.text = "Email:".localized
        phoneNoTitle.text = "Phone no".localized
        
        
        
        setNavigationBar()
        
        mainView.isHidden = true
        carImage.image = nil
        self.title = "Car Detail".localized
        print(Shared.sharedInfo.historyObj!)
        guard let car = Shared.sharedInfo.historyObj else { return }
        
        Car = car
        
        mainView.isHidden = true
        
        if Shared.sharedInfo.historySugue == true {
            
            self.btnReleaseNow.isHidden = true
            print(Car?.carNumber)
            
            self.setHistoryData()
        }
        
        if Shared.sharedInfo.notificationId.isNotEmpty {
            let carId = Shared.sharedInfo.notificationId
            guard let auth = Shared.sharedInfo.userModel.data?.authorization else {return}
            
            print(carId,auth)
            LoaderManager.show(self.view)
            ApiManager.shared.carDetail(id: carId, auth: auth, success: { car in
                self.mainView.isHidden = false
                LoaderManager.hide(self.view)
                self.carDetail = car
                print(self.carDetail?.data?.parkingStartImage)
                print(self.carDetail?.data?.carNumber)
                print(Shared.sharedInfo.userModel.data?.role?.roleType!)
                if(Shared.sharedInfo.userModel.data?.role?.roleType == "Company")
                {
                    self.btnReleaseNow.isHidden = true
                }else{
                    if(self.carDetail?.data?.status == "completed")
                    {
                        self.btnReleaseNow.isHidden = true
                        
                    }else if(self.carDetail?.data?.status == "pending")
                    {
                        self.btnReleaseNow.isHidden = false
                    }else if(self.carDetail?.data?.status == "inprogress")
                    {
                        self.btnReleaseNow.isHidden = false
                    }
                    
                    
                }
                
                
                
                self.setApiData()
            }, failure: {
                error in
            })
            
            
        }
        
//        if(carDetail?.data?.inProgress == true)
//        {
//            btnReleaseNow.isHidden = false
//
//        }else if(carDetail?.data?.inProgress == false)
//        {
//            btnReleaseNow.isHidden = true
//        }
        //"completed" "pending" "inprogress"
        
        print(carDetail?.data?.status! ?? "")
        print(carDetail?.data?.company! ?? "")
//        if(carDetail?.data?.company == "company") //menow
//        {
//            btnReleaseNow.isHidden = true
//        }else{
//                if(carDetail?.data?.status == "completed")
//                {
//                    btnReleaseNow.isHidden = true
//
//                }else if(carDetail?.data?.status == "pending")
//                {
//                    btnReleaseNow.isHidden = false
//                }else if(carDetail?.data?.status == "inprogress")
//                {
//                    btnReleaseNow.isHidden = false
//                }
//
//
//        }
//
    }
    func setApiData() {
        
        
    
            let time = carDetail?.data?.createdAt
            let secondTime = carDetail?.data?.updatedAt
            
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
        
        if carDetail?.data?.status == "pending" || carDetail?.data?.status == "inprogress" {
            ReleaseTimeLbl.text = "Still Parked".localized
        }
        else {
            ReleaseTimeLbl.text = secondString
        }
        
               // ReleaseTimeLbl.text = secondString
        
            
            VehicleNoLbl.text = carDetail?.data?.carNumber!
            userNameLbl.text = carDetail?.data?.userName!
            phoneNoLbl.text = carDetail?.data?.phone!
            userEmailLbl.text =  carDetail?.data?.email
        
//            parkedByLbl.text = carDetail?.data?.parkingStartAgent?.fullName!
//            releasedByLbl.text = carDetail?.data?.parkingStartAgent?.fullName!
        
        
        
             // print(carDetail?.data?.parkingStartAgent?.fullName)
              print(carDetail?.data?.parkingEndAgent?.fullName)
        
        LoaderManager.show(carImage)
        
        if let imageUrl = carDetail?.data?.parkingStartImage {
            let url = URL(string: imageUrl)
            self.carImage.af_setImage(withURL: url!, placeholderImage: nil, filter: nil,  imageTransition:.crossDissolve(0.5)) { response in
                let image = response.result.value
                LoaderManager.hide(self.carImage)
            }
        }
        
//        if let imageUrl = carDetail?.data?.parkingStartImage {
//
//            let url = URL(string: imageUrl)
//            //  print(url!)
//            carImage.af_setImage(withURL: url!)
//        }
           // print(imageUrl!)
        
        
    }
    
    
    
    
    @IBAction func btnActionReleaseNow(_ sender: UIButton) {
        
        //CarDetailAdminArea
        let vc = storyboard?.instantiateViewController(withIdentifier: "CarDetailAdminArea") as! CarDetailAdminArea
        if Shared.sharedInfo.historySugue == true {
            
            print(Car?.parkingStartImage)
            vc.car.parkingStartImage = Car?.parkingStartImage
            vc.car._id = Car?._id
            vc.car.createdAt = Car?.createdAt
            vc.car.updatedAt = Car?.updatedAt
            vc.car.carNumber = Car?.carNumber
            vc.car.phone = Car?.phone
            vc.car.userName = Car?.userName
            
        }else
        {
        print(carDetail?.data?.parkingStartImage!)
        vc.car.parkingStartImage = carDetail?.data?.parkingStartImage
        vc.car._id = carDetail?.data?._id
        vc.car.createdAt = carDetail?.data?.createdAt
        vc.car.updatedAt = carDetail?.data?.updatedAt
        vc.car.carNumber = carDetail?.data?.carNumber
        vc.car.phone = carDetail?.data?.phone
        vc.car.userName = carDetail?.data?.userName
        }
        self.navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true, completion: nil)
        //UINavigationController(rootViewController: vc)
    }
    
    func setHistoryData() {
         //Shared.sharedInfo.historySugue = false
        self.mainView.isHidden = false
        //Car
        
        let time = Car?.createdAt
        let secondTime = Car?.updatedAt
        
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
        
        if Car?.status == "pending" || Car?.status == "inprogress" {
            ReleaseTimeLbl.text = "Still Parked".localized
        }
        else {
            ReleaseTimeLbl.text = secondString
        }
        
        // ReleaseTimeLbl.text = secondString
        
        print(Car?.carNumber)
        VehicleNoLbl.text = Car?.carNumber!
        userNameLbl.text = Car?.userName!
        phoneNoLbl.text = Car?.phone!
         userEmailLbl.text =  Car?.email
        
        //parkedByLbl.text = Car?.parkingStartAgent?.fullName!
        //releasedByLbl.text = Car?.parkingEndAgent?.fullName!
        
       
        
        // print(carDetail?.data?.parkingStartAgent?.fullName)
       // print(carDetail?.data?.parkingEndAgent?.fullName)
        
        LoaderManager.show(carImage)
        
        if let imageUrl = Car?.parkingStartImage {
            let url = URL(string: imageUrl)
            self.carImage.af_setImage(withURL: url!, placeholderImage: nil, filter: nil,  imageTransition:.crossDissolve(0.5)) { response in
                let image = response.result.value
                LoaderManager.hide(self.carImage)
            }
        }
        
       
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Shared.sharedInfo.historyObj = nil
    }
    
    
    
    func setNavigationBar(){
        self.title = "Forget Password"
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
    
    

   

}
