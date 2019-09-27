//
//  ErrorReporting.swift
//  ValetParking
//
//  Created by macbook on 23/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import Foundation
import UIKit

class ErrorReporting {
    
    static func showMessage(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
}
