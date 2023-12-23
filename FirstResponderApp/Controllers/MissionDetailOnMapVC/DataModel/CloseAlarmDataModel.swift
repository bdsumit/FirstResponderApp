//
//  CloseAlarmDataModel.swift
//  FirstResponderApp
//
//  Created by bd05 on 1/3/23.
//

import Foundation


struct CloseAlarmParam : Encodable {
    var UserId : Int
    var AlarmId : Int
}

struct CloseAlaramRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode
    }
    
    //MARK: - CLOSE ALARM Api
    static func CloseAlarmApiCall(param : CloseAlarmParam, _ completion : ((Result<CloseAlaramRequest>)->Void)?) {
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        APICall.webRequest(apiType: .POST,endPoint: .closeAlarm, param: Param, forceDecoding: true, decodableObj: CloseAlaramRequest.self, complection: {
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
