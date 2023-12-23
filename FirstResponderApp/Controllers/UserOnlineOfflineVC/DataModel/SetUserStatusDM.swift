//
//  SetUserStatusDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 12/24/22.
//

import Foundation
struct setUserStatusParam : Encodable{
    var UserId : Int
    var Offline: Bool
    var StartTime : String
    var endTime : String
}
struct SetUserStatusRequest: Codable {
    let errorMessage: String?
    let errorCode, statusCode: Int?
    
    //MARK: - set User Status  api method
    static func setUserStatusApiCall(param : setUserStatusParam ,_ completion : ((Result<SetUserStatusRequest>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .setUserStatus, param: Param, forceDecoding: true, decodableObj: SetUserStatusRequest.self, complection: {
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
