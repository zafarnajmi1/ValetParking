//
//  ToastManager.swift
//  ValetParking
//
//  Created by My Technology on 03/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import Foundation
import SwiftMessageBar

class ToastManager {
    static func showToastMessage(message: String) {
        //        let toast = iToast.makeText(message)?.setGravity(iToastGravity.init(1000003))
                //toast?.show()
        SwiftMessageBar.showMessage(withTitle: "Error", message: message, type: .error)//showMessageWithTitle("Error", message: message, type: .error)
    }
}
