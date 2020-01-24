
import Foundation

struct CUrls {
//    Test url
   static let BaseUrl = "http://13.235.200.245:9006/LuxuryRide/PManagerApp/"
    //Live URL
  //   static let BaseUrl = "http://3.6.35.88:30005/LuxuryRide/PManagerApp/"
    struct employeeList {
        static let  Employees_CityWiseAssignedVehiclesList =  "Employees/CityWiseAssignedVehiclesList"
        static let Employees_AssignedVehiclesList = "Employees/AssignedVehiclesList"
        static let Evaluated_VehiclesListDetails = "Evaluated/VehiclesListDetails"
        static let OnBoarded_VehiclesList = "FollowUp/VehiclesList"
        
    }
    struct vehicle {
        static let Evaluated_VehicleDetails = "VehicleInfo/VehicleDetails"
        static let Evaluated_OverallPartsList = "VehicleInfo/OverallPartsList"
        static let Evaluated_VehicleDocumentDetails = "VehicleInfo/VehicleDocumentDetails"
        static let Evaluated_VehicleAllPartsImages = "VehicleInfo/VehicleAllPartsImages"
        static let Evaluated_VehiclePricingDetails = "VehicleInfo/VehiclePricingDetails"
        static let VehicleInfo_OnBoardStatuses = "VehicleInfo/OnBoardStatuses"
        static let Evaluated_VehicleFinalPricingDetails = "VehicleInfo/VehicleFinalPricingDetails"
        static let Evaluated_VehiclePartsDetails = "VehicleInfo/VehiclePartsDetails"
        // POST Method
        static let Evaluated_saveEvaluationFinalPrice = "Evaluated/saveEvaluationFinalPrice"
    }
    struct City {
        static let Employees_CityList = "Employees/CityList"
    }
    struct rejectAndResche {
        static let Employees_RejectedVehiclesList = "Employees/RejectedVehiclesList"
        static let Employees_ReScheduledVehiclesList = "Employees/ReScheduledVehiclesList"
    }
    struct Profile {
        static let DashBoard_ProfileDetails = "DashBoard/ProfileDetails"
    }
    struct Dashboard {
        static let DashBoard_Counts = "DashBoard/Counts"
    }
    struct Login {
        static let session_login  = "Session/login"
     //  static let update_changePassword = "profile/changePassword"
    }
    struct  Purchased {
        static let Purchased_VehiclesList = "Purchased/VehiclesList"
    }
    struct  session {
        static let session_reauth = "Session/reauth"
        
    }
    
}


extension JSON {
    public var responseType: String {
        return self[CResponse.responseType].stringValue
    }
    public var response: JSON {
        return self[CResponse.response]
    }
    public var responseMessage: String {
        return self[CResponse.response].stringValue
    }
}
extension String {
    public var isSuccess: Bool {
        return self == "200"
    }
    public var isAuth: Bool {
        return self == "400"
    }
}

fileprivate struct CResponse {
    static let responseType = "responseType"
    static let response = "response"
}
