//
//  NetworkRequester.swift
//  Qeeptouch
//
//  Created by Javi on 3/16/16.
//  Copyright © 2016 Qeeptouch. All rights reserved.
//

import Foundation
import Alamofire

fileprivate var kTokenName = "x-access-token"

struct NetworkRequesterService {
    var requester: AnyObject?
    var service: Request?
    var toRemove:Bool = false
}

fileprivate extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

class NetworkRequesterData {
    static var shared = NetworkRequesterData()
    var versionFull:String {
        let shortBundleVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let shortBundleName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        return "\(shortBundleName) Version: \(shortBundleVersion) Build: \(bundleVersion)"
    }
    var bundleName:String {
        let shortBundleName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        return shortBundleName
    }
    var versionShort:String {
        let shortBundleVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        return shortBundleVersion
    }
    var internalAppIdentifier:String {
        get {
            return "LOCATOR-IOS"
        }
    }
}

class NetworkRequesterStack {
    static var sharedInstance = NetworkRequesterStack()
    
    var requests: Array<NetworkRequesterService> = Array<NetworkRequesterService>()
    
    func cancelPreviousRequests(_ requester: AnyObject, service:Request) {
        for request in requests {
            if request.requester! === requester {
                if request.service?.request?.url == service.request?.url {
//                    if request.service?.progress.fractionCompleted != 1 {
                        request.service?.cancel()
                        print("stopping")
//                    }
                }
            }
        }
    }

    func addRequestToStack(_ requester: AnyObject, service:Request) {
        var request = NetworkRequesterService()
        
        request.requester = requester
        request.service = service
        
        cancelPreviousRequests(requester, service: service)
        requests.append(request)
        
//        dumpStack()
    }
    
    func dumpStack() {
        for request in requests {
//            print ("owner:\(request.requester!) url:\(request.service?.request?.url) status:\(request.service?.progress.fractionCompleted)")
            print ("owner:\(request.requester!) url:\(request.service?.request?.url)")
        }
    }
    
}

protocol NetworkRequester: TokenHandler,CacheSaver,JSONParser,ActivityIndicatorHandler {
    var kMultipartBoundary : String { get }
}

public enum ResponseErrorType:Int {
    case nilResponse = 7000
    case tokenHasExpired
    case noRights
    case failStatus
    case httpResponseError
    case jsonHasInvalidFormat
    case serverIsOnMaintenance
    case resultIsMissing
    case invalidVersion
}

extension NSError {
    convenience init(errorType:ResponseErrorType, message: String)  {
        let userInfo = NSDictionary(dictionary: [NSLocalizedDescriptionKey: message] )
        
        self.init(domain: "ErrorDomain", code: errorType.rawValue, userInfo: userInfo as? [String: Any])
    }
    
}

extension NetworkRequester {
    
    fileprivate func getCommonHeaders() -> [String:String] {
        let headers: [String:String] = [
            "version-client": NetworkRequesterData.shared.versionShort,
            "origin-client" : "QEEPTOUCH-BUILDINGS-IOS"
        ]

        return headers
    }
    
    var kMultipartBoundary : String {
        return "---BOUNDARY12345---"
    }
    
    //MARK: - Functions
    fileprivate func getLanguage() -> String {
        let lang =  Locale.preferredLanguages.first!
        /*let index: String.Index = lang.characters.index(lang.startIndex, offsetBy: 2)
        lang = lang.substring(to: index)
        */
        return lang
    }

    fileprivate func getMessageFromJSONResponse(_ json: NSDictionary) -> String {
        if let message = json["message"] as? String {
            return message
        }
        return ""
    }
    
    fileprivate func checkResponseForErrors (_ jsonData : NSDictionary?) -> NSError? {
        
        if let json = jsonData {
            if let status = json["status"] as? String {
                switch status {
                case "SUCCESS","OK","200","201":
                    return nil
                case "NO_RIGHTS":
                    return NSError(errorType: ResponseErrorType.noRights, message: getMessageFromJSONResponse(json))
                case "426":
                    //This is less than perfect, but... at least you have to willingly enable it with a compilation flag
                    #if APP_VERSION_CHECK
                    NotificationCenter.default.post(name: ApplicationEvents.invalidAppVersionDetected, object: nil)
                    #endif
                    return NSError(errorType: ResponseErrorType.invalidVersion, message: getMessageFromJSONResponse(json))
                default:
                    return NSError(errorType: ResponseErrorType.failStatus, message: getMessageFromJSONResponse(json))
                }
            } else if let status = json["status"] as? Int {
                switch status {
                case 200:
                    return nil
                case 201:
                    return nil
                case 426:
                    //This is less than perfect, but... at least you have to willingly enable it with a compilation flag
                    #if APP_VERSION_CHECK
                    NotificationCenter.default.post(name: ApplicationEvents.invalidAppVersionDetected, object: nil)
                    #endif
                    return NSError(errorType: ResponseErrorType.invalidVersion, message: getMessageFromJSONResponse(json))
                default:
                    return NSError(errorType: ResponseErrorType.failStatus, message: getMessageFromJSONResponse(json))
                }
            }
        }
        return nil
    }
    
    fileprivate func dataFromString(_ string: String) -> Data {
        if let data = string.data(using: String.Encoding.utf8) {
            return data
        }
        return Data()
    }
    
    func createBodyWithParameters(_ parameters: [String : AnyObject], imageData: Data) -> Data {
        
        let boundary = kMultipartBoundary
        
        var body = Data()

        for (key, value) in parameters {
            print("--\(boundary)\r\n")
            print("Content-Disposition: form-data; name=\"\(key)\"\r\n")
            print("\(value)\r\n")

            body.append(dataFromString("--\(boundary)\r\n"))
            body.append(dataFromString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"))
            body.append(dataFromString("\(value)\r\n"))
        }
        
        body.append(dataFromString("--\(boundary)\r\n"))
        body.append(dataFromString("Content-Disposition: form-data; name=\"post-image\"; filename=\"image.jpg\"\r\n"))
        body.append(dataFromString("Content-Type: image/jpeg\r\n\r\n"))
        body.append(imageData)
        body.append(dataFromString("\r\n"))
        body.append(dataFromString("--\(boundary)--\r\n"))
        return body
    }
    
    //MARK: - UPLOAD requests
    func executeUPLOADRequestAndValidateResponse(_ urlString:String, data:Data, parameters: [String : AnyObject], successBlock: @escaping(_ json:NSDictionary)->(), failBlock: @escaping (_ error: NSError)->(), progressBlock: ((_ progress:Double) -> ())? = nil ) {
        let token = getToken()
        
        #if SHOW_REQUESTS
            print("🚀\(urlString)")
        #endif
        
        let url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        var headers:[String:String] = [
            kTokenName:token,
            "Accept-Language":getLanguage(),
            "Content-Type":"multipart/form-data; boundary=\(kMultipartBoundary)"
        ]
        headers.update(other: getCommonHeaders())
        
        startActivityIndicator()
        Alamofire.upload(createBodyWithParameters(parameters, imageData: data), to: url, method: .post, headers: headers)
        .uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
            progressBlock?(progress.fractionCompleted)
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .validate(statusCode: 200..<500)
        .validate(contentType: ["application/json"])
        .validate { request, response, data in
            // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
            return .success
        }
        .responseJSON { response in
            self.stopActivityIndicator()
            if let json = response.result.value as? NSDictionary {
                if let error = self.checkResponseForErrors(json) {
                    failBlock(error)
                } else {
                    successBlock(json)
                }
            } else {
                //Fail will be handled down in the generic response
            }
        }
        .response { response in
            if let error = response.error {
                self.stopActivityIndicator()
                failBlock(NSError(errorType: ResponseErrorType.jsonHasInvalidFormat, message: error.localizedDescription))
            }
        }
    }
    
    //MARK: - POST requests
    func executePOSTRequestAndValidateResponse(_ urlString:String, parameters:[String: AnyObject]?, successBlock: @escaping (_ json:NSDictionary)->(), failBlock: @escaping (_ error:NSError)->(), cacheKey:String?, encodeUrl:Bool = true, additionalHeaders:[String:String]? = nil, fakeToken:Bool = false  ){
        
        var token = getToken()
        
        if fakeToken {
            token = "FAKE"
        }
        

        #if SHOW_REQUESTS
            print("🚀\(urlString)")
        #endif

        var url:String
        
        if encodeUrl {
            url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        } else {
            url = urlString
        }
//        let url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        var headers: [String:String] = [
            kTokenName:token,
            "Accept-Language":getLanguage()
        ]
        headers.update(other: getCommonHeaders())
        
        if let userHeaders = additionalHeaders {
            for header in userHeaders {
                headers[header.key] = header.value
            }
        }
        
        startActivityIndicator()
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .validate(statusCode: 200..<500)
        .validate(contentType: ["application/json"])
        .responseJSON { response in
            self.stopActivityIndicator()
            if let json = response.result.value as? NSDictionary {
                if let error = self.checkResponseForErrors(json) {
                    failBlock(error)
                } else {
                    successBlock(json)
                }
            } else {
                //Fail will be handled down in the generic response
            }
        }
        .responseString { response in
            
            if let _ = cacheKey {
                if let stringResponse = response.result.value {
                    let json = self.JSONParseDictionary(stringResponse)
                    if let _ = self.checkResponseForErrors(json as NSDictionary?) {
                        
                    } else {
                        self.saveResponseToCache(stringResponse, key: cacheKey!)
                    }
                }
            }
        }
        .response { response in
            if let error = response.error {
                self.stopActivityIndicator()
                failBlock(NSError(errorType: ResponseErrorType.jsonHasInvalidFormat, message: error.localizedDescription))
            }
        }
//        NetworkRequesterStack.sharedInstance.addRequestToStack(self as AnyObject , service: request)
    }
    
    //MARK: PUT requests
    
    func executePUTRequestAndValidateResponse(_ urlString:String, parameters:[String: AnyObject]?, successBlock: @escaping (_ json:NSDictionary)->(), failBlock: @escaping (_ error:NSError)->(), cacheKey:String?, encodeUrl:Bool = true, additionalHeaders:[String:String]? = nil, fakeToken:Bool = false  ){
        
        var token = getToken()
        
        if fakeToken {
            token = "FAKE"
        }
        
        
        print("Calling -->")
        print("🚀\(urlString)")
        
        
        var url:String
        
        if encodeUrl {
            url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        } else {
            url = urlString
        }
        //        let url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        var headers: [String:String] = [
            kTokenName:token,
            "Accept-Language":getLanguage()
        ]
        headers.update(other: getCommonHeaders())
        
        if let userHeaders = additionalHeaders {
            for header in userHeaders {
                headers[header.key] = header.value
            }
        }
        
        startActivityIndicator()
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<500)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                self.stopActivityIndicator()
                if let json = response.result.value as? NSDictionary {
                    if let error = self.checkResponseForErrors(json) {
                        failBlock(error)
                    } else {
                        successBlock(json)
                    }
                } else {
                    //Fail will be handled down in the generic response
                }
            }
            .responseString { response in
                
                if let _ = cacheKey {
                    if let stringResponse = response.result.value {
                        let json = self.JSONParseDictionary(stringResponse)
                        if let _ = self.checkResponseForErrors(json as NSDictionary?) {
                            
                        } else {
                            self.saveResponseToCache(stringResponse, key: cacheKey!)
                        }
                    }
                }
            }
            .response { response in
                if let error = response.error {
                    self.stopActivityIndicator()
                    failBlock(NSError(errorType: ResponseErrorType.jsonHasInvalidFormat, message: error.localizedDescription))
                }
        }
        //        NetworkRequesterStack.sharedInstance.addRequestToStack(self as AnyObject , service: request)
    }
    
    
    
    //MARK: - DELETE requests
    func executeDELETERequestAndValidateResponse(_ urlString:String, parameters:[String: AnyObject]?, successBlock: @escaping (_ json:NSDictionary)->(), failBlock: @escaping (_ error:NSError)->(), cacheKey:String?  ){
        
        let token = getToken()
        
        #if SHOW_REQUESTS
            print("🚀\(urlString)")
        #endif
        
        let url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        var headers:[String:String] = [
            kTokenName:token,
            "Accept-Language":getLanguage()
        ]
        headers.update(other: getCommonHeaders())
        
        startActivityIndicator()
        
        Alamofire.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<500)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                self.stopActivityIndicator()
                if let json = response.result.value as? NSDictionary {
                    if let error = self.checkResponseForErrors(json) {
                        failBlock(error)
                    } else {
                        successBlock(json)
                    }
                } else {
                    //Fail will be handled down in the generic response
                }
            }
            .responseString { response in
                
                if let _ = cacheKey {
                    if let stringResponse = response.result.value {
                        let json = self.JSONParseDictionary(stringResponse)
                        if let _ = self.checkResponseForErrors(json as NSDictionary?) {
                            
                        } else {
                            self.saveResponseToCache(stringResponse, key: cacheKey!)
                        }
                    }
                }
            }
            .response { response in
                if let error = response.error {
                    self.stopActivityIndicator()
                    failBlock(NSError(errorType: ResponseErrorType.jsonHasInvalidFormat, message: error.localizedDescription))
                }
        }
        //        NetworkRequesterStack.sharedInstance.addRequestToStack(self as AnyObject , service: request)
    }
    
    //MARK: - GET Requests
    func executeGETRequestAndValidateResponse(_ urlString:String, successBlock: @escaping (_ json:NSDictionary)->(), failBlock: @escaping (_ error:NSError)->() ){
        executeGETRequestAndValidateResponse(urlString, successBlock: successBlock, failBlock: failBlock, cacheKey: nil)
    }

    func executeGETRequestAndValidateResponse(_ urlString:String, successBlock: @escaping (_ json:NSDictionary)->(), failBlock: @escaping (_ error:NSError)->(), cacheKey:String? ){
        let token = getToken()
        
        #if SHOW_REQUESTS
            print("🚀\(urlString)")
        #endif
        
        let url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        var headers:[String:String] = [
            kTokenName:token,
            "Accept-Language":getLanguage()
        ]
        headers.update(other: getCommonHeaders())
        
        startActivityIndicator()
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
        .validate(statusCode: 200..<500)
        .validate(contentType: ["application/json","text/javascript"])
        .responseJSON { response in
            self.stopActivityIndicator()
            if let json = response.result.value as? NSDictionary {
                if let error = self.checkResponseForErrors(json) {
                    failBlock(error)
                } else {
                    successBlock(json)
                }
            }
        }
        .responseString { response in
                
            if let _ = cacheKey {
                if let stringResponse = response.result.value {
                    let json = self.JSONParseDictionary(stringResponse)
                    if let _ = self.checkResponseForErrors(json as NSDictionary?) {
                        
                    } else {
                        self.saveResponseToCache(stringResponse, key: cacheKey!)
                    }
                }
            }
        }
        .response { response in
            if let error = response.error {
                self.stopActivityIndicator()
                failBlock(NSError(errorType: ResponseErrorType.jsonHasInvalidFormat, message: error.localizedDescription))
            }
        }
//        NetworkRequesterStack.sharedInstance.addRequestToStack(self as AnyObject , service: request)
        
    }
    
}
