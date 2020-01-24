//
//  VehicleIndividualPartsListModel.swift
//  PurchaseManager
//
//  Created by Mahesh on 18/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import Foundation
class VehicleIndividualPartsListModel{
    var conditionName:String!
    var subDetails:String!
    var partImage:String!
    
    init(data:JSON) {
        self.conditionName = data["conditionName"].stringValue
        self.partImage = data["partImage"].stringValue
        self.subDetails = data["subDetails"].stringValue
    }
}
