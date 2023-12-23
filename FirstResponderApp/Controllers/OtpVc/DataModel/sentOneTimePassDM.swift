//
//  sentOneTimePassDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 22/11/22.
//

import Foundation

struct sentOneTimePassParams: Codable {
    let userId:  Int?
    let emailId : String?
    let phone : String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
        case emailId = "EmailId"
        case phone = "Phone"
    }
}

struct checkOneTimePassParams: Codable {
    let userId:  Int?
    let otp : String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
        case otp = "OTP"
    }
}

struct updateUserPassParams: Codable {
    let userId:  Int?
    let password : String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
        case password = "Password"
    }
}


// MARK: - sentOneTimePassReq
struct sentOneTimePassReq: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let errorMessage : String?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode
        case errorMessage = "errorMessage"
        
    }
    
    //MARK: - sent One Time Password api method
    static func sentOneTimePassApiCall(param : sentOneTimePassParams ,_ completion : ((Result<sentOneTimePassReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .sentOneTimePass, param: Param, forceDecoding: true, decodableObj: sentOneTimePassReq.self, complection: {
            (res) in
            switch res {
            case .Success(let res, _):
                DispatchQueue.main.async {
                    completion?(.Success(res!))
                }
            case .CustomError(let str):
                DispatchQueue.main.async {
                    completion?(.CustomError(str))
                }
            }
        })
    }
    
    //MARK: - check One Time Password api method
    static func checkOneTimePassApiCall(param : checkOneTimePassParams ,_ completion : ((Result<sentOneTimePassReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .checkOneTimePass, param: Param, forceDecoding: true, decodableObj: sentOneTimePassReq.self, complection: {
            (res) in
            switch res {
            case .Success(let res, _):
                DispatchQueue.main.async {
                    completion?(.Success(res!))
                }
            case .CustomError(let str):
                DispatchQueue.main.async {
                    completion?(.CustomError(str))
                }
            }
        })
    }
    
    
    
    //MARK: - Update User Password api method
    static func updateUserPassApiCall(param : updateUserPassParams ,_ completion : ((Result<sentOneTimePassReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .updateUserPass, param: Param, forceDecoding: true, decodableObj: sentOneTimePassReq.self, complection: {
            (res) in
            switch res {
            case .Success(let res, _):
                DispatchQueue.main.async {
                    completion?(.Success(res!))
                }
            case .CustomError(let str):
                DispatchQueue.main.async {
                    completion?(.CustomError(str))
                }
            }
        })
    }
    
    
}
