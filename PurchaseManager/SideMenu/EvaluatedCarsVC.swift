//
//  EvaluatedCarsVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 06/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import UIKit
import KYDrawerController
import Kingfisher
import Alamofire

class EvaluatedCarsVC: UIViewController {

    @IBOutlet var evaluatedCarsTableview: UITableView!
    @IBOutlet var NoVehicleStatusLabel: UILabel!
    var evaluatedCrasArray = [EvaluatedVehicleListModel]()
    @IBOutlet var mainHeadLabel: UILabel!
    var selectedtype = ""
    var employeeId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        mainHeadLabel.text = "Evaluated Cars"
        NotificationCenter.default.addObserver(self, selector: #selector(changetheTableData(notification:)), name: NSNotification.Name("Change"), object: nil)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(changetheTableData(notification:)), name: NSNotification.Name("Change"), object: nil)
        if  selectedtype == "Evaluated Cars" {
            callingEvaluatedVehicleListAPI()
        }
        else if selectedtype == "Follow UP" {
            callingOnBoardVehicleListAPI()
        }
    }
    
    @objc func changetheTableData(notification: Notification)  {
        print("changecheck", notification.object ?? "")
        selectedtype = notification.object as! String
        mainHeadLabel.text = selectedtype
        
        if  selectedtype == "Evaluated Cars" {

          callingEvaluatedVehicleListAPI()

        }
        else if selectedtype == "Follow UP" {
            callingOnBoardVehicleListAPI()
            
        }
    }
    
    @IBAction func onTapBackButtonAction(_ sender: Any) {

        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    func callingEvaluatedVehicleListAPI(){
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()

        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.employeeList.Evaluated_VehiclesListDetails, method: .get, contentType: .urlencode, params: ["user_id": userid], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()

            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                self.evaluatedCrasArray.removeAll()

                switch response.result {
                    
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess{
                        print(jsonResponse.response)
                        let jsonArrr = jsonResponse.response.arrayValue
                        
                        jsonArrr.forEach({ (data) in
                            self.evaluatedCrasArray.append(EvaluatedVehicleListModel.init(data: data))
                        })
                        if self.evaluatedCrasArray.count == 0 {
                            self.evaluatedCarsTableview.isHidden = true
                            self.NoVehicleStatusLabel.text = "No Evaluated Vehicles";
                        }else{
                            self.evaluatedCarsTableview.isHidden = false
                        }
                        
                        self.evaluatedCarsTableview.reloadData()
                        
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
    
    func  callingOnBoardVehicleListAPI(){
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()

        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.employeeList.OnBoarded_VehiclesList , method: .get, contentType: .urlencode, params: ["employeeId": userid], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()

            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                self.evaluatedCrasArray.removeAll()

                switch response.result {
                    
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess{
                        print(jsonResponse.response)
                        let jsonArrr = jsonResponse.response.arrayValue
                        
                        jsonArrr.forEach({ (data) in
                            self.evaluatedCrasArray.append(EvaluatedVehicleListModel.init(data: data))
                        })
                        if self.evaluatedCrasArray.count == 0 {
                            self.evaluatedCarsTableview.isHidden = true
                           self.NoVehicleStatusLabel.text = "No OnBoard Vehicles";
                        }else{
                            self.evaluatedCarsTableview.isHidden = false
                        }
                        
                        
                        self.evaluatedCarsTableview.reloadData()
                        
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
extension EvaluatedCarsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedtype == "Evaluated Cars"{
            return evaluatedCrasArray.count
        }else{
            return evaluatedCrasArray.count
        }
            //evaluatedCrasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedtype == "Evaluated Cars" {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluatedCarCell", for: indexPath) as! EvaluatedCarCell
 
        cell.carNameLabel.text = evaluatedCrasArray[indexPath.row].vehicleName
        cell.registrationLabel.text = evaluatedCrasArray[indexPath.row].registrationNo
        cell.manufactureLabel.text = evaluatedCrasArray[indexPath.row].manufacturedYM
        cell.odometerLabel.text = evaluatedCrasArray[indexPath.row].odometer
        cell.fuelLabel.text = evaluatedCrasArray[indexPath.row].fuelType
        cell.gearlabel.text = evaluatedCrasArray[indexPath.row].gearSystem
        cell.noOfOwnerLabel.text = evaluatedCrasArray[indexPath.row].noOfOwners
        if evaluatedCrasArray[indexPath.row].vehicleImage == "NA"{
            cell.vehicleImage.image = #imageLiteral(resourceName: "NoImage")

        }else {
        cell.vehicleImage.kf.indicatorType = .activity

        cell.vehicleImage.kf.setImage(with: URL(string: evaluatedCrasArray[indexPath.row].vehicleImage), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        }
        return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluatedCarCell", for: indexPath) as! EvaluatedCarCell
            cell.carNameLabel.text = evaluatedCrasArray[indexPath.row].vehicleName
            cell.registrationLabel.text = evaluatedCrasArray[indexPath.row].registrationNo
            cell.manufactureLabel.text = evaluatedCrasArray[indexPath.row].manufacturedYM
            cell.odometerLabel.text = evaluatedCrasArray[indexPath.row].odometer
            cell.fuelLabel.text = evaluatedCrasArray[indexPath.row].fuelType
            cell.gearlabel.text = evaluatedCrasArray[indexPath.row].gearSystem
            cell.noOfOwnerLabel.text = evaluatedCrasArray[indexPath.row].noOfOwners
            if evaluatedCrasArray[indexPath.row].vehicleImage == "NA"{
                cell.vehicleImage.image = #imageLiteral(resourceName: "NoImage")

            }else {
                cell.vehicleImage.kf.indicatorType = .activity

                cell.vehicleImage.kf.setImage(with: URL(string: evaluatedCrasArray[indexPath.row].vehicleImage), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedtype == "Evaluated Cars" {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VehicleDetailsVC")as! VehicleDetailsVC
            vc.fromEvaluatedTo = "Evaluated"
        vc.vehicleId = evaluatedCrasArray[indexPath.row].vehicleId
            
        self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VehicleDetailsVC")as! VehicleDetailsVC
            vc.fromFollowUpToVeDetails = "followUp"
            vc.vehicleId = evaluatedCrasArray[indexPath.row].vehicleId
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
class EvaluatedCarCell:UITableViewCell{
    @IBOutlet var carNameLabel: UILabel!
    @IBOutlet var registrationLabel: UILabel!
    @IBOutlet var manufactureLabel: UILabel!
    
    @IBOutlet var vehicleImage: UIImageView!
    
    @IBOutlet var noOfOwnerLabel: UILabel!
    @IBOutlet var fuelLabel: UILabel!
    @IBOutlet var odometerLabel: UILabel!
    @IBOutlet var gearlabel: UILabel!
}
