//
//  AgentProfileForAgentViewController.swift
//  ValetParking
//
//  Created by My Technology on 05/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class AgentProfileForAgentViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileImgEditBtn: UIButton!
    
    @IBOutlet var viewStatsBtn: UIButton!
    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var emailLbl: UILabel!
    
    @IBOutlet var phoneLbl: UILabel!
    @IBOutlet var adressLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewStatsBtn.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.Mediumblue)
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        getProfileFromApi()
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
//        _ = navigationController?.popViewController(animated: true)
      // self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func getProfileFromApi() {
        LoaderManager.show(self.view, message: "Please Wait")
        let auth = Shared.sharedInfo.userModel.data?.authorization!
        ApiManager.shared.getProfile(auth: auth!, success: { user in
            LoaderManager.hide(self.view)
            
            let imageUrl = user.data?.image
            print(imageUrl!)
            let url = URL(string: imageUrl!)
            self.profileImage.af_setImage(withURL: url!)
            self.nameLbl.text = user.data?.fullName
            self.emailLbl.text = user.data?.email
            self.adressLbl.text = user.data?.address
            self.phoneLbl.text = user.data?.phone
            Shared.sharedInfo.userStatsName = self.nameLbl.text!
            
        }, failure: {
            error in
        })
    }
    


   

    

}
