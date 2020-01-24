//
//  PurchasedCarsVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 25/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import UIKit
import KYDrawerController

class PurchasedCarsVC: UIViewController {
    @IBOutlet var NoVehicleStatusLabel: UILabel!
    @IBOutlet var purchasedCarTableview: UITableView!
    var purchasedVehicleListArray = [PurchasedVehicleListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
 purchasedCarsListServiceAPI()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onTapMenuButtonAction(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    func purchasedCarsListServiceAPI() {
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()
        
        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.Purchased.Purchased_VehiclesList, method: .get, contentType: .urlencode, params: ["employeeId": userid], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()
            
            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                self.purchasedVehicleListArray.removeAll()
                
                switch response.result {
                    
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess{
                        print(jsonResponse.response)
                        let jsonArrr = jsonResponse.response.arrayValue
                        
                        jsonArrr.forEach({ (data) in
                            self.purchasedVehicleListArray.append(PurchasedVehicleListModel.init(data: data))
                        })
                        if self.purchasedVehicleListArray.count == 0 {
                            self.purchasedCarTableview.isHidden = true
                            self.NoVehicleStatusLabel.text = "No Purchased Vehicles";
                        }else{
                            self.purchasedCarTableview.isHidden = false
                        }
                        
                        self.purchasedCarTableview.reloadData()
                        
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
extension PurchasedCarsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchasedVehicleListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchasedCarsCell", for: indexPath)as! PurchasedCarsCell
      
        
        cell.vehicleNameLabel.text = purchasedVehicleListArray[indexPath.row].vehicleName
        cell.registrationNoLabel.text = purchasedVehicleListArray[indexPath.row].registrationNo
        
        cell.odometerLabel.text = purchasedVehicleListArray[indexPath.row].odometer
        cell.fuelTypeLabel.text = purchasedVehicleListArray[indexPath.row].fuelType
        cell.gearSystemLabel.text = purchasedVehicleListArray[indexPath.row].gearSystem
        cell.sellinPriceLabel.text = purchasedVehicleListArray[indexPath.row].sellingPrice
        cell.purchasedLabel.text = purchasedVehicleListArray[indexPath.row].purchasePrice
        cell.refurbishmentLabel.text = purchasedVehicleListArray[indexPath.row].refurbishAmnt
        if purchasedVehicleListArray[indexPath.row].vehicleImage == "NA"{
            cell.vehicleImages.image = #imageLiteral(resourceName: "NoImage")
            
        }else {
            cell.vehicleImages.kf.indicatorType = .activity
            
            cell.vehicleImages.kf.setImage(with: URL(string: purchasedVehicleListArray[indexPath.row].vehicleImage), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        }
        return cell
    }
    
    
}
class PurchasedCarsCell:UITableViewCell{
    @IBOutlet var vehicleImages: UIImageView!
    @IBOutlet var vehicleNameLabel: UILabel!
    @IBOutlet var registrationNoLabel: UILabel!
    @IBOutlet var fuelTypeLabel: UILabel!
    @IBOutlet var odometerLabel: UILabel!
    @IBOutlet var gearSystemLabel: UILabel!
    @IBOutlet var sellinPriceLabel: UILabel!
    @IBOutlet var refurbishmentLabel: UILabel!
    @IBOutlet var purchasedLabel: UILabel!
    
}
