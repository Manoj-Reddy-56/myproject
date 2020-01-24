//
//  vehicleAllPartsModel.swift
//  PurchaseManager
//
//  Created by Mahesh on 18/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import Foundation
class vehicleAllPartsMode {
    var detailPartId:String!
    var detailPartName:String!
    var havingImages:String!
    
    init(data:JSON) {
        self.detailPartId = data["detailPartId"].stringValue
        self.detailPartName = data["detailPartName"].stringValue
        self.havingImages = data["havingImages"].stringValue
    }
}
