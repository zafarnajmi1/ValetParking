//
//  helpNewViewController.swift
//  ValetParking
//
//  Created by My Technology on 14/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//
//
//  Help.swift
//  ValetParking
//
//  Created by Zafar Najmi on 18/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class helpNewViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var HelpLbl: UILabel!
    var imgarr = [UIImage(named: "Help1"),UIImage(named: "Help-2"),UIImage(named: "Help-3"),UIImage(named: "Help-4"),UIImage(named: "Help-5"),UIImage(named: "Help1")]
    var lblarr = ["Take Picture","Fill Details","Park Vehicle","Get Notified","Release Vehicle","Take Picture"]
    var idarr = ["1","2","3","4","5","6"]
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        HelpLbl.text = "Feeling Lost?y".localized
        self.setNavigationBar()
        //self.addMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgarr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = collectionView.dequeueReusableCell(withReuseIdentifier: "HelpDataCell", for: indexPath) as! HelpDataCell
        data.imghelp.image = imgarr[indexPath.row]
        data.lblHelpname.text = lblarr[indexPath.row].localized
        data.lblid.text = idarr[indexPath.row]
        return data
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
    
    var navColor = UIColor(red: 38/255, green: 74/255, blue: 254/255, alpha: 1.0)
    func setNavigationBar(){
        self.title = "Help".localized
        let color: UIColor = navColor
        
        let headerImage = #imageLiteral(resourceName: "Bg 2")
        self.navigationController?.navigationBar.setBackgroundImage(headerImage, for:.default)
        
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
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
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Poppins", size: 20)!]
        //self.navigationController!.navigationBar.barTintColor = color
        //self.navigationController!.navigationBar.barStyle = .blackOpaque
    }
    
    @objc func notification_message(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
//    func addMenu() {
//        let buttonLeftMenu = UIButton (type: .custom)
//        let imageLeftmenu = UIImage (named: "Menu")
//        let tintedLeftImage = imageLeftmenu?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        buttonLeftMenu.setImage(tintedLeftImage, for: .normal)
//        buttonLeftMenu.tintColor = UIColor.white
//        buttonLeftMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        //buttonLeftMenu.addTarget(self, action: #selector(actionLeftMenu(_:)), for: .touchUpInside)
//        let item = UIBarButtonItem(customView: buttonLeftMenu)
//        self.navigationItem.setLeftBarButton(item, animated: true)
//
//        let bell_button = UIButton(type: .system)
//        bell_button.setImage(#imageLiteral(resourceName: "Notification").withRenderingMode(.alwaysOriginal), for: .normal)
//        bell_button.frame = CGRect(x: 0, y:0, width: 30, height: 30)
//        bell_button.addTarget(self, action: #selector( notification_message(_:)), for: .touchUpInside)
//
//        navigationItem.rightBarButtonItems  = [UIBarButtonItem(customView: bell_button)]
//    }
    
    
   
    
}
