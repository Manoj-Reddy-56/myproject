//
//  DashBoardVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 06/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import UIKit
import KYDrawerController

class DashBoardVC: UIViewController {

    @IBOutlet var noOfEvaluatorCountLabel: UILabel!
    
    @IBOutlet var totalPurchasedVehicleCount: UILabel!
    @IBOutlet var totalFollowUpCountLabel: UILabel!
    @IBOutlet var totalEvaluatedVehicleCountLabel: UILabel!
    var employeeId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        let drawerController = navigationController?.parent as? KYDrawerController
        drawerController!.screenEdgePanGestureEnabled = false
       
        dashBoardServiceAPI()
        // Do any additional setup after loading the view.
    }
    
    func dashBoardServiceAPI(){
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()
        
        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.Dashboard.DashBoard_Counts , method: .get, contentType: .urlencode, params: ["employeeId":userid], headers: ["Authorization": SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()
            
            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
               
                switch response.result {
                    
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess{
                        print(jsonResponse.response)
                       
                        self.noOfEvaluatorCountLabel.text = jsonResponse.response["evaluatorsCount"].stringValue
                        self.totalPurchasedVehicleCount.text = jsonResponse.response["purchasedVehiclesCount"].stringValue
                        self.totalFollowUpCountLabel.text = jsonResponse.response["followUpsCount"].stringValue
                        self.totalEvaluatedVehicleCountLabel.text = jsonResponse.response["evaluatedVehiclesCount"].stringValue
                      
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

    // MARK: - Navigation

    @IBAction func onTapMenuButtonAction(_ sender: Any) {
        
            if let drawerController = navigationController?.parent as? KYDrawerController {
                drawerController.setDrawerState(.opened, animated: true)
            }
        
    }
    
}
