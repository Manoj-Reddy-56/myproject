//
//  SideMenuVC.swift
//  PurchaseManager
//
//  Created by Mahesh on 06/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//

import UIKit
import KYDrawerController
class SideMenuVC: UIViewController {

    @IBOutlet var profileView: UIView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var mobileNumLabel: UILabel!
    @IBOutlet var designationLabel: UILabel!
    @IBOutlet var sideMenuTableView: UITableView!
    let vcs = "Rescheduled"
    let vcs2 = "Rejected"
    var menuList = ["DashBoard","Employee List","Evaluated Cars","Follow UP","Purchased Cars","Rescheduled Vehicles","Rejected Vehicles","Profile"]
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuTableView.tableHeaderView = profileView
        self.sideMenuTableView.estimatedRowHeight = 45
        self.sideMenuTableView.tableHeaderView = profileView
        
        if let profileValues = UserDefaults.standard.object(forKey: "profileData") as? [String:Any] {
            self.userNameLabel.text = (profileValues["employeeName"] as? String)?.uppercased()
            self.mobileNumLabel.text = profileValues["phoneNumber"] as? String
            self.designationLabel.text = profileValues["employeeRole"] as? String
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        }
    



}
extension SideMenuVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableCell", for: indexPath)as! SideMenuTableCell
        cell.sideMenuLabel.text = menuList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let elDrawer = self.parent as! KYDrawerController
            let vc = UIStoryboard.init(name: "Main", bundle:Bundle.main).instantiateViewController(withIdentifier: "DashBoardVC")as! DashBoardVC
            
            let nav = elDrawer.mainViewController as! UINavigationController
            nav.viewControllers = [vc]
            elDrawer.setDrawerState(.closed, animated: true)
            break
        case 1:
            let elDrawer = self.parent as! KYDrawerController
            let vc = UIStoryboard.init(name: "Main", bundle:Bundle.main).instantiateViewController(withIdentifier: "EmployeNamesVC")as! EmployeNamesVC
            let nav = elDrawer.mainViewController as! UINavigationController
            nav.viewControllers = [vc]
            elDrawer.setDrawerState(.closed, animated: true)
            break
        case 2:
            let elDrawer = self.parent as! KYDrawerController
            let vc = UIStoryboard.init(name: "Main", bundle:Bundle.main).instantiateViewController(withIdentifier: "EvaluatedCarsVC")as! EvaluatedCarsVC
            
            let nav = elDrawer.mainViewController as! UINavigationController
            self.perform(#selector(self.StopAuto2), with: nil, afterDelay: 0.2)
            nav.viewControllers = [vc]
            elDrawer.setDrawerState(.closed, animated: true)
            break
        case 3:
            let elDrawer = self.parent as! KYDrawerController
            let vc = UIStoryboard.init(name: "Main", bundle:Bundle.main).instantiateViewController(withIdentifier: "EvaluatedCarsVC")as! EvaluatedCarsVC
            let nav = elDrawer.mainViewController as! UINavigationController
            self.perform(#selector(self.StopAuto3), with: nil, afterDelay: 0.2)
            nav.viewControllers = [vc]
            elDrawer.setDrawerState(.closed, animated: true)
            break
        case 4:
            let elDrawer = self.parent as! KYDrawerController
            let vc = UIStoryboard.init(name: "Main", bundle:Bundle.main).instantiateViewController(withIdentifier: "PurchasedCarsVC")as! PurchasedCarsVC
            let nav = elDrawer.mainViewController as! UINavigationController
          //  self.perform(#selector(self.StopAuto3), with: nil, afterDelay: 0.2)
            nav.viewControllers = [vc]
            elDrawer.setDrawerState(.closed, animated: true)
            break
        case 5:
            let elDrawer = self.parent as! KYDrawerController
            let vc = UIStoryboard.init(name: "Main", bundle:Bundle.main).instantiateViewController(withIdentifier: "RescheduledAndRejectedVC")as! RescheduledAndRejectedVC
            let nav = elDrawer.mainViewController as! UINavigationController
            self.perform(#selector(self.StopAuto), with: nil, afterDelay: 0.2)
          
            nav.viewControllers = [vc]
            
            elDrawer.setDrawerState(.closed, animated: true)
            break
        case 6:
            let elDrawer = self.parent as! KYDrawerController
            let vc = UIStoryboard.init(name: "Main", bundle:Bundle.main).instantiateViewController(withIdentifier: "RescheduledAndRejectedVC")as! RescheduledAndRejectedVC
            let nav = elDrawer.mainViewController as! UINavigationController
            self.perform(#selector(self.StopAuto1), with: nil, afterDelay: 0.2)
            
            nav.viewControllers = [vc]
            elDrawer.setDrawerState(.closed, animated: true)
            break
        case 7:
            let elDrawer = self.parent as! KYDrawerController
            let vc = UIStoryboard.init(name: "Main", bundle:Bundle.main).instantiateViewController(withIdentifier: "ProfileVC")as! ProfileVC
            let nav = elDrawer.mainViewController as! UINavigationController
            nav.viewControllers = [vc]
            elDrawer.setDrawerState(.closed, animated: true)
            break
        default:
            break
        }
       
        
    }
    @objc func StopAuto(_ time:Timer) {
        NotificationCenter.default.post(name: NSNotification.Name("Change"), object: "Rescheduled Vehicles")
        
    }
    @objc func StopAuto1(_ time:Timer) {
        NotificationCenter.default.post(name: NSNotification.Name("Change"), object: "Rejected Vehicles")
      
    }
    @objc func StopAuto2(_ time:Timer) {
        NotificationCenter.default.post(name: NSNotification.Name("Change"), object: "Evaluated Cars")
        
    }
    @objc func StopAuto3(_ time:Timer) {
        NotificationCenter.default.post(name: NSNotification.Name("Change"), object: "Follow UP")
        
    }
    
}
class SideMenuTableCell:UITableViewCell{
    
    @IBOutlet var sideMenuLabel: UILabel!
}
