/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct GetProfilePermissions : Mappable {
	var canViewUsers : Bool?
	var canStoreUser : Bool?
	var canEditUser : Bool?
	var canUpdateUser : Bool?
	var canDeleteUser : Bool?
	var canViewSubadmins : Bool?
	var canStoreSubadmin : Bool?
	var canEditSubadmin : Bool?
	var canUpdateSubadmin : Bool?
	var canDeleteSubadmin : Bool?
	var canViewRoles : Bool?
	var canStoreRole : Bool?
	var canEditRole : Bool?
	var canUpdateRole : Bool?
	var canDeleteRole : Bool?
	var canViewPages : Bool?
	var canStorePage : Bool?
	var canEditPage : Bool?
	var canUpdatePage : Bool?
	var canDeletePage : Bool?
	var canViewSliders : Bool?
	var canStoreSlider : Bool?
	var canUpdateSlider : Bool?
	var canDeleteSlider : Bool?
	var canGiveFeedback : Bool?
	var canReportError : Bool?
	var canUpdateSetting : Bool?
	var canPermissions : Bool?
	var canProfile : Bool?
	var canProfileUpdate : Bool?
	var canPasswordChange : Bool?
	var canEditSetting : Bool?
	var canViewCompanies : Bool?
	var canStoreCompany : Bool?
	var canEditCompany : Bool?
	var canUpdateCompany : Bool?
	var canDeleteCompany : Bool?
	var canViewAgents : Bool?
	var canStoreAgent : Bool?
	var canEditAgent : Bool?
	var canUpdateAgent : Bool?
	var canDeleteAgent : Bool?
	var canViewCars : Bool?
	var canStoreCar : Bool?
	var canEditCar : Bool?
	var canUpdateCar : Bool?
	var canDeleteCar : Bool?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		canViewUsers <- map["canViewUsers"]
		canStoreUser <- map["canStoreUser"]
		canEditUser <- map["canEditUser"]
		canUpdateUser <- map["canUpdateUser"]
		canDeleteUser <- map["canDeleteUser"]
		canViewSubadmins <- map["canViewSubadmins"]
		canStoreSubadmin <- map["canStoreSubadmin"]
		canEditSubadmin <- map["canEditSubadmin"]
		canUpdateSubadmin <- map["canUpdateSubadmin"]
		canDeleteSubadmin <- map["canDeleteSubadmin"]
		canViewRoles <- map["canViewRoles"]
		canStoreRole <- map["canStoreRole"]
		canEditRole <- map["canEditRole"]
		canUpdateRole <- map["canUpdateRole"]
		canDeleteRole <- map["canDeleteRole"]
		canViewPages <- map["canViewPages"]
		canStorePage <- map["canStorePage"]
		canEditPage <- map["canEditPage"]
		canUpdatePage <- map["canUpdatePage"]
		canDeletePage <- map["canDeletePage"]
		canViewSliders <- map["canViewSliders"]
		canStoreSlider <- map["canStoreSlider"]
		canUpdateSlider <- map["canUpdateSlider"]
		canDeleteSlider <- map["canDeleteSlider"]
		canGiveFeedback <- map["canGiveFeedback"]
		canReportError <- map["canReportError"]
		canUpdateSetting <- map["canUpdateSetting"]
		canPermissions <- map["canPermissions"]
		canProfile <- map["canProfile"]
		canProfileUpdate <- map["canProfileUpdate"]
		canPasswordChange <- map["canPasswordChange"]
		canEditSetting <- map["canEditSetting"]
		canViewCompanies <- map["canViewCompanies"]
		canStoreCompany <- map["canStoreCompany"]
		canEditCompany <- map["canEditCompany"]
		canUpdateCompany <- map["canUpdateCompany"]
		canDeleteCompany <- map["canDeleteCompany"]
		canViewAgents <- map["canViewAgents"]
		canStoreAgent <- map["canStoreAgent"]
		canEditAgent <- map["canEditAgent"]
		canUpdateAgent <- map["canUpdateAgent"]
		canDeleteAgent <- map["canDeleteAgent"]
		canViewCars <- map["canViewCars"]
		canStoreCar <- map["canStoreCar"]
		canEditCar <- map["canEditCar"]
		canUpdateCar <- map["canUpdateCar"]
		canDeleteCar <- map["canDeleteCar"]
	}

}
