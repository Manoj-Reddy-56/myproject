//
//  ChangeLocationVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 11/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import UIKit
import KYDrawerController
import Alamofire

class ChangeLocationVC: UIViewController {
    
    @IBOutlet var changelocationTableView: UITableView!
   // var locationArray = ["Delhi","Gurugram","Karnal","Ludhiana","Chandigarh","Dehradun"]
    var CityListArray = [ChangeLocationModel]()
    var cityListArray = [(String,String)]()
    
    var selectedCityId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let drawerController = navigationController?.parent as? KYDrawerController
        
        drawerController!.screenEdgePanGestureEnabled = false
        self.changelocationTableView.rowHeight = UITableView.automaticDimension
        
        self.changelocationTableView.estimatedRowHeight = 65
        let cityId = UserDefaults.standard.value(forKey: "cityId")
        
        selectedCityId = cityId as! String
        callingChangeLocationAPI()
        
        // Do any additional setup after loading the view.
    }
    
    func callingChangeLocationAPI()
    {
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()

        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix:CUrls.City.Employees_CityList , method: .get, contentType: .urlencode, params: [:], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()

            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                self.cityListArray.removeAll()
                switch response.result {
                                
                            case .success(let jsonResponse):
                                if jsonResponse.responseType.isSuccess{
                                    print(jsonResponse.response)
                                   
                                    self.cityListArray.append(("ALL", "0"))
                                    jsonResponse.response.arrayValue.enumerated().forEach({ (secondOjb) in
                                        var dict = secondOjb.element.dictionaryValue
                                        self.cityListArray.append((dict["city"]!.stringValue,dict["cityId"]!.stringValue))
                                    })
                     
                                    self.changelocationTableView.reloadData()
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
    
    @IBAction func onTapBackButtonAction(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
}
extension ChangeLocationVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeLocationCell", for: indexPath)as! ChangeLocationCell
        cell.locationLabel.text = cityListArray[indexPath.row].0
        if cityListArray[indexPath.row].1 == selectedCityId{
            cell.checkMarkImageView.image = #imageLiteral(resourceName: "circle-with-check")
        }else{
             cell.checkMarkImageView.image = #imageLiteral(resourceName: "round_lightGray-25")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(cityListArray[indexPath.row].0, forKey: "city")
        UserDefaults.standard.set(cityListArray[indexPath.row].1, forKey: "cityId")
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
    
}
class ChangeLocationCell:UITableViewCell{
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var checkMarkImageView: UIImageView!
    
   
}

