//
//  ProfileVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 11/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import UIKit
import Alamofire
import KYDrawerController
import Firebase
import FirebaseAuth

class ProfileVC: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mobileNoLabel: UILabel!
    @IBOutlet var emailIdLabel: UILabel!
    @IBOutlet var designationLabel: UILabel!
    @IBOutlet var onBoardVehicleCountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        callingProfileDataServiceAPI()
        
    }
    
    @IBAction func onTapMenuButtonAction(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    func callingProfileDataServiceAPI(){
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()

        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.Profile.DashBoard_ProfileDetails , method: .get, contentType: .urlencode, params: ["employeeId":userid], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()

            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                switch response.result {
                    
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess{
                        print(jsonResponse.response)
                       
                        self.nameLabel.text = jsonResponse.response["employeeName"].stringValue
                        self.mobileNoLabel.text = jsonResponse.response["empPhNo"].stringValue
                        self.emailIdLabel.text = jsonResponse.response["emailId"].stringValue
                   
                        self.designationLabel.text = jsonResponse.response["empRole"].stringValue
                      
                       
                    }
                        
                    else {
                        self.view.ShowBlackTostWithText(message: jsonResponse.responseMessage, Interval: 3)
                        
                    }
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    Message.SomethingWrongAlert(self)
                    self.dismiss(animated: true, completion: nil)
                    break
                }
            }
        }
    }
   
    @IBAction func onTapLogOutButtonAction(_ sender: Any) {
        Message.Alert(Title: "Warning", Message: "Are you sure you want to logout?", TitleAlign: Message.AlertTextAllignment.normal, MessageAlign: Message.AlertTextAllignment.normal, Actions: [Message.AlertActionWithSelector(Title: "Cancel"),Message.AlertActionWithSelector(Title: "Logout", { (act) in
            
            let prefs = UserDefaults.standard
            prefs.removeObject(forKey: "LoginResponse")
            prefs.removeObject(forKey: "session")
            prefs.removeObject(forKey: "FCMTOKEN")
        
            prefs.removeObject(forKey: "profileData")
            prefs.removeObject(forKey: "updateDeviceDetails")
            
            prefs.synchronize()
            
            InstanceID.instanceID().deleteID(handler: { (error) in
                print(error?.localizedDescription ?? "")
                InstanceID.instanceID().instanceID(handler: { (result, errorInsta) in
                    print(errorInsta?.localizedDescription ?? "")
                    print(result?.instanceID ?? "")
                    if error == nil {
                        //                            Messaging.messaging().shouldEstablishDirectChannel = true
                        Messaging.messaging().shouldEstablishDirectChannel = true
                        
                    }
                })
            })
            
                            try? Auth.auth().signOut()
            
            self.navigationController?.viewControllers = [self.controllerWithMainStoryBoard(withIdentifier: LoginPageVC.className)]
            
        })], Controller: self)
    }
}
