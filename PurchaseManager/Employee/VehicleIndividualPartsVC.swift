//
//  VehicleIndividualPartsVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 18/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import UIKit
import Alamofire

class VehicleIndividualPartsVC: UIViewController {
    @IBOutlet var mainHeadLabel: UILabel!
    var detailPartId = ""
    var investorId = ""
    var vehicleId = ""
    var subPartLabel = ""
    var vehicleIndividualPartsArray = [VehicleIndividualPartsListModel]()
    @IBOutlet var mainTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainHeadLabel.text = subPartLabel
        callingVehicleIndividualPartsServiceAPI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapBackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func callingVehicleIndividualPartsServiceAPI(){
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()

        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.vehicle.Evaluated_VehiclePartsDetails  + "?vehicleId=" + vehicleId + "&detailPartId=" + detailPartId , method: .get, contentType: .urlencode, params: [:], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()

            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                self.vehicleIndividualPartsArray.removeAll()
                switch response.result {
                    
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess{
                        print(jsonResponse.response)
                        
                        jsonResponse.response.arrayValue.forEach({ (data) in
                            self.vehicleIndividualPartsArray.append(VehicleIndividualPartsListModel.init(data: data))
                        })
                        
                        
                        
                        self.mainTableView.reloadData()
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
    
}
extension VehicleIndividualPartsVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleIndividualPartsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleVerificationSubCell", for: indexPath) as! VehicleVerificationSubCell
        cell.subOptionLabel.text! = vehicleIndividualPartsArray[indexPath.row].subDetails
        cell.subDetailsLabel.text! = vehicleIndividualPartsArray[indexPath.row].conditionName
        cell.addingImageView.kf.indicatorType = .activity
        cell.addingImageView.kf.setImage(with: URL(string:vehicleIndividualPartsArray[indexPath.row].partImage), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        return cell
    }
    
    
}
class VehicleVerificationSubCell:UITableViewCell{
    
    @IBOutlet var subOptionLabel: UILabel!
    @IBOutlet var subDetailsLabel: UILabel!
    @IBOutlet var addingImageView: UIImageView!
    
    
}


