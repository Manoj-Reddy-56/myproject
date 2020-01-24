//
//  RescheduledAndRejectedVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 11/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import UIKit
import KYDrawerController
import Alamofire

class RescheduledAndRejectedVC: UIViewController,UITextViewDelegate {
    @IBOutlet var noRescheduledOrRejectStatusLabel: UILabel!
    
    @IBOutlet var mainHeadingLabel: UILabel!
    @IBOutlet var tableview: UITableView!
    var rejectedAndRescheduledListArray = [RejectedAndRescheduledListModel]()
    var rescheduledStr = ""
    var rejectedStr = ""
    var selectedtype = ""
    override func viewDidLoad() {
        super.viewDidLoad()
          mainHeadingLabel.text = "Rescheduled Vehicles"
                NotificationCenter.default.addObserver(self, selector: #selector(changetheTableData(notification:)), name: NSNotification.Name("Change"), object: nil)
        tableview.estimatedRowHeight = 210
        tableview.rowHeight = UITableView.automaticDimension

        // Do any additional setup after loading the view.
    }
    func textViewDidChange(_ textView: UITextView) {
        tableview.beginUpdates()
        tableview.endUpdates()
    }
    @IBAction func onTapMenuActionButton(_ sender: Any) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
        @objc func changetheTableData(notification: Notification)  {
            print("changecheck", notification.object ?? "")
            selectedtype = notification.object as! String
            mainHeadingLabel.text = selectedtype
    
            if  selectedtype == "Rescheduled Vehicles" {
                callingRescheduledListServiceAPI()
               
    
            }
            else if selectedtype == "Rejected Vehicles" {
                callingRejectedVehicleListServiceAPI()
          
            }
        }
    func callingRejectedVehicleListServiceAPI(){
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()

        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.rejectAndResche.Employees_RejectedVehiclesList , method: .get, contentType: .urlencode, params: [:], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()

            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                self.rejectedAndRescheduledListArray.removeAll()
                switch response.result {
                    
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess{
                        print(jsonResponse.response)
                        let jsonArrr = jsonResponse.response.arrayValue
                        
                        jsonArrr.forEach({ (data) in
                            self.rejectedAndRescheduledListArray.append(RejectedAndRescheduledListModel.init(data: data))
                        })
                        if self.rejectedAndRescheduledListArray.count == 0{
                            self.tableview.isHidden = true
                            self.noRescheduledOrRejectStatusLabel.text = "No Rejected Vehicles"
                        }else {
                            self.tableview.isHidden = false
                        }
                        self.tableview.reloadData()
                        
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
    func callingRescheduledListServiceAPI(){
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()

        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.rejectAndResche.Employees_ReScheduledVehiclesList , method: .get, contentType: .urlencode, params: [:], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()

            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                self.rejectedAndRescheduledListArray.removeAll()
                switch response.result {
                    
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess{
                        print(jsonResponse.response)
                        let jsonArrr = jsonResponse.response.arrayValue
                        
                        jsonArrr.forEach({ (data) in
                            self.rejectedAndRescheduledListArray.append(RejectedAndRescheduledListModel.init(data: data))
                        })
                        if self.rejectedAndRescheduledListArray.count == 0{
                            self.tableview.isHidden = true
                            self.noRescheduledOrRejectStatusLabel.text = "No Rescheduled Vehicles"
                        }else {
                            self.tableview.isHidden = false
                        }
                        self.tableview.reloadData()
                       
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
extension RescheduledAndRejectedVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rejectedAndRescheduledListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RescheduledAndRejectedListCell", for: indexPath)as! RescheduledAndRejectedListCell
        cell.custNameLabel.text = rejectedAndRescheduledListArray[indexPath.row].custName
        cell.mobileNoLabel.text = rejectedAndRescheduledListArray[indexPath.row].custPhNo
        cell.carMakeAndModelLabel.text = rejectedAndRescheduledListArray[indexPath.row].vehicleName
        cell.registrationNumLabel.text = rejectedAndRescheduledListArray[indexPath.row].registrationNo
        cell.evaluatorNameLabel.text = rejectedAndRescheduledListArray[indexPath.row].employeeName
        cell.commentsTV.text = rejectedAndRescheduledListArray[indexPath.row].comments
        cell.textViewHeightConstraint.constant = cell.commentsTV.contentSize.height
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
class RescheduledAndRejectedListCell:UITableViewCell{
    @IBOutlet var custNameLabel: UILabel!
    @IBOutlet var carMakeAndModelLabel: UILabel!
    @IBOutlet var registrationNumLabel: UILabel!
    @IBOutlet var mobileNoLabel: UILabel!
    @IBOutlet var evaluatorNameLabel: UILabel!
    @IBOutlet var commentsTV: UITextView!
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commentsTV.isUserInteractionEnabled = false
        
    }
    
}
