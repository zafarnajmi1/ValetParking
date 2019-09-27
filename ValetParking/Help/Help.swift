//
//  Help.swift
//  ValetParking
//
//  Created by Zafar Najmi on 18/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class Help: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.setNavigationBar()
        self.addMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    var navColor = UIColor(red: 38/255, green: 74/255, blue: 254/255, alpha: 1.0)
//    func setNavigationBar(){
//        self.title = "Valet Parking"
//        let color: UIColor = navColor
//        self.navigationController!.navigationBar.isTranslucent = false
//        self.navigationController!.navigationBar.tintColor = UIColor.white
//        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Poppins", size: 20)!]
//        self.navigationController!.navigationBar.barTintColor = color
//        self.navigationController!.navigationBar.barStyle = .blackOpaque
//    }
    
    
    
    func addMenu() {
        let buttonLeftMenu = UIButton (type: .custom)
        let imageLeftmenu = UIImage (named: "Menu")
        let tintedLeftImage = imageLeftmenu?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        buttonLeftMenu.setImage(tintedLeftImage, for: .normal)
        buttonLeftMenu.tintColor = UIColor.white
        buttonLeftMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        buttonLeftMenu.addTarget(self, action: #selector(actionLeftMenu(_:)), for: .touchUpInside)
        let item = UIBarButtonItem(customView: buttonLeftMenu)
        self.navigationItem.setLeftBarButton(item, animated: true)
        
        let bell_button = UIButton(type: .system)
        bell_button.setImage(#imageLiteral(resourceName: "Notification").withRenderingMode(.alwaysOriginal), for: .normal)
        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
        bell_button.addTarget(self, action: #selector( notification_message(_:)), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
    }
    
    @objc func actionLeftMenu (_ sender: Any)
    {
        self.toggleLeft()
    }
    
    @objc func notification_message(_ sender: Any)
    {
        
    }

}
