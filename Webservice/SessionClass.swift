//
//  SessionClass.swift
//  LuxuryRide
//
//  Created by Apple on 18/07/19.
//  Copyright © 2018 LuxuryRide. All rights reserved.
//
import UIKit
import Alamofire
//import FirebaseAuth
//import Firebase

class SessionHandler {
    
    func reauthSessionDataServiceMethod(completion: @escaping (Bool,Bool) -> Void){
            let imei = UIDevice.current.clientID
        

        Alamofire.request(CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.session.session_reauth , method: .post, contentType: .jsonEncode, params: ["employeeId":SessionHelperClass().getUserId()!,"reauthKey": SessionHelperClass().getReAuthKey()!,"deviceImei":imei], headers: ["Content-Type":"application/json"])).responseSwiftify { (response) in
                switch response.result {
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess {
                        print("reauthsession %@",jsonResponse.response)
                    
                        SessionHelperClass().setSession(session: jsonResponse.response)

                        completion(true,false)
                    }
                    else if jsonResponse.responseType.isAuth {

                        completion(false,true)
                    }
                    else {
//                        if jsonResponse.responseType == "300"{
//                            completion(false,true)
//                        }else {
//                            completion(false,false)
//                        }
                        completion(false,true)
                    }
                    
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    
                    completion(false,false)
                    break
                }
            }
        }
    

}



