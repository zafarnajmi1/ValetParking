//
//  ParkedCarHistoryVC.swift
//  ValetParking
//
//  Created by Zafar Najmi on 18/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class ParkedCarHistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var navColor = UIColor(red: 38/255, green: 74/255, blue: 254/255, alpha: 1.0)
    
    var carArray = [CarHistoryCars]()
    var carObj = CarHistoryPagination()
    //var carArray = [Cars]()
    
    @IBOutlet var carCount: UILabel!
    @IBOutlet var parkedHistoryLabel: UILabel!
    var fetchingMore = false
    var page = 1
    var isHide = 0
    
    @IBOutlet var parkedHistoryTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return carArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parkedCarCell", for: indexPath) as! ParkedHistoryCell
        
        let time = carArray[indexPath.row].createdAt
        let secondTime = carArray[indexPath.row].updatedAt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: time!)
        let secondDate = dateFormatter.date(from: secondTime!)
        
        
        
        let outputFormatter =  DateFormatter()
        //outputFormatter.dateFormat = "yyyy-MM-dd"
        outputFormatter.dateFormat = "hh:mm a dd-MM-yyyy"
        let resultString = outputFormatter.string(from: date!)
        let secondString = outputFormatter.string(from: secondDate!)
       
       
        
        cell.carNumberLbl.text = carArray[indexPath.row].carNumber
        cell.carTimeLbl.text = carArray[indexPath.row].userName //resultString
        cell.nameLbl.text = carArray[indexPath.row].parkingEndAgent?.fullName
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //ApiCall(page)
        ApiCall(page)
        //carArray = nil
        carObj = nil
        isHide = 1
        parkedHistoryTableView.setBorderWidth(width: 0.5)
        parkedHistoryTableView.setBorderColor(color: Colors.lightGrey)
        
        parkedHistoryLabel.text = "Parked Cars".localized
        self.title = "Parked Car History".localized
        parkedHistoryTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
        self.navigationItem.hidesBackButton = true
        //self.title = "Valet"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let bell_button = UIButton(type: .system)
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            bell_button.setImage(#imageLiteral(resourceName: "Ar-back").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else {
            bell_button.setImage(#imageLiteral(resourceName: "back-2").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        bell_button.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let ctrl = segue.destination as? CarDetailFromNotificationsViewController {
            if let index = sender as? Int {

                //Shared.sharedInfo.historyObj = carArray[index]
                //ctrl.car = carArray[index]
            }




        }


    }
    
    @objc func back(_ sender:Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.parkedHistoryTableView.isHidden = false

        //carObj = nil
        
    }
    func ApiCall(_ page:Int) {
        //self.fetchingMore = false
        guard let auth = Shared.sharedInfo.userModel.data?.authorization else {return}
        LoaderManager.show(self.view)
        ApiManager.shared.getCarHistory(page: page, auth: auth, success: { cars in
            LoaderManager.hide(self.view)
            self.parkedHistoryTableView.isHidden = false
            print(cars.data?.cars!)
            
            self.carObj = cars.data?.pagination
            self.carArray += (cars.data?.cars)!
            let car = String(self.carArray.count)
            self.carCount.text = car + " Cars".localized
            self.parkedHistoryTableView.reloadData()
            
        }, failure: {error in
            
        })
    }
    
    
    
    func setNavigationBar(){
       
        let color: UIColor = navColor
        //self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Poppins", size: 20)!]
        self.navigationController!.navigationBar.barTintColor = color
        self.navigationController!.navigationBar.barStyle = .blackOpaque
        //self.navigationController?.navigationBar.backgroundImage(for: .default) = #imageLiteral(resourceName: "Bg 2")
        
        
    }
    
    @objc func notification_message(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
       
    }
    
    deinit {
        
        carObj = nil
        carArray = []
    }
    
    func addMenu() {
        let buttonLeftMenu = UIButton (type: .custom)
        let imageLeftmenu = UIImage (named: "Menu")
        let tintedLeftImage = imageLeftmenu?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        buttonLeftMenu.setImage(tintedLeftImage, for: .normal)
        buttonLeftMenu.tintColor = UIColor.white
        buttonLeftMenu.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        buttonLeftMenu.addTarget(self, action: #selector(actionLeftMenu(_:)), for: .touchUpInside)
        let item = UIBarButtonItem(customView: buttonLeftMenu)
        self.navigationItem.setLeftBarButton(item, animated: true)
        
//        let bell_button = UIButton(type: .system)
//        bell_button.setImage(#imageLiteral(resourceName: "Notification").withRenderingMode(.alwaysOriginal), for: .normal)
//        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        //bell_button.addTarget(self, action: #selector( notification_message(_:)), for: .touchUpInside)
        
        //navigationItem.rightBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
    }
    
    
    @IBAction func menuBtnAction(_ sender: UIButton) {
        self.toggleLeft()
    }
    
   
    
    @objc func actionLeftMenu (_ sender: Any)
    {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backBtnAction(_ sender: Any) {
        appDelegate.moveToHome()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parkedCarCell", for: indexPath) as! ParkedHistoryCell
        Shared.sharedInfo.historySugue = true
        
        Shared.sharedInfo.historyObj = carArray[indexPath.row]
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "CarDetailAdminArea") as?  //MEnow JustTest CarDetailAdminArea
//        vc?.car.parkingStartImage = carArray[indexPath.row].parkingStartImage
//        vc?.car.createdAt = carArray[indexPath.row].createdAt
//        vc?.car.updatedAt = carArray[indexPath.row].updatedAt
//         vc?.car.phone = carArray[indexPath.row].phone
//        vc?.car.userName = carArray[indexPath.row].userName
//        vc?.car.email = carArray[indexPath.row].email
//        vc?.car.carNumber = carArray[indexPath.row].carNumber
//        self.navigationController?.pushViewController(vc!, animated: true)
        
        self.performSegue(withIdentifier: "historyDetail", sender: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        let contentHieght = scrollView.contentSize.height
        
        if offSetY > contentHieght - scrollView.frame.height {
            if !fetchingMore
            {
                beginBatchFetch()
            }
            
        }
        
        
    }
    
    func beginBatchFetch() {
        
        fetchingMore = true
       
        if carObj?.page != nil {
            
            if (carObj?.page)! < (carObj?.pages)! {
                page += 1
                ApiCall(page)
            }
        }
       
        
    }
    
    
    

}







