//
//  CityWiseEmployeNamesModel.swift
//  PurchaseManager
//
//  Created by Mahesh on 17/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import Foundation
class CityWiseEmployeNamesModel{
    var assignedVehicles:String!
    var evaluatorId:String!
    var evaluatorName:String!
    
    init(data:JSON) {
        self.assignedVehicles = data["assignedVehicles"].stringValue
        self.evaluatorId = data["evaluatorId"].stringValue
        self.evaluatorName = data["evaluatorName"].stringValue
    }
}

