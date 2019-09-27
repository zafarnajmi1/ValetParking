//
//  AppDelegate.swift
//  ValetParking
//
//  Created by Zafar Najmi on 10/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import IQKeyboardManagerSwift
import UserNotifications

import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var defaults = UserDefaults.standard
    var deviceFcmToken = "0"

    var isFromMenuu = false
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let storyBoard = UIStoryboard.mainStoryboard
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //menow
        UINavigationBar.appearance(whenContainedInInstancesOf: [UIImagePickerController.self]).tintColor = .white
        
  //customizeNavigationBar()
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
//            statusBar.backgroundColor = UIColor.blue
//        }
//        UIApplication.shared.statusBarStyle = .lightContent
        
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        var colors = [UIColor]()
//        colors.append(Colors.blue)
//        colors.append(Colors.Mediumblue)
//        UINavigationBar.appearance().setGradientBackground(colors:colors)
        
        let headerImage = #imageLiteral(resourceName: "Bg 2")
        UINavigationBar.appearance().setBackgroundImage(headerImage, for:.default)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        IQKeyboardManager.shared.enable = true

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        if #available(iOS 10, *)
        {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        else{
            UIApplication.shared.registerUserNotificationSettings (UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        application.registerForRemoteNotifications()
        
        let fcmToken = Messaging.messaging().fcmToken
        defaults.set(fcmToken, forKey: "fcmToken")
        defaults.synchronize()
        
       //moveToHome()
        return true
    }
    
    
    
    func moveToHome() {
        
        let mainController = storyBoard.instantiateViewController(withIdentifier: "AgentHome") as! AgentHome

        
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        
        
        if lang == "ar" {
            let rightViewController = storyBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
            let nvc : UINavigationController = UINavigationController(rootViewController: mainController)
            let slideMenuController = SlideMenuController(mainViewController: nvc, rightMenuViewController: rightViewController)
            self.window?.rootViewController = slideMenuController
        }
        else {
            let leftViewController = storyBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
            let nvc: UINavigationController = UINavigationController(rootViewController: mainController)
            let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
            self.window?.rootViewController = slideMenuController
        }
        self.window?.makeKeyAndVisible()
    }
    
    func moveToAdmin() {
        
       let mainController = storyBoard.instantiateViewController(withIdentifier: "AdminHome") as! AdminHome

//        let leftViewController = storyBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
//        let nvc: UINavigationController = UINavigationController(rootViewController: mainController)
//        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
//        self.window?.rootViewController = slideMenuController
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        

        if lang == "ar" {
            let rightViewController = storyBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
            let nvc : UINavigationController = UINavigationController(rootViewController: mainController)
            let slideMenuController = SlideMenuController(mainViewController: nvc, rightMenuViewController: rightViewController)
            self.window?.rootViewController = slideMenuController
        }
        else {
            let leftViewController = storyBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
            let nvc: UINavigationController = UINavigationController(rootViewController: mainController)
            let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
            self.window?.rootViewController = slideMenuController
        }
        self.window?.makeKeyAndVisible()
    }


    
    func customizeNavigationBar() {
        
//        let color: UIColor = UIColor(red: 7/255, green: 53/255, blue: 91/255, alpha: 1.0)
//        var colors = [UIColor]()
//        colors.append(Colors.blue)
//        colors.append(Colors.Mediumblue)
//         UINavigationBar.appearance().setGradientBackground(colors: colors)
//
        var colors = [UIColor]()
        colors.append(Colors.blue)
        colors.append(Colors.Mediumblue)
        UINavigationBar.appearance().setGradientBackground(colors:colors)
        
        
       // self.navigationController?.navigationBar.setGradientBackground(colors: colors)
        //UINavigationBar.appearance().isTranslucent = true
        //UINavigationBar.appearance().tintColor =
        //UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        
        //UINavigationBar.appearance().barTintColor = UINavigationBar
        //UINavigationBar.appearance().barStyle = .blackTranslucent
        
        
        
    }
    
//    func customizeNavigationBar() {
//
//        let color: UIColor = UIColor(red: 7/255, green: 53/255, blue: 91/255, alpha: 1.0)
//        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().tintColor = UIColor.black
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
//
//        UINavigationBar.appearance().barTintColor = color
//        UINavigationBar.appearance().barStyle = .blackTranslucent
//
//   }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
extension UIStoryboard {
    
    /// EZSE: Get the application's main storyboard
    /// Usage: let storyboard = UIStoryboard.mainStoryboard
    public static var mainStoryboard: UIStoryboard {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else {
            return UIStoryboard()
        }
        return UIStoryboard(name: name, bundle: bundle)
    }
}

extension AppDelegate : MessagingDelegate
{
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String)
    {
        print("Firebase registration token: \(fcmToken)")
        
        let token = Messaging.messaging().fcmToken
        defaults.set(token, forKey: "fcmToken")
        defaults.synchronize()
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        #if PROD_BUILD
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        #else
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #endif
        
        Messaging.messaging().apnsToken = deviceToken
        
//        if let refreshedToken = InstanceID.instanceID().token() {
//            print("Firebase: InstanceID token: \(refreshedToken)")
//            self.deviceFcmToken = refreshedToken
//            defaults.setValue(refreshedToken, forKey: "fcmToken")
//            defaults.synchronize()
//            print("Firebase: did refresh fcm token: \(deviceToken) with: \(deviceFcmToken)")
//            
//            print(UserDefaults.standard.value(forKey: "fcmToken"))
//        } else {
//        }
    }
}

