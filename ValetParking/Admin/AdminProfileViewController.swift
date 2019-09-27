//
//  AdminProfileViewController.swift
//  ValetParking
//
//  Created by My Technology on 07/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class AdminProfileViewController: UIViewController {

    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileImageEditBtn: UIButton!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!
    @IBOutlet var passwordLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton

        // Do any additional setup after loading the view.
    }
    @objc func back(sender: UIBarButtonItem) {
       
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
