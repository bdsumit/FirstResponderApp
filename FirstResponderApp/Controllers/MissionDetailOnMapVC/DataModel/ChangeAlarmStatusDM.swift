//
//  ChangeAlarmStatusDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 1/5/23.
//

import Foundation
struct ChangeAlarmStatusParam : Encodable {
    var UserId : Int
    var AlarmId : Int
}

struct ChangeAlarmStatusRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode
    }
    
    
    //MARK: - CHANGE ALARMSTATUS IMAGE Api
    static func ChangeAlarmStatusApiCall(param : ChangeAlarmStatusParam, _ completion : ((Result<ChangeAlarmStatusRequest>)->Void)?) {
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        APICall.webRequest(apiType: .POST,endPoint: .ChangeAlarmStatus, param: Param, forceDecoding: true, decodableObj: ChangeAlarmStatusRequest.self, complection: {
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
