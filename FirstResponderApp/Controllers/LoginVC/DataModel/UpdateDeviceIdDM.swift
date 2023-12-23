//
//  UpdateDeviceIdDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 12/6/22.
//

import Foundation
struct UpdateDeviceIdParam : Encodable {
    var UserId : Int
    var DeviceId : String
    var LoginDevice : String
}

struct UpdateDeviceIdRequest: Codable {
    let Message: String?
    let errorCode, statusCode: Int?

    //MARK: - api method
    static func UpdateDeviceIdCall(param : UpdateDeviceIdParam ,_ completion : ((Result<UpdateDeviceIdRequest>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .alarmUpdateDeviceId, param: Param, forceDecoding: true, decodableObj: UpdateDeviceIdRequest.self, complection: {
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
