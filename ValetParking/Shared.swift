//
//  Shared.swift
//  ValetParking
//
//  Created by My Technology on 04/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import Foundation
import UIKit


class Shared {
static let sharedInfo = Shared()
    
    private init () {
        
    }
    
    var userModel = LoginMain()
    var settingModel = SettingsMain()
    var languageBackButton = 0
    var settingObj = 0
    var notificationId = ""
    var userStatsName = ""
    var historyObj = CarHistoryCars()
    var historySugue = false
    
    var chk_is_Store: Bool?
    {
        set{
            UserDefaults.standard.set(newValue , forKey: "chk_is_Store")
            UserDefaults.standard.synchronize()
            
        }
        get{
            
            return UserDefaults.standard.bool(forKey:  "chk_is_Store")
        }}
    
    var fbRegister: Bool?
    {
        set{
            UserDefaults.standard.set(newValue , forKey: "fbRegister")
            UserDefaults.standard.synchronize()
            
        }
        get{
            
            return UserDefaults.standard.bool(forKey:  "fbRegister")
        }}
    
    var GmailRegister: Bool?
    {
        set{
            UserDefaults.standard.set(newValue , forKey: "GmailRegister")
            UserDefaults.standard.synchronize()
            
        }
        get{
            
            return UserDefaults.standard.bool(forKey:  "GmailRegister")
        }}
    
    var AutoLogin: Bool?
    {
        set{
            UserDefaults.standard.set(newValue , forKey: "isAutoLogin")
            UserDefaults.standard.synchronize()
            
        }
        get{
            
            return UserDefaults.standard.bool(forKey:  "isAutoLogin")
        }}
    var socialName : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "socialName")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "socialName")
        }
    }
    
    var LoginMethod : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "LoginMethod")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "LoginMethod")
        }
    }
    
    var AccountType : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "AccountType")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "AccountType")
        }
    }
    
    var FirstName : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "FirstName")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "FirstName")
        }
    }
    var lastName : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "lastName")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "lastName")
        }
    }
    
    
    var userId : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "userId")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "userId")
        }
    }
    
    var userImg : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "userImg")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "userImg")
        }
    }
    
    
    var socialEmail : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "socialEmail")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "socialEmail")
        }
    }
    
    var socialId : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "socialId")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "socialId")
        }
    }
    
    var email : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "email")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "email")
        }
    }
    
    var password : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "password")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "password")
        }
    }
    var defaultimageIndex : Int?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "defaultimageIndex")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.integer(forKey:"defaultimageIndex")
        }
    }
    
    var currency : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "currency")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "currency")
        }
    }
    var authtoken : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "authtoken")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "authtoken")
        }
    }
    
    
    ///
    var gmailName : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "gmailName")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "gmailName")
        }
    }
    
    
    var gmailSocialId : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "gmailSocialId")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "gmailSocialId")
        }
    }
    
    
    var gmailemail : String?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "gmailemail")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.string(forKey:  "gmailemail")
        }
    }
    
    
    var lat : Double?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "lat")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.double(forKey:"lat")
        }
    }
    
    var long: Double?
    {
        set
        {
            UserDefaults.standard.set(newValue , forKey: "long")
            UserDefaults.standard.synchronize()
            
        }
        get
        {
            return UserDefaults.standard.double(forKey:"long")
        }
    }
}
