//
//  RejectAlarmDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 12/23/22.
//

import Foundation
// MARK: - Welcome
struct RejectAlarmRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode
    }
    
    //MARK: - RejectAlarmRequest Api
    static func RejectAlarmApiCall(param : AcceptAlarmParam, _ completion : ((Result<RejectAlarmRequest>)->Void)?) {
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        APICall.webRequest(apiType: .POST,endPoint: .rejectAlarm, param: Param, forceDecoding: true, decodableObj: RejectAlarmRequest.self, complection: {
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
