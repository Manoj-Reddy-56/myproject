//
//  CRequest.swift
//  PurchaseManager
//
//  Created by Mahesh on 18/12/19.
//  Copyright © 2019 com.luxuryride. All rights reserved.
//
import UIKit
import Alamofire


class CRequest {
    
    private init() { }
    
    static func getRequest(url: String, suffix: String, method: CMethod, contentType: CContentType, params: Dictionary<String,Any>, headers: Dictionary<String,String>) -> URLRequest {
        
        var request = URLRequest.init(url: URL.init(string: url)!)
        
        switch contentType {
        case .jsonEncode:
            
            request.url = URL.init(string: url + suffix)
            
            if let jsonData = try? JSON(params).rawData() {
                request.httpBody = jsonData
            }
            
            break
        case .urlencode:
            
            var paramsStr = ""
            
            for (key,Value) in params {
                paramsStr += paramsStr == "" ? "\(key)=\(Value)" : "&\(key)=\(Value)"
            }
            
            if paramsStr == "" {
                request.url = URL.init(string: url + suffix)
                print("URL IS",request.url)
            }
            else {
                request.url = URL.init(string: url + suffix + "?" + paramsStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            }
            
            break
        default:
            
            var paramsStr = ""
            
            for (key,Value) in params {
                paramsStr += paramsStr == "" ? "\(key)=\(Value)" : "&\(key)=\(Value)"
            }
            
            if method == .get {
                
                if paramsStr == "" {
                    request.url = URL.init(string: url + suffix)
                }
                else {
                    request.url = URL.init(string: url + suffix + "?" + paramsStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                }
                
            }
            else {
                
                request.url = URL.init(string: url + suffix)
                
                request.httpBody = paramsStr.data(using: .utf8)
            }
            
            break
        }
        
        request.httpMethod = method.getraw()
        
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    
    
    
    static func getArrRequest(url: String, suffix: String, method: CMethod, contentType: CContentType, params: Array<Dictionary<String,Any>>, headers: Dictionary<String,String>) -> URLRequest {
        
        var request = URLRequest.init(url: URL.init(string: url)!)
        
        request.url = URL.init(string: url + suffix)
        
        if let jsonData = try? JSON(params).rawData() {
            request.httpBody = jsonData
        }
        
        request.httpMethod = method.getraw()
        
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    
}

class InternetReachable {
    
    private init() {}
    
    public static var ValidateInternet: Bool {
        
        if (Reachability()?.isReachable)! {
            return true
        }
        else {
            return false
        }
    }
}

extension Request {
    
    public static func serializeResponse(
        options: JSONSerialization.ReadingOptions,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<JSON>
    {
        guard error == nil else { return .failure(error!) }
        
        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success(JSON.null) }
        
        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }
        
        do {
            
            let json = try JSONSerialization.jsonObject(with: validData, options: options)
            return .success(JSON(json))
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
        }
    }
}

extension DataRequest {
    
    public static func ResponseSerializer(
        options: JSONSerialization.ReadingOptions = .allowFragments)
        -> DataResponseSerializer<JSON>
    {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponse(options: options, response: response, data: data, error: error)
        }
    }
    
    @discardableResult
    public func responseSwiftify(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<JSON>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.ResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}


private let emptyDataStatusCodes: Set<Int> = [204, 205]

enum CContentType {
    case urlencode, jsonEncode, `default`
}

enum CMethod {
    case get, post
    
    func getraw() -> String {
        switch self {
        case .get:
            return "GET"
        default:
            return "POST"
        }
    }
}

class Webservice {
    
    func call(cRequest: URLRequest, completionHandler: @escaping (DataResponse<JSON>,Bool) -> Void) {
        
        Alamofire.request(cRequest).responseSwiftify { (response) in
            //            switch response.result {
            //            case .success(_):
            //                completionHandler(response,false)
            //                break
            //            case .failure(let error):
            //                print(error.localizedDescription)
            
            if let code = response.response?.statusCode {
                if code == 401  {
                    print("401 is error")
                    SessionHandler().reauthSessionDataServiceMethod(completion: { (success, auth) in
                        if auth {
                            print("401 is error auth")
                            
                            completionHandler(response,true)
                        }
                        else {
                            if(success) {
                                var headers = cRequest.allHTTPHeaderFields ?? [:]
                                headers["Authorization"] = SessionHelperClass.shared.getAuthKey()!;
                                var request = cRequest
                                request.allHTTPHeaderFields = headers
                                self.call(cRequest: request, completionHandler: completionHandler)
                            }
                            else {
                                completionHandler(response,false)
                            }
                        }
                    })
                }
                else {
                    
                    completionHandler(response,false)
                }
            } else {
                completionHandler(response,false)
            }
            //                break
            //            }
        }
    }
}
