//
//  EmployeNamesVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 06/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//
import UIKit
import KYDrawerController
import Alamofire

class EmployeNamesVC: UIViewController {
    @IBOutlet var cityNameLabel: UILabel!
    
 var employeeNamesListArray = [CityWiseEmployeNamesModel]()
    var cityId = ""
    @IBOutlet var employeeNameTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let city = UserDefaults.standard.value(forKey: "city")
        cityId = UserDefaults.standard.value(forKey: "cityId") as! String
        self.cityNameLabel.text = (city as! String)
        callingCityWiseEmployeeListAPI()
        super.viewWillAppear(true)
    }
    
    @IBAction func onTapBackButtonAction(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }

        
    }
    @IBAction func onTapLocationButton(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangeLocationVC")as! ChangeLocationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func callingCityWiseEmployeeListAPI()
    
    {
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()

        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.employeeList.Employees_CityWiseAssignedVehiclesList + "?cityId=" + cityId, method: .get, contentType: .urlencode, params: [:], headers: ["Authorization": SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()

            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                self.employeeNamesListArray.removeAll()
                switch response.result {
                    
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess{
                        print(jsonResponse.response)
                        let jsonArrr = jsonResponse.response.arrayValue
                        
                        jsonArrr.forEach({ (data) in
                            self.employeeNamesListArray.append(CityWiseEmployeNamesModel.init(data: data))
                        })
                        
                        self.employeeNameTableView.reloadData()
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
extension EmployeNamesVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeNamesListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeNameCell", for: indexPath) as! EmployeNameCell
        cell.employeeNameLabel.text = employeeNamesListArray[indexPath.row].evaluatorName
        cell.carCountList.text = employeeNamesListArray[indexPath.row].assignedVehicles
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AssignedVehicleListVC") as! AssignedVehicleListVC
        vc.evaluatorId = employeeNamesListArray[indexPath.row].evaluatorId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
class EmployeNameCell:UITableViewCell{
    
    @IBOutlet var employeeNameLabel: UILabel!
    @IBOutlet var carCountList: UILabel!
}
