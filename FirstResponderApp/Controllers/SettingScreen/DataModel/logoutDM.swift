//
//  logoutDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 23/11/22.
//

import Foundation

struct logoutParams: Codable {
    let UserId:  Int?
    
    enum CodingKeys: String, CodingKey {
        case UserId = "UserId"
        
    }
}

// MARK: - LogoutReq
struct LogoutReq: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    
    //MARK: - api method
    static func logoutApiCall(param : logoutParams ,_ completion : ((Result<LogoutReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .logout, param: Param, forceDecoding: true, decodableObj: LogoutReq.self, complection: {
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
    
    

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode
    }
}
