//
//  CustomError.swift
//  ValetParking
//
//  Created by My Technology on 03/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import Foundation
import ObjectMapper

class CustomError : Mappable {
    var message: String?
    
    init(_ message: String) {
        self.message = message
    }
    
    required init?(map: Map) {
        let requiredKey = "error"
        let keys = Array(map.JSON.keys)
        
        if !keys.contains(requiredKey) {
            return nil
        }
    }
    
    func mapping(map: Map) {
        message <- map["error"]
    }
}

