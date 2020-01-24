//
//  ImagesListModel.swift
//  PurchaseManager
//
//  Created by Mahesh on 18/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import Foundation
class ImagesListModel {
    var labelImage:String!
    var labelId:String!
    var labelName:String!
    
    init(data:JSON) {
        
        self.labelId = data["labelId"].stringValue
        self.labelImage = data["labelImage"].stringValue
        self.labelName = data["labelName"].stringValue
    }
}
