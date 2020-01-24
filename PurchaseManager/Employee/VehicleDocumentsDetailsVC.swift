//
//  VehicleDocumentsDetailsVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 12/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class VehicleDocumentsDetailsVC: UIViewController {
    @IBOutlet var manufactureLabel: UILabel!
    @IBOutlet var chasisNoLabel: UILabel!
    @IBOutlet var engineNoLabel: UILabel!
    @IBOutlet var insuranceLabel: UILabel!
    @IBOutlet var insiuranceDocumentImage: UIImageView!
    @IBOutlet var insuranceDocImage: UIButton!
    @IBOutlet var rcAvailabelLabel: UILabel!
    @IBOutlet var rcImage: UIImageView!
    @IBOutlet var rcDocumentImage: UIButton!
    @IBOutlet var underHypoLabel: UILabel!
    
 var vehicleId = ""
    var fromOnBoard = ""
    var fromEvaluated = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        documentDetailsServiceAPI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func documentDetailsServiceAPI() {
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()

        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.vehicle.Evaluated_VehicleDocumentDetails + "?vehicleId=" + vehicleId , method: .get, contentType: .urlencode, params: [:], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()

            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {

                switch response.result {
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess {
                        print(jsonResponse.response)
                        let jsonArrr = jsonResponse.response.dictionaryValue
                        
                        self.manufactureLabel.text! = jsonArrr["manufacturingYM"]!.stringValue
                        self.chasisNoLabel.text! = jsonArrr["chasisNo"]!.stringValue
                        self.insuranceLabel.text! = jsonArrr["insuranceExpiry"]!.stringValue
                        self.rcAvailabelLabel.text! = jsonArrr["rcAvailability"]!.stringValue
                        self.engineNoLabel.text! = jsonArrr["engineNo"]!.stringValue
                        self.underHypoLabel.text! = jsonArrr["underHypothecation"]!.stringValue
                        self.rcImage.kf.indicatorType = .activity
                        self.rcImage.kf.setImage(with: URL(string: jsonArrr["rcImage"]!.stringValue), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                        
                        self.insiuranceDocumentImage.kf.indicatorType = .activity
                     
                        self.insiuranceDocumentImage.kf.setImage(with: URL(string: jsonArrr["insuranceImage"]!.stringValue), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                        
                        
                    } else {
                        //self.navigationController?.popViewController(animated: true)
                        self.view.ShowBlackTostWithText(message: jsonResponse.responseMessage, Interval: 3)
                    }
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    Message.SomethingWrongAlert(self)
                    if let code = response.response?.statusCode {
                        if code == 401 {
                        }
                    }
                    break
                }
            }
        }
    }
    
    @IBAction func onTapInsuranceDocImageButton(_ sender: Any) {
    }
    @IBAction func onTapRcImageButtonAction(_ sender: Any) {
    }
}
