//
//  VehicleDetailsVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 12/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import UIKit
import Alamofire

class VehicleDetailsVC: UIViewController {

    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var carNameLabel: UILabel!
    @IBOutlet var vehicleDetailsTableView: UIView!
    @IBOutlet var heightOfTableView: NSLayoutConstraint!
    @IBOutlet var carNoLabel: UILabel!
    @IBOutlet var vehicleDetailsView: UIView!
    @IBOutlet var evaluatorName: UILabel!
    @IBOutlet var vehicleAllPartsTableView: UITableView!
    var vehicleAllPartsArray = [vehicleAllPartsMode]()
  
   var fromEvaluatedTo = ""
    var fromFollowUpToVeDetails = ""
    var vehicleId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        callingVehicleBasicInfoServiceAPI()
        cllingVehicleAllPartsServiceAPI()
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapBackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onTapDocumentsDetailsAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VehicleDocumentsDetailsVC") as! VehicleDocumentsDetailsVC
        
        vc.vehicleId = vehicleId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func onTapImageAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"ImagesVC")as! ImagesVC
        vc.vehicleId = vehicleId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onTapPricingDetailsAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier:"PricingDetailsVC")as! PricingDetailsVC
        vc.fromFollowUp = fromFollowUpToVeDetails
        vc.fromEvaluated = fromEvaluatedTo
        vc.vehicleId = vehicleId
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    func callingVehicleBasicInfoServiceAPI()
    {
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()

        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.vehicle.Evaluated_VehicleDetails + "?vehicleId=" + vehicleId , method: .get, contentType: .urlencode, params: [:], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()

            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                switch response.result {
                                
                            case .success(let jsonResponse):
                                if jsonResponse.responseType.isSuccess{
                                    print(jsonResponse.response)
                                    self.customerNameLabel.text = jsonResponse.response["leadName"].stringValue
                                    self.carNameLabel.text = jsonResponse.response["vehicleName"].stringValue
                                    self.carNoLabel.text = jsonResponse.response["registrationNo"].stringValue
                                    self.evaluatorName.text = jsonResponse.response["evaluatorName"].stringValue

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
    
    
    func cllingVehicleAllPartsServiceAPI()
    {
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()

        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.vehicle.Evaluated_OverallPartsList , method: .get, contentType: .urlencode, params: [:], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()

            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                self.vehicleAllPartsArray.removeAll()

                switch response.result {
                        
                    case .success(let jsonResponse):
                        if jsonResponse.responseType.isSuccess{
                            print(jsonResponse.response)
                              let jsonArrr = jsonResponse.response.arrayValue
                            jsonArrr.forEach({ (data) in
                            self.vehicleAllPartsArray.append(vehicleAllPartsMode.init(data: data))
                                                })
                           
                self.heightOfTableView.constant = CGFloat(self.vehicleAllPartsArray.count * 52)
                            self.vehicleAllPartsTableView.reloadData()
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
extension VehicleDetailsVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleAllPartsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleDetailsTableViewCell", for: indexPath)as! VehicleDetailsTableViewCell
        cell.titleLabel.text = vehicleAllPartsArray[indexPath.row].detailPartName
      
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VehicleIndividualPartsVC")as!VehicleIndividualPartsVC
        vc.detailPartId = vehicleAllPartsArray[indexPath.row].detailPartId
        vc.vehicleId = vehicleId
        vc.subPartLabel = vehicleAllPartsArray[indexPath.row].detailPartName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
class VehicleDetailsTableViewCell:UITableViewCell{
    
    @IBOutlet var titleLabel: UILabel!
}
