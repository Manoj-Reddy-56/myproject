//
//  LoginPageVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 18/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import UIKit
import KYDrawerController
import Alamofire

class LoginPageVC: UIViewController,UITextFieldDelegate{
    var window : UIWindow?
    @IBOutlet var userNameTF: UITextField!
   
    @IBOutlet var hideAndShowButton: UIButton!
    @IBOutlet var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
       self.view.endEditing(true)
    }
    @IBAction func onTapSubmitButton(_ sender: Any) {
        if userNameTF.text == ""{
            self.view.ShowBlackTostWithText(message: "Please Enter User Name", Interval: 2)
        }
        else if passwordTF.text == ""{
            self.view.ShowBlackTostWithText(message: "Please Enter Password", Interval: 2)
        }else {
           
            loginServiceAPI()
        }

        
    }
    @IBAction func onTapHideAndShowButton(_ sender: Any) {
        if (hideAndShowButton.isSelected)
        {
            hideAndShowButton.isSelected = NO
            passwordTF.isSecureTextEntry = YES
        }
        else
        {
            hideAndShowButton.isSelected = YES
            passwordTF.isSecureTextEntry = NO
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userNameTF {
            userNameTF.placeholder = ""
            UIView.animate(withDuration: 0.3, animations: {
                var Rect: CGRect = self.view.frame
                Rect.origin.y = -40
                self.view.frame = Rect
            })
        }else {
            passwordTF.placeholder = ""
            UIView.animate(withDuration: 0.3, animations: {
                var Rect: CGRect = self.view.frame
                Rect.origin.y = -50
                self.view.frame = Rect
            })
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == userNameTF {
            UIView.animate(withDuration: 0.3, animations: {
                var Rect: CGRect = self.view.frame
                Rect.origin.y = 0
                self.view.frame = Rect
            })
            if (userNameTF.text == "") {
                userNameTF.placeholder = "Enter Mobile No/Email Id"
            } else {
                //   _PasswordTextField.placeholder=@"";
            }
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                var Rect: CGRect = self.view.frame
                Rect.origin.y = 0
                self.view.frame = Rect
            })
            if (passwordTF.text == "") {
                passwordTF.placeholder = "Password"
            } else {
                //   _PasswordTextField.placeholder=@"";
            }
        }
    }
    
    func loginServiceAPI(){
        if !InternetReachable.ValidateInternet {
            Message.NoInternetAlert(self)
            return
        }
        
        self.view.StartLoading()
        var ipaddress = ""
        if let addr = getWiFiAddress() {
            print(addr)
            ipaddress = addr
        } else {
            print("No WiFi address")
        }
        let imei = UIDevice.current.clientID
        let fcmtoken = UserDefaults.standard.value(forKey: "FCMTOKEN") ?? ""
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let version = nsObject as! String
       // var version = NSObject.self as! String
        //var version = NSObject.self

        let oldData = UserDefaults.standard.object(forKey: "updateDeviceDetails") as? [String:String]
       
        Alamofire.request(CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.Login.session_login , method: .post, contentType: .jsonEncode , params: ["emailPhone":self.userNameTF.text!,"password":passwordTF.text!,"deviceImei":imei,"deviceModel":UIDevice.current.deviceType.displayName,"deviceVersion":UIDevice.current.systemVersion,"notificationToken":fcmtoken,"notificationSource":"Phone","deviceType":"IOS","appVersion":version,"ipAddress":ipaddress], headers: ["Content-Type": "application/json"])).responseSwiftify { (response) in
            self.view.StopLoading()
            switch response.result {
            case .success(let jsonResponse):
                if jsonResponse.responseType.isSuccess {
                    print(jsonResponse)

                    UserDefaults.standard.set(jsonResponse.response.dictionaryObject!, forKey: "LoginResponse")
                    
                    UserDefaults.standard.set(jsonResponse.response["profile"].dictionaryObject, forKey: "profileData")
                    UserDefaults.standard.synchronize()
                     SessionHelperClass().setSession(session: jsonResponse.response["session"])
                     let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashBoardVC")as! DashBoardVC
                           let drawerViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SideMenuVC")as! SideMenuVC
                    
                           let drawerController = KYDrawerController(drawerDirection: .left  ,drawerWidth: 200)
                           drawerController.mainViewController = UINavigationController(
                               rootViewController: vc
                           )
                           drawerController.drawerViewController = drawerViewController
                           self.window = UIWindow(frame: UIScreen.main.bounds)
                           self.window?.rootViewController = drawerController
                           self.window?.makeKeyAndVisible()
                
                
                }
                else {
                    self.view.ShowBlackTostWithText(message: jsonResponse.responseMessage, Interval: 3)
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                Message.SomethingWrongAlert(self)
                break
            }
        }
        
        
        
    }
    func getWiFiAddress() -> String? {
        var address : String?
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }


}
