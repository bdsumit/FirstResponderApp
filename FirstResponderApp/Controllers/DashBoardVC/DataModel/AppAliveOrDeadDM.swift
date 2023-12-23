//
//  AppAliveOrDeadDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 12/21/22.
//

import Foundation
struct appaliveordeadParam : Encodable {
    var UserId : Int
}

// MARK: - App live or dead Api
struct AppAliveOrDeadRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let appAliveorDead: AppAliveorDead?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode
        case appAliveorDead = "AppAliveorDead"
    }
    
    //MARK: - App Alive Or Dead Api
    static func AppAliveOrDeadApiCall(param : appaliveordeadParam,_ completion : ((Result<AppAliveOrDeadRequest>)->Void)?) {
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        APICall.webRequest(apiType: .POST,endPoint: .AppAliveOrDead, param: Param, forceDecoding: true, decodableObj: AppAliveOrDeadRequest.self, complection: {
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

// MARK: - AppAliveorDead
struct AppAliveorDead: Codable {
    let userID: Int?
    let logoutFromApp: Bool?

    enum CodingKeys: String, CodingKey {
        case userID = "UserId"
        case logoutFromApp = "LogoutFromApp"
    }
}
