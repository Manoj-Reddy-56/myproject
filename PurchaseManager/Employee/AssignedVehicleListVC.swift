//
//  AssignedVehicleListVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 11/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import UIKit
import Alamofire

class AssignedVehicleListVC: UIViewController {

    @IBOutlet var noAssignedVehicleStatusLabel: UILabel!
    @IBOutlet var assignedTableView: UITableView!
    var evaluatorId = ""
    var employeWiseAssignedVehicleListArray = [EmployeWiseAssignedVehicleListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        callingEmployeWiseAssignedVehicleAPI()
       
    }
    
    @IBAction func onTapBackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func callingEmployeWiseAssignedVehicleAPI(){
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()

        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.employeeList.Employees_AssignedVehiclesList + "?evaluatorId=" + evaluatorId, method: .get, contentType: .urlencode, params: [:], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()

            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                self.employeWiseAssignedVehicleListArray.removeAll()

                switch response.result {
                    
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess{
                        print(jsonResponse.response)
                        let jsonArrr = jsonResponse.response.arrayValue
                        
                        jsonArrr.forEach({ (data) in
                            self.employeWiseAssignedVehicleListArray.append(EmployeWiseAssignedVehicleListModel.init(data: data))
                        })
                        if self.employeWiseAssignedVehicleListArray.count == 0{
                            self.assignedTableView.isHidden = true
                            self.noAssignedVehicleStatusLabel.text = "No Assigned Vehicle"
                        }else {
                            self.assignedTableView.isHidden = false
                        }
                        self.assignedTableView.reloadData()
                       
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
extension AssignedVehicleListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeWiseAssignedVehicleListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignedVehicleListCell", for: indexPath) as! AssignedVehicleListCell
        cell.customerNameLabel.text = employeWiseAssignedVehicleListArray[indexPath.row].custName
        cell.mobileNumberLabel.text = employeWiseAssignedVehicleListArray[indexPath.row].custPhNo
        cell.carMakeModelLabel.text = employeWiseAssignedVehicleListArray[indexPath.row].vehicleName
        cell.kmAndManufactureLabel.text = employeWiseAssignedVehicleListArray[indexPath.row].manufacturedYM
        cell.assignedDateLabel.text = employeWiseAssignedVehicleListArray[indexPath.row].assignedOn
        
        return cell
    }
    
    
    
}
class AssignedVehicleListCell:UITableViewCell {
    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var mobileNumberLabel: UILabel!
    @IBOutlet var carMakeModelLabel: UILabel!
    @IBOutlet var kmAndManufactureLabel: UILabel!
    @IBOutlet var assignedDateLabel: UILabel!
    
}
