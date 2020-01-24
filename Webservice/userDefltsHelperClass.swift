//
//  userDefltsHelperClass.swift
//  CleanseCar
//
//  Created by Apple on 18/07/18.
//  Copyright © 2018 CleanseCar. All rights reserved.
//

import UIKit

class UserDefaultsHelperClass {
    
    static let authKey = "authKey";
    static let authExpiry = "expiresOn";
    static let reAuthKey = "reAuthKey";
    static let userId = "employeeId";
    
    static let shared = UserDefaultsHelperClass()
    
    let defaults: UserDefaults = {
        return UserDefaults.standard
        }()
    
    func getData() {
        
    }
    
}
