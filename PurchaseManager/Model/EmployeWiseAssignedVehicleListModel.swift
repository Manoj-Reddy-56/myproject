//
//  EmployeWiseAssignedVehicleListModel.swift
//  PurchaseManager
//
//  Created by Mahesh on 17/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import Foundation
class EmployeWiseAssignedVehicleListModel{
    var vehicleName:String!
    var manufacturedYM:String!
    var odometer:String!
    var fuelType:String!
    var registrationNo:String!
    var gearSystem:String!
    var noOfOwners:String!
    var assignedOn:String!
    var vehicleId:String!
    var custName:String!
    var custPhNo:String!
    var status:String!
    
    init(data:JSON) {
        self.vehicleName = data["vehicleName"].stringValue
        self.manufacturedYM = data["manufacturedYM"].stringValue
        self.odometer = data["odometer"].stringValue
        self.fuelType = data["fuelType"].stringValue
        self.registrationNo = data["registrationNo"].stringValue
        self.gearSystem = data["gearSystem"].stringValue
        self.noOfOwners = data["noOfOwners"].stringValue
        self.assignedOn = data["assignedOn"].stringValue
        self.vehicleId = data["vehicleId"].stringValue
        self.custName = data["custName"].stringValue
        self.custPhNo = data["custPhNo"].stringValue
        self.status = data["status"].stringValue
    }
}
