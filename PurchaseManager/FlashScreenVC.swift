//
//  FlashScreenVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 24/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import KYDrawerController
class FlashScreenVC:UIViewController {
    var window: UIWindow?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.perform(#selector(update), with: nil, afterDelay: 0.1)
    }
    @objc func update() {

        if let _ = UserDefaults.standard.value(forKey: "LoginResponse") {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashBoardVC")as!DashBoardVC
            let drawerViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SideMenuVC")as!SideMenuVC
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
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginPageVC")as! LoginPageVC
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        else if SessionHelperClass().getUserId() == nil {
//
//            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginPageVC")as! LoginPageVC
//
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }else {
//
//            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashBoardVC")as!DashBoardVC
//            let drawerViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SideMenuVC")as!SideMenuVC
//            let drawerController = KYDrawerController(drawerDirection: .left  ,drawerWidth: 200)
//            drawerController.mainViewController = UINavigationController(
//                rootViewController: vc
//            )
//            drawerController.drawerViewController = drawerViewController
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            self.window?.rootViewController = drawerController
//            self.window?.makeKeyAndVisible()
//
//        }
        
        
    }
    
    
    
//    func profile_getDetailsServiceMethod() {
//        
//        
//        self.view.StartLoading()
//        
//        Alamofire.request(CRequest.getRequest(url: CUrls.BaseUrl, suffix: CUrls.login , method: .get, contentType: .urlencode, params: [:], headers: ["Content-Type":"application/json"])).responseSwiftify { (response) in
//            
//            self.view.StopLoading()
//            switch response.result {
//            case .success(let jsonResponse):
//                if jsonResponse.responseType.isSuccess {
//                    print(jsonResponse.response)
//                    let jsonArrr = jsonResponse.response.arrayValue
//                    print(jsonArrr)
//                    UserDefaults.standard.set(jsonResponse.response.dictionaryObject, forKey: "ProfileData")
//                    UserDefaults.standard.synchronize()
//                } else {
//                    self.view.ShowBlackTostWithText(message: jsonResponse.responseMessage, Interval: 3)
//                }
//                break
//            case .failure(let error):
//                print(error.localizedDescription)
//                Message.SomethingWrongAlert(self)
//                if let code = response.response?.statusCode {
//                    if code == 401 {
//                    }
//                }
//                break
//            }
//            
//        }
//    }
}
