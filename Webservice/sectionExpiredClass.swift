//
//  sectionExpiredClass.swift
//  CleanseCar
//
//  Created by Apple on 08/08/18.
//  Copyright © 2018 CleanseCar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class sectionExpiredClass {
    
    static func ClearData(controller: UIViewController){
        
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "LoginResponse")
        prefs.removeObject(forKey: "session")
        prefs.removeObject(forKey: "FCMTOKEN")
        prefs.removeObject(forKey: "updateDeviceDetails")
        prefs.removeObject(forKey: "ProfileData")

        prefs.synchronize()
              InstanceID.instanceID().deleteID(handler: { (error) in
        //            print(error?.localizedDescription ?? "")
                    InstanceID.instanceID().instanceID(handler: { (result, errorInsta) in
        //                print(errorInsta?.localizedDescription ?? "")
        //                print(result?.instanceID ?? "")
                        if error == nil {
                            Messaging.messaging().shouldEstablishDirectChannel = true
                        }
                    })
                })
                
                try? Auth.auth().signOut()
                controller.navigationController?.viewControllers = [controller.controllerWithMainStoryBoard(withIdentifier: LoginPageVC.className)]

    }
}
