//
//  AgentStatsData.swift
//  ValetParking
//
//  Created by iOSDev on 12/11/18.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import Foundation
import ObjectMapper

struct AgentStatsData : Mappable {
    var date : String?
    var count : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        date <- map["date"]
        count <- map["count"]
    }
    
}
//struct AgentStatsData : Mappable {
//    var image : String?
//    var fcm : String?
//    var isActive : Int?
//    var verificationCode : String?
//    var isLoggedIn : String?
//    var userType : String?
//    var _id : String?
//    var email : String?
//    var fullName : String?
//    var address : String?
//    var phone : String?
//    var company : String?
//    var role : String?
//    var createdAt : String?
//    var updatedAt : String?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        image <- map["image"]
//        fcm <- map["fcm"]
//        isActive <- map["isActive"]
//        verificationCode <- map["verificationCode"]
//        isLoggedIn <- map["isLoggedIn"]
//        userType <- map["userType"]
//        _id <- map["_id"]
//        email <- map["email"]
//        fullName <- map["fullName"]
//        address <- map["address"]
//        phone <- map["phone"]
//        company <- map["company"]
//        role <- map["role"]
//        createdAt <- map["createdAt"]
//        updatedAt <- map["updatedAt"]
//    }
//
//}
