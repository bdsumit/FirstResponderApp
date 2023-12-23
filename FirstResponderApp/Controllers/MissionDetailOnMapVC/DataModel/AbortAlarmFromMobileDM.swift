//
//  AbortAlarmFromMobileDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 12/26/22.
//

import Foundation
struct abortMisonFromMobileParam : Encodable{
    var UserId: Int
    var MissionId: String
}

// MARK: - Welcome
struct abortMisonFromMobileRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode
    }
    
    //MARK: - AbortAlarmRequest Api
    static func AbortAlarmApiCall(param : abortMisonFromMobileParam, _ completion : ((Result<abortMisonFromMobileRequest>)->Void)?) {
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        APICall.webRequest(apiType: .POST,endPoint: .abortMission, param: Param, forceDecoding: true, decodableObj: abortMisonFromMobileRequest.self, complection: {
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
