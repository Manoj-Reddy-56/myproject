//
//  SessionHelperClass.swift
//  CleanseCar
//
//  Created by Apple on 18/07/18.
//  Copyright © 2018 CleanseCar. All rights reserved.
//

import UIKit

class SessionHelperClass {
    
    static let SessionName = "session";
    
    static let AuthKey = "authKey";
    static let AuthExpiry = "expiresOn";
    static let ReAuthKey = "reauthKey";
    static let UserId = "employeeId";
    
    static let shared = SessionHelperClass()
    
    let defaults: UserDefaults = {
        return UserDefaults.standard
        }()
    
    func getSession() -> JSON? {
        if let sessionObj = defaults.object(forKey: SessionHelperClass.SessionName) {
            return JSON(sessionObj)
        }
        return nil
    }
    
    func setSession(session: JSON) {
        defaults.set(session.dictionaryObject!, forKey: SessionHelperClass.SessionName)
        defaults.synchronize()
    }
    
    func isvalidSession() -> Bool {
        if defaults.object(forKey: SessionHelperClass.SessionName) != nil {
            return true
        }
        return false
    }
    
    func getAuthKey() -> String? {
        if let sessionObj = defaults.object(forKey: SessionHelperClass.SessionName) {
            return JSON(sessionObj)[SessionHelperClass.AuthKey].stringValue
        }
        return nil
    }
    
    func getReAuthKey() -> String? {
        if let sessionObj = defaults.object(forKey: SessionHelperClass.SessionName) {
            return JSON(sessionObj)[SessionHelperClass.ReAuthKey].stringValue
        }
        return nil
    }
    
    func getAuthExpiry() -> String? {
        if let sessionObj = defaults.object(forKey: SessionHelperClass.SessionName) {
            return JSON(sessionObj)[SessionHelperClass.AuthExpiry].stringValue
        }
        return nil
    }
    
    func getUserId() -> String? {
        if let sessionObj = defaults.object(forKey: SessionHelperClass.SessionName) {
            return JSON(sessionObj)[SessionHelperClass.UserId].stringValue
        }
        return nil
    }
    
}
