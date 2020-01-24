//
//  PricingDetailsVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 12/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import UIKit
import Alamofire

class PricingDetailsVC: UIViewController,UITextViewDelegate {
    @IBOutlet var dateAndTimeView: UIView!
    
    @IBOutlet var followUpViewBottomLabel: NSLayoutConstraint!
    @IBOutlet var followUpListView: UIView!
    @IBOutlet var purchasedPriceTF: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var sellingPriceTF: UITextField!
    @IBOutlet var dateAndTimeTF: UITextField!
    @IBOutlet var statusTF: UITextField!
    @IBOutlet var dateAndTimeViewHeight: NSLayoutConstraint!
    @IBOutlet var commentsTextView: UITextView!
    @IBOutlet var commentsViewHeight: NSLayoutConstraint!
    @IBOutlet var refurbishedAmountTF: UITextField!
    
    var sellingPrice = ""
    

    let datePicker = UIDatePicker()
    var selectedDateString = String()

    var statusArray = [StatusListModel]()
   var minimumDate: Date?
    var vehicleId = ""
    var fromFollowUp = ""
    var fromEvaluated = ""
    var statusId = ""
    var editisseleted = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        statusListServiceAPI()
        showDatePicker()
        self.purchasedPriceTF.maxLength = 10
        self.sellingPriceTF.maxLength = 10
        addDoneButtonToSellingPriceOnKeyboard()
        addDoneButtonToPurchasePriceOnKeyboard()
        
       // datePicker.date = minimumDate!
        if fromEvaluated == "Evaluated"{
            refurbishedAmountTF.isUserInteractionEnabled = false
            followUpListView.isHidden = true
             pricingDetailsServiceAPI()
        }
        
       else if fromFollowUp == "followUp" {
            callingFollowUpPriceValueAPI()
            if statusTF.text == "Follow up"{
                followUpListView.isHidden = false
                dateAndTimeViewHeight.constant = 60
                dateAndTimeView.isHidden = false
                sellingPriceTF.text = ""
                purchasedPriceTF.text = ""
                commentsViewHeight.constant = 70
            }else if statusTF.text == "Purchased"{
                followUpListView.isHidden = false
                dateAndTimeViewHeight.constant = 0
                sellingPriceTF.text = ""
                purchasedPriceTF.text = ""
                dateAndTimeTF.text = ""
                commentsTextView.text = ""
                dateAndTimeView.isHidden = true
                commentsViewHeight.constant = 0
                commentsTextView.text = ""
            }else if statusTF.text == "Sold Out"{
                followUpListView.isHidden = true
                commentsTextView.text = ""
            }
            submitButton.setTitle("Edit", for: .normal)
            editisseleted = "N"
            refurbishedAmountTF.isUserInteractionEnabled = false
            statusTF.isUserInteractionEnabled = false
            purchasedPriceTF.isUserInteractionEnabled = false
            sellingPriceTF.isUserInteractionEnabled = false
            dateAndTimeTF.isUserInteractionEnabled = false
            commentsTextView.isUserInteractionEnabled = false
            
        }
        // MARK :- KeyBoard Hide
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.followUpViewBottomLabel.constant = keyboardSize.height + 55
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.followUpViewBottomLabel.constant = 12
        
    }
@objc func dismissKeyboard() {
  
    view.endEditing(true)
    
}
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if commentsTextView.text == "Enter Remarks" {
            commentsTextView.text = ""
            commentsTextView.textColor = UIColor.black
        }
        return true
    }
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                if commentsTextView.text == "" {
                    commentsTextView.text = "Enter Remarks"
                    commentsTextView.textColor = UIColor.lightGray
                }
                commentsTextView.resignFirstResponder()
                return false
            }
            return true
        }
    
    @IBAction func onTapBackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    var statusPickerView : UIPickerView!
    func statusPickerViewFunction(){
    statusPickerView = UIPickerView()
    statusPickerView.delegate = self
    statusPickerView.dataSource = self
    statusPickerView.showsSelectionIndicator = true
    statusPickerView.backgroundColor = UIColor.groupTableViewBackground
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    toolbar.backgroundColor = UIColor.groupTableViewBackground
    var barItem = [UIBarButtonItem]()
    let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.commonCancel))
    barItem.append(cancel)
    let flexspace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    barItem.append(flexspace)
    let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.onTapStatusDone))
    barItem.append(doneBtn)
    toolbar.setItems(barItem, animated: true)
    statusTF.inputView = statusPickerView
    statusTF.inputAccessoryView = toolbar
        
    }
    func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
      
        datePicker.date = Date()
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        dateAndTimeTF.inputAccessoryView = toolbar
        dateAndTimeTF.inputView = datePicker
    }
    //MAIN : - adding Done Button to numberKeyPad
    func addDoneButtonToSellingPriceOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        sellingPriceTF.inputAccessoryView = doneToolbar
    }
    
    //MAIN: - purchase Price done Button
    
    func addDoneButtonToPurchasePriceOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        purchasedPriceTF.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        sellingPriceTF.resignFirstResponder()
        purchasedPriceTF.resignFirstResponder()
    }
    // MAIN: -
    
    @objc func commonCancel(){
        statusTF.resignFirstResponder()
        
    }
    @objc func onTapStatusDone(){
        if statusTF.text == statusArray[statusPickerView.selectedRow(inComponent: 0)].onboardType{
            self.statusTF.resignFirstResponder()
            
            
        }else {
            statusTF.text = statusArray[statusPickerView.selectedRow(inComponent: 0)].onboardType
            statusId = statusArray[statusPickerView.selectedRow(inComponent: 0)].onboardTypeId
            if statusTF.text == "Follow up"{
                followUpListView.isHidden = false
                dateAndTimeViewHeight.constant = 60
                dateAndTimeView.isHidden = false
                sellingPriceTF.text = ""
                // sellingPriceLabel.text = "\(sellingPrice)" ?? ""
                purchasedPriceTF.text = ""
                commentsViewHeight.constant = 70
            }else if statusTF.text == "Purchased"{
                followUpListView.isHidden = false
                dateAndTimeViewHeight.constant = 0
                sellingPriceTF.text = ""
                purchasedPriceTF.text = ""
                dateAndTimeTF.text = ""
                commentsTextView.text = ""
                dateAndTimeView.isHidden = true
                commentsViewHeight.constant = 0
            }else if statusTF.text == "Sold Out"{
                followUpListView.isHidden = true
            }
            statusTF.resignFirstResponder()
        }
       
       
        
    }
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        selectedDateString = formatter.string(from: datePicker.date)
        dateAndTimeTF.text = selectedDateString
        dateAndTimeTF.resignFirstResponder()
    }
    @objc func cancelDatePicker(){
      
        dateAndTimeTF.resignFirstResponder()
    }
    // MAIN:- Status List
    
    func statusListServiceAPI() {
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
            }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()
        
    Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix:CUrls.vehicle.VehicleInfo_OnBoardStatuses   , method: .get, contentType: .urlencode, params: [:], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
        
                     self.view.StopLoading()
        
                     if auth {
                         sectionExpiredClass.ClearData(controller: self)
                     }
                     else {
                        self.statusArray.removeAll()
                         switch response.result {
                          case .success(let jsonResponse):
                          if jsonResponse.responseType.isSuccess {
                          print(jsonResponse.response)
                            jsonResponse.response.arrayValue.forEach({ (data) in
                                self.statusArray.append(StatusListModel.init(data: data))
                            })
                            self.statusPickerViewFunction()
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
    // MAIN: - get Method
    
     func pricingDetailsServiceAPI()
    
     {
         if !InternetReachable.ValidateInternet {
             Message.NoInternetAlert(self)
             return
         }
         let imei = UIDevice.current.clientID
         let userid = SessionHelperClass().getUserId()!
         self.view.StartLoading()

         Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix:CUrls.vehicle.Evaluated_VehiclePricingDetails  + "?vehicleId=" + vehicleId , method: .get, contentType: .urlencode, params: [:], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in

             self.view.StopLoading()

             if auth {
                 sectionExpiredClass.ClearData(controller: self)
             }
             else {

                 switch response.result {
                  case .success(let jsonResponse):
                  if jsonResponse.responseType.isSuccess {
                  print(jsonResponse.response)
                  self.refurbishedAmountTF.text! = jsonResponse.response["refurbishAmount"].stringValue
                  } else {
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
    
    
    func callingFollowUpPriceValueAPI(){
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()
        
        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix:CUrls.vehicle.Evaluated_VehicleFinalPricingDetails  + "?vehicleId=" + vehicleId  , method: .get, contentType: .urlencode, params: [:], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()
            
            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                
                switch response.result {
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess {
                        print(jsonResponse.response)
                     
                        self.purchasedPriceTF.text! =
                            jsonResponse.response["finalPurchasePrice"].stringValue
                        self.sellingPriceTF.text! = jsonResponse.response["finalSellingPrice"].stringValue
                      //  self.sellingPrice = jsonResponse.response["finalSellingPrice"].stringValue
                        self.dateAndTimeTF.text! = jsonResponse.response["dateTime"].stringValue
                        self.commentsTextView.text! =  jsonResponse.response["finalPurchasecomments"].stringValue
                        self.refurbishedAmountTF.text! = jsonResponse.response["finalRefurbishAmnt"].stringValue
                        self.statusTF.text! = jsonResponse.response["onboardStatus"].stringValue
                        self.statusId = jsonResponse.response["onboardStatusId"].stringValue
                   
                    } else {
                     
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

    //MAIN: - Post Method
    
    func callingSavingPricingDetailStatus(){
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()
        
        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix:CUrls.vehicle.Evaluated_saveEvaluationFinalPrice  , method: .post, contentType: .jsonEncode, params: ["vehicleId":vehicleId,"employeeId":userid,"onboardStatus":statusId,"purchasePrice":purchasedPriceTF.text!,"sellingPrice":sellingPriceTF.text!,"refurbishAmnt":refurbishedAmountTF.text!,"comments":commentsTextView.text!,"dateTime":dateAndTimeTF.text!], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()
            
            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                
                switch response.result {
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess {
                        print(jsonResponse.response)
                        //   self.navigationController?.popViewController(animated: true)
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: EvaluatedCarsVC.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                UIApplication.shared.keyWindow?.ShowBlackTostWithText(message: "Sucessfully Submitted", Interval: 3)
                                break
                            }
                        }
                        
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
    func customers_editPriceDetails (){
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        let imei = UIDevice.current.clientID
        let userid = SessionHelperClass().getUserId()!
        self.view.StartLoading()
        
        Webservice().call(cRequest: CRequest.getRequest(url: CUrls.BaseUrl, suffix:CUrls.vehicle.Evaluated_saveEvaluationFinalPrice  , method: .post, contentType: .jsonEncode, params: ["vehicleId":vehicleId,"employeeId":userid,"onboardStatus":statusId,"purchasePrice":purchasedPriceTF.text!,"sellingPrice":sellingPriceTF.text!,"refurbishAmnt":refurbishedAmountTF.text!,"comments":commentsTextView.text!,"dateTime":dateAndTimeTF.text!], headers: ["Authorization": "Bearer " + SessionHelperClass().getAuthKey()!,"X-Device-Imei":imei,"Content-Type":"application/json"])) { (response, auth) in
            
            self.view.StopLoading()
            
            if auth {
                sectionExpiredClass.ClearData(controller: self)
            }
            else {
                
                switch response.result {
                case .success(let jsonResponse):
                    if jsonResponse.responseType.isSuccess {
                        print(jsonResponse.response)
                        //   self.navigationController?.popViewController(animated: true)
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: EvaluatedCarsVC.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                UIApplication.shared.keyWindow?.ShowBlackTostWithText(message: "Sucessfully Submitted", Interval: 3)
                                break
                            }
                        }
                        
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
    // MAIN: - Submit button
    
    @IBAction func onTapSubmitButton(_ sender: Any) {
        if statusTF.text == ""{
            self.view.ShowBlackTostWithText(message: "Please Select Status", Interval: 2)
        }
        if editisseleted == "N" {
            editisseleted = "Y"
            submitButton.setTitle("Update", for: .normal)
            statusTF.isUserInteractionEnabled = true
            purchasedPriceTF.isUserInteractionEnabled = true
            sellingPriceTF.isUserInteractionEnabled = true
            dateAndTimeTF.isUserInteractionEnabled = true
            commentsTextView.isUserInteractionEnabled = true
            
        }else if editisseleted == "Y" {
            if statusTF.text == "Follow up"{
                if purchasedPriceTF.text == ""{
                    self.view.ShowBlackTostWithText(message: "Please Enter Purchase Amount", Interval: 2)
                }else if sellingPriceTF.text == ""{
                    self.view.ShowBlackTostWithText(message: "Please Enter Selling Amount", Interval: 2)
                }else if dateAndTimeTF.text == ""{
                    self.view.ShowBlackTostWithText(message: "Please Select Date", Interval: 2)
                }else if commentsTextView.text == ""{
                    self.view.ShowBlackTostWithText(message: "Please Enter Comments", Interval: 2)
                }else {
                    print("Submitted Edited data from followUp")
                 customers_editPriceDetails()
                }
            } else if statusTF.text == "Purchased"{
                if purchasedPriceTF.text == ""{
                    self.view.ShowBlackTostWithText(message: "Please Enter Purchase Amount", Interval: 2)
                }else if sellingPriceTF.text == "" {
                    self.view.ShowBlackTostWithText(message: "Please Enter Selling Amount", Interval: 2)
                }else {
                   print("Submitted Edited data from Purchased")
                  customers_editPriceDetails()
                }
            }else if statusTF.text == "Sold Out"{
                 print("Submitted Edited data from sold")
                customers_editPriceDetails()
            }
        }
        if fromEvaluated == "Evaluated"{
        if statusTF.text == "Follow up"{
            if purchasedPriceTF.text == ""{
                self.view.ShowBlackTostWithText(message: "Please Enter Purchase Amount", Interval: 2)
            }else if sellingPriceTF.text == ""{
                self.view.ShowBlackTostWithText(message: "Please Enter Selling Amount", Interval: 2)
            }else if dateAndTimeTF.text == ""{
                self.view.ShowBlackTostWithText(message: "Please Select Date", Interval: 2)
            }else if commentsTextView.text == ""{
                 self.view.ShowBlackTostWithText(message: "Please Enter Comments", Interval: 2)
            }else {
                print("Submitted Follow UP data")
                 callingSavingPricingDetailStatus()
            }
        } else if statusTF.text == "Purchased"{
            if purchasedPriceTF.text == ""{
                self.view.ShowBlackTostWithText(message: "Please Enter Purchase Amount", Interval: 2)
            }else if sellingPriceTF.text == "" {
                self.view.ShowBlackTostWithText(message: "Please Enter Selling Amount", Interval: 2)
            }else {
                print("Submitted Purchased data")
                callingSavingPricingDetailStatus()
            }
        }else if statusTF.text == "Sold Out"{
           callingSavingPricingDetailStatus()
        }
        }

    }
    
    
}
extension PricingDetailsVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
       return statusArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if statusTF.isFirstResponder{
            return statusArray[row].onboardType
        }
        return nil
        
    }
    
    
}
