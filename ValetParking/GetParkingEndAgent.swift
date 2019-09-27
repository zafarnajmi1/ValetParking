//
//  GetParkingEndAgent.swift
//  ValetParking
//
//  Created by My Technology on 13/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetParkingEndAgent : Mappable {
    var _id : String?
    var image : String?
    var fullName : String?
    var email : String?
    var phone : String?
    var parkingEnd : GetParkingEnd?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        _id <- map["_id"]
        image <- map["image"]
        fullName <- map["fullName"]
        email <- map["email"]
        phone <- map["phone"]
        parkingEnd <- map["parkingEnd"]
    }
    
}

