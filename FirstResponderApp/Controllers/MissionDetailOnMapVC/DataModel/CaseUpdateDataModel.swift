//
//  CaseUpdateDataModel.swift
//  FirstResponderApp
//
//  Created by bd05 on 1/3/23.
//

import Foundation

struct CaseUpdateParam : Encodable{
    var UserId : Int
    var AlarmId : Int
    var AlarmStatus : String
}

// MARK: - Welcome
struct CaseUpdateRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode
    }
    
    //MARK: - CASE UPDATE Api
    static func CaseUpdateApiCall(param : CaseUpdateParam, _ completion : ((Result<CaseUpdateRequest>)->Void)?) {
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        APICall.webRequest(apiType: .POST,endPoint: .caseUpdate, param: Param, forceDecoding: true, decodableObj: CaseUpdateRequest.self, complection: {
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
