//
//  ApiManager.swift
//  ValetParking
//
//  Created by My Technology on 03/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import ObjectMapper

class ApiManager {
    let baseUrl = "http://216.200.116.25/valet-parking/api/"
    static let shared = ApiManager()
    private init()
    {
        
    }
    
    func loginUser(email: String, password: String,fcm:String, success:  @escaping (_ user: LoginMain) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        let url = "http://216.200.116.25/valet-parking/api/login"
        let parameter: Parameters = [
                "email": email,
                "password": password,
                "fcm":fcm
            ]
     print(parameter)
        Alamofire.request(
            url,
            method: .post,
            parameters: parameter,
            encoding: URLEncoding.httpBody)
            .responseJSON { (response) -> Void in
                
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                
                if let user = Mapper<LoginMain>().map(JSONObject: response.result.value) {
                    success(user)
                    return
                }
                
                let error = CustomError("Server Error")
                print("sdasdasd")
                failure(error)
        }
    }
    
    func forgetPassword(email: String,success:  @escaping (_ password: ForgetPasswordMain) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        let url = "http://216.200.116.25/valet-parking/api/forgot/password"
        let parameter: Parameters = [
            "email": email
        ]
        
        Alamofire.request(
            url,
            method: .post,
            parameters: parameter,
            encoding: URLEncoding.httpBody)
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                
                if let password = Mapper<ForgetPasswordMain>().map(JSONObject: response.result.value) {
                    print(response.result.value!)
                    success(password)
                    return
                }
                
                let error = CustomError("Server Error")
                failure(error)
        }
    }
    
    func ResetPassword(email: String,verificationCode:String,password:String,confirmPassword:String,success:  @escaping (_ password: ForgetPasswordMain) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        let url = "http://216.200.116.25/valet-parking/api/reset/password"
        let parameter: Parameters = [
            "email": email,
            "verificationCode" : verificationCode,
            "password" : password,
            "passwordConfirmation" : confirmPassword
        ]
        
        Alamofire.request(
            url,
            method: .post,
            parameters: parameter,
            encoding: URLEncoding.httpBody)
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                
                if let password = Mapper<ForgetPasswordMain>().map(JSONObject: response.result.value) {
                    print(response.result.value!)
                    success(password)
                    return
                }
                
                let error = CustomError("Server Error")
                failure(error)
        }
    }
    
    func getCars(companyId: String,page:String,auth:String,success:  @escaping (_ cars: GetCars) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
       
        //let url = "http://216.200.116.25/valet-parking/api/auth/cars/listing?companyId=5b880147975877339f0040be&page=1"
        
       //"?query=\(query)"
        
        let company = "companyId=\(companyId)"
        let page = "&page=1"
        var url = "http://216.200.116.25/valet-parking/api/auth/cars/listing?"
        
        
        url += company
        url += page
        
        
        //            parameters: parameter,
        
        let header: HTTPHeaders = [
            "Authorization" : auth
            
        ]
       
        
        
        manager.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
            .responseJSON { (response) -> Void in
                
                
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                if let cars = Mapper<GetCars>().map(JSONObject: response.result.value) {
                    
                    success(cars)
                    return
                }
                let error = CustomError("Server Error")
                failure(error)
        }
    }
    
    func getProfile(auth:String,success:  @escaping (_ profile: GetProfileMain) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        let BaseUrl = "http://216.200.116.25/valet-parking/api/auth/cars/listing"
        print(BaseUrl)
        let url = "http://216.200.116.25/valet-parking/api/auth/profile"
        
        //            parameters: parameter,
        
        let header: HTTPHeaders = [
            "Authorization": auth
            
        ]
        manager.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
            .responseJSON { (response) -> Void in
                
                
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                if let profile = Mapper<GetProfileMain>().map(JSONObject: response.result.value) {
                    
                    success(profile)
                    return
                }
                let error = CustomError("Server Error")
                failure(error)
        }
    }
    
    func getSettings(success:  @escaping (_ setting: SettingsMain) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        let url = "http://216.200.116.25/valet-parking/api/settings"
        
       
        
        
        manager.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { (response) -> Void in
                
                
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                if let profile = Mapper<SettingsMain>().map(JSONObject: response.result.value) {
                    
                    success(profile)
                    return
                }
                let error = CustomError("Server Error")
                failure(error)
        }
    }
    
    func addAgent(fullname:String,Email:String,phone:String,Adress:String,Password:String,RePassword:String,Company:String, success:  @escaping (_ setting: AddAgentMain) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 200
        let url = "http://216.200.116.25/valet-parking/api/auth/agent/store"
        
        let parameters: Parameters = [
            "fullName": fullname,
            "email" : Email,
            "phone" : phone,
            "address" : Adress,
            "password" : Password,
            "passwordConfirmation" : RePassword,
            "company" : "5b5f0fccbd9b62d0488817fb"
        ]
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7Il9pZCI6IjViODgwMTQ3OTc1ODc3MzM5ZjAwNDBiZSJ9LCJpYXQiOjE1MzYzMDM4NDB9.FunAJPR6U1amKZQE8zDDX094G_hKQEgX4gW30ZDbN3I"
            
        ]
        
        print(headers)
        
        
        
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON  { (response) -> Void in
                
                print(response)
                
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                if let profile = Mapper<AddAgentMain>().map(JSONObject: response.result.value) {
                    
                    success(profile)
                    return
                }
                let error = CustomError("Server Error")
                failure(error)
        }
    }
    
    func getAgents(companyId: String,page:String,auth:String,success:  @escaping (_ agent: AgentListingMain) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        let BaseUrl = "http://216.200.116.25/valet-parking/api/auth/cars/listing"
        print(BaseUrl)
        let pageId = "&page=\(page)"
        print(pageId)
        
        guard let compId = Shared.sharedInfo.userModel.data?._id else {return}
        
        //let` = "companyId=\(compId)"
        let company = "companyId=\(compId)"
        
        let url = "http://216.200.116.25/valet-parking/api/auth/agents/listing?" + company + pageId
        print(url)
        
        //            parameters: parameter,
        
        let header: HTTPHeaders = [
            "Authorization": auth
            
        ]
        
        
        
        manager.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
            .responseJSON { (response) -> Void in
                
                
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                if let agents = Mapper<AgentListingMain>().map(JSONObject: response.result.value) {
                    
                    success(agents)
                    return
                }
                let error = CustomError("Server Error")
                failure(error)
        }
    }
    
    func disableAgents(agentId: String,auth:String,success:  @escaping (_ agent: AgentStatusMain) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        
        
       
        
        
        let url = "http://216.200.116.25/valet-parking/api/auth/agent/status"
        
        
        //            parameters: parameter,
        
        let header: HTTPHeaders = [
            "Authorization": auth
            
        ]
        
        let parameter: Parameters = [
            "agentId": agentId
            
        ]
        
 
        
        
        
        
        manager.request(url, method: .post,parameters: parameter, encoding: JSONEncoding.default, headers: header)
            .responseJSON { (response) -> Void in
                
                print(response.result.value)
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                if let agents = Mapper<AgentStatusMain>().map(JSONObject: response.result.value) {
                    
                    success(agents)
                    return
                }
                let error = CustomError("Server Error")
                failure(error)
        }
    }
    
    func ContactUs(name: String,email:String,subject:String,message:String,success:  @escaping (_ contact: ContactUSMain) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        let url = "http://216.200.116.25/valet-parking/api/contact-us"
        
        let parameter: Parameters = [
            "name": name,
            "email": email,
            "subject": subject,
            "message":message
            
            ]
        manager.request(url, method: .post,parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON { (response) -> Void in
                
                
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                if let message = Mapper<ContactUSMain>().map(JSONObject: response.result.value) {
                    
                    success(message)
                    return
                }
                let error = CustomError("Server Error")
                failure(error)
        }
    }
    
    func CarInProgress(carId: String,endAgentId:String,success:  @escaping (_ contact: CarInProgressMain) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        let url = "http://216.200.116.25/valet-parking/api/auth/car/pending"
        
        let parameter: Parameters = [
            "_id": carId,
            "parkingEndAgent":endAgentId
        ]
        
        let header: HTTPHeaders = [
            "Authorization": (Shared.sharedInfo.userModel.data?.authorization)!
            
        ]
        
        manager.request(url, method: .post,parameters: parameter, encoding: JSONEncoding.default,headers: header)
            .responseJSON { (response) -> Void in
                
                
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                if let message = Mapper<CarInProgressMain>().map(JSONObject: response.result.value) {
                    
                    success(message)
                    return
                }
                let error = CustomError("Server Error")
                failure(error)
        }
    }
    
    func getCarHistory(page:Int,auth:String,success:  @escaping (_ agent: CarHistoryMain) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        
        let pageId = "page=\(page)"
        
        let BaseUrl = "http://216.200.116.25/valet-parking/api/auth/cars/history?" + pageId
        print(BaseUrl)
        //let pageId = "&page=\(page)"
       
       
//        print(pageId)
//
//        guard let compId = Shared.sharedInfo.userModel.data?._id else {return}
//
//        //let` = "companyId=\(compId)"
//        let company = "companyId=\(compId)"
//
//        let url = "http://216.200.116.25/valet-parking/api/auth/agents/listing?" + company + pageId
//        let url = "http://216.200.116.25/valet-parking/api/auth/agents/listing?companyId=5b5f0fccbd9b62d0488817fb&page=1"
//        print(url)
        
        //            parameters: parameter,
        
        let header: HTTPHeaders = [
            "Authorization": auth
            
        ]
        
        
        
        manager.request(BaseUrl, method: .get, encoding: JSONEncoding.default, headers: header)
            .responseJSON { (response) -> Void in
                
                
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                if let cars = Mapper<CarHistoryMain>().map(JSONObject: response.result.value) {
                    
                    success(cars)
                    return
                }
                let error = CustomError("Server Error")
                failure(error)
        }
    }
    
    func carDetail(id:String,auth:String,success:  @escaping (_ agent: CarDetailMain) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        
        let parameter: Parameters = [
            "id": id
            
        ]
        
        let BaseUrl = "http://216.200.116.25/valet-parking/api/auth/car/car-detail" 
        //let pageId = "&page=\(page)"
        
        
        //        print(pageId)
        //
        //        guard let compId = Shared.sharedInfo.userModel.data?._id else {return}
        //
        //        //let` = "companyId=\(compId)"
        //        let company = "companyId=\(compId)"
        //
        //        let url = "http://216.200.116.25/valet-parking/api/auth/agents/listing?" + company + pageId
        //        let url = "http://216.200.116.25/valet-parking/api/auth/agents/listing?companyId=5b5f0fccbd9b62d0488817fb&page=1"
        //        print(url)
        
        //            parameters: parameter,
        
        let header: HTTPHeaders = [
            "Authorization": auth
            
        ]
        
        
        
        manager.request(BaseUrl, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header)
            .responseJSON { (response) -> Void in
                
                
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                if let car = Mapper<CarDetailMain>().map(JSONObject: response.result.value) {
                    
                    success(car)
                    return
                }
                let error = CustomError("Server Error")
                failure(error)
        }
    }
    
    
    func resetPassword(oldPassword:String,newPassword:String,confirmNewPassword:String,auth:String,success:  @escaping (_ password: ResetPasswordMain) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        
        let parameter: Parameters = [
            "oldPassword": oldPassword,
            "password" : newPassword,
            "passwordConfirmation" : confirmNewPassword
            
        ]
        
        let BaseUrl = "http://216.200.116.25/valet-parking/api/auth/change/password"
        //let pageId = "&page=\(page)"
        
        
        //        print(pageId)
        //
        //        guard let compId = Shared.sharedInfo.userModel.data?._id else {return}
        //
        //        //let` = "companyId=\(compId)"
        //        let company = "companyId=\(compId)"
        //
        //        let url = "http://216.200.116.25/valet-parking/api/auth/agents/listing?" + company + pageId
        //        let url = "http://216.200.116.25/valet-parking/api/auth/agents/listing?companyId=5b5f0fccbd9b62d0488817fb&page=1"
        //        print(url)
        
        //            parameters: parameter,
        
        let header: HTTPHeaders = [
            "Authorization": auth
            
        ]
        
        
        
        manager.request(BaseUrl, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header)
            .responseJSON { (response) -> Void in
                
                
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                if let password = Mapper<ResetPasswordMain>().map(JSONObject: response.result.value) {
                    
                    success(password)
                    return
                }
                let error = CustomError("Server Error")
                failure(error)
        }
    }
    
    
    
    func agentStats(agentId:String,Days:String,auth:String,success:  @escaping (_ password: AgentStatsMain) -> Void, failure: @escaping (_ error: CustomError) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        
        let parameter: Parameters = [
            "agentId": agentId,
            "days" : Days
           
            
        ]
        
        let BaseUrl = "http://216.200.116.25/valet-parking/api/auth/agent/stats"
        //let pageId = "&page=\(page)"
        
        
        //        print(pageId)
        //
        //        guard let compId = Shared.sharedInfo.userModel.data?._id else {return}
        //
        //        //let` = "companyId=\(compId)"
        //        let company = "companyId=\(compId)"
        //
        //        let url = "http://216.200.116.25/valet-parking/api/auth/agents/listing?" + company + pageId
        //        let url = "http://216.200.116.25/valet-parking/api/auth/agents/listing?companyId=5b5f0fccbd9b62d0488817fb&page=1"
        //        print(url)
        
        //            parameters: parameter,
        
        let header: HTTPHeaders = [
            "Authorization": auth
            
        ]
        
        
        
        manager.request(BaseUrl, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header)
            .responseJSON { (response) -> Void in
                
                
                guard response.result.isSuccess else {
                    let error = CustomError("Server Error")
                    failure(error)
                    return
                }
                if let err = Mapper<CustomError>().map(JSONObject: response.result.value) {
                    failure(err)
                    return
                }
                if let agentStats = Mapper<AgentStatsMain>().map(JSONObject: response.result.value) {
                    
                    success(agentStats)
                    return
                }
                let error = CustomError("Server Error")
                failure(error)
        }
    }
    
    
    
    
}
