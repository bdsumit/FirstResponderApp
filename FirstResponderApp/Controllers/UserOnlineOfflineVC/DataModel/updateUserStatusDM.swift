//
//  updateUserStatusDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 01/12/22.
//

import Foundation

struct updateUserStatusParams: Codable {
    let userId:  Int?
    let Status : String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
        case Status = "Status"
    }
}



// MARK: - updateUserStatusReq
struct updateUserStatusReq: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    
    //MARK: - api method
    static func updateUserStatusApiCall(param : updateUserStatusParams ,_ completion : ((Result<updateUserStatusReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .updateUserStatus, param: Param, forceDecoding: true, decodableObj: updateUserStatusReq.self, complection: {
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
