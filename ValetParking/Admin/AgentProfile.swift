//
//  AgentProfile.swift
//  ValetParking
//
//  Created by Zafar Najmi on 18/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class AgentProfile: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var AgentProfileFieldsView: UIView!
    @IBOutlet weak var AgentProfileImage: UIImageView!
    @IBOutlet weak var ViewStatus: UIButton!
    @IBOutlet weak var DisableProfile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.ViewStatus.ButtonDesign()
        //self.DisableProfile.ButtonDesign()
        //self.AgentImageDesign()
         //self.FiledsView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func AgentImageDesign()
    {
        
        self.AgentProfileImage.layer.cornerRadius = 50//self.AgentProfileImage.frame.size.width / 2;
        self.AgentProfileImage.clipsToBounds = true
        self.AgentProfileImage.layer.borderColor = UIColor.lightGray.cgColor
        self.AgentProfileImage.layer.borderWidth = 0.5
    }
    
     func FiledsView()
     {
//        self.AgentProfileFieldsView.layer.cornerRadius = 5
//        self.AgentProfileFieldsView.layer.borderColor = UIColor.lightGray.cgColor
//        self.AgentProfileFieldsView.layer.borderWidth = 0.5
//         self.AgentProfileFieldsView.clipsToBounds = true
     }
   
    
    @IBAction func DisableAction(_ sender: Any) {
        
        
    }
    
    @IBAction func View(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompanyProfileVC") as! CompanyProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: UIBarButtonItem) {
        appDelegate.moveToHome()
    }
    
}
