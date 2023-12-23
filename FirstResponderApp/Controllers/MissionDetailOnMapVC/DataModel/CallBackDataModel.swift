//
//  CallBackDataModel.swift
//  FirstResponderApp
//
//  Created by bd05 on 1/3/23.
//

import Foundation
struct CallBackParam : Encodable {
    var UserId : Int
    var AlarmId : Int
}

// MARK: - Welcome
struct CallBackRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode
    }
    
    //MARK: - CallBack Api
    static func CallBackApiCall(param : CallBackParam, _ completion : ((Result<CallBackRequest>)->Void)?) {
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        APICall.webRequest(apiType: .POST,endPoint: .callBackApi, param: Param, forceDecoding: true, decodableObj: CallBackRequest.self, complection: {
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
