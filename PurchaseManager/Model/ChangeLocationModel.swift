//
//  ChangeLocationModel.swift
//  PurchaseManager
//
//  Created by Mahesh on 17/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import Foundation
class ChangeLocationModel{
    var cityId :String!
    var city:String!
    
    init(data:JSON) {
        self.city = data["city"].stringValue
        self.cityId = data["cityId"].stringValue
    }
    
}
