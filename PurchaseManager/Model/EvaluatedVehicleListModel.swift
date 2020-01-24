//
//  EvaluatedVehicleListModel.swift
//  PurchaseManager
//
//  Created by Mahesh on 17/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import Foundation
class EvaluatedVehicleListModel{
    var vehicleName:String!
    var manufacturedYM:String!
    var odometer:String!
    var fuelType:String!
    var vehicleImage:String!
    var registrationNo:String!
    var gearSystem:String!
    var noOfOwners:String!
    var vehicleId:String!
    
    init(data:JSON) {
        self.vehicleName = data["vehicleName"].stringValue
        self.manufacturedYM = data["manufacturedYM"].stringValue
        self.odometer = data["odometer"].stringValue
        self.fuelType = data["fuelType"].stringValue
        self.vehicleImage = data["vehicleImage"].stringValue
        self.registrationNo = data["registrationNo"].stringValue
        self.gearSystem = data["gearSystem"].stringValue
        self.noOfOwners = data["noOfOwners"].stringValue
        self.vehicleId = data["vehicleId"].stringValue
    }
    
    
    
}
