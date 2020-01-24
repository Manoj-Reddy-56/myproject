//
//  PurchasedVehicleListModel.swift
//  PurchaseManager
//
//  Created by Mahesh on 25/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import Foundation
class PurchasedVehicleListModel {
    var vehicleName: String!
    var sellingPrice:String!
    var manufacturedYM: String!
    var odometer:String!
    var fuelType: String!
    var vehicleImage:String!
    var registrationNo: String!
    var gearSystem:String!
    var noOfOwners: String!
    var vehicleId:String!
    var purchasePrice: String!
    var refurbishAmnt:String!
    init(data:JSON) {
        self.vehicleName = data["vehicleName"].stringValue
        self.sellingPrice = data["sellingPrice"].stringValue
        self.manufacturedYM = data["manufacturedYM"].stringValue
        self.odometer = data["odometer"].stringValue
        self.fuelType = data["fuelType"].stringValue
        self.vehicleImage = data["vehicleImage"].stringValue
        self.registrationNo = data["registrationNo"].stringValue
        self.gearSystem = data["gearSystem"].stringValue
        self.noOfOwners = data["noOfOwners"].stringValue
        self.vehicleId = data["vehicleId"].stringValue
        self.purchasePrice = data["purchasePrice"].stringValue
        self.refurbishAmnt = data["refurbishAmnt"].stringValue
    }
}
