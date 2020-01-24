//
//  StatusListModel.swift
//  PurchaseManager
//
//  Created by Mahesh on 25/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import Foundation
class StatusListModel {
    var onboardTypeId:String!
    var onboardType:String!
    
    init(data:JSON){
        self.onboardType = data["onboardType"].stringValue
        self.onboardTypeId = data["onboardTypeId"].stringValue
    }
}
