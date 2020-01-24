//
//  RejectedAndRescheduledListModel.swift
//  PurchaseManager
//
//  Created by Mahesh on 19/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import Foundation
class RejectedAndRescheduledListModel{
    var employeeName:String!
    var vehicleName:String!
    var comments:String!
    var registrationNo:String!
    var vehicleId:String!
    var custName:String!
    var custPhNo:String!
    
    init(data:JSON) {
        self.employeeName = data["employeeName"].stringValue
        self.vehicleName = data["vehicleName"].stringValue
        self.comments = data["comments"].stringValue
        self.registrationNo = data["registrationNo"].stringValue
        self.vehicleId = data["vehicleId"].stringValue
        self.custName = data["custName"].stringValue
        self.custPhNo = data["custPhNo"].stringValue
    }
    
}
