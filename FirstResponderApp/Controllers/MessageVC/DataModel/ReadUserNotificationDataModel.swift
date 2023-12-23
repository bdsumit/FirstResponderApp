//
//  ReadUserNotificationDataModel.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/26/22.
//

import Foundation
struct ReadUserNotificationParam : Encodable{
    var UserId : Int
    var NotificationId : Int
}
// MARK: - Welcome
struct ReadUserNotification: Codable {
    let errorMessage: String?
    let errorCode, statusCode: Int?
    
    
    
    //MARK: - Read notification Api
    static func readUserNotiApiCall(param : ReadUserNotificationParam ,_ completion : ((Result<ReadUserNotification>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .readUserNotification, param: Param, forceDecoding: true, decodableObj: ReadUserNotification.self, complection: {
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
