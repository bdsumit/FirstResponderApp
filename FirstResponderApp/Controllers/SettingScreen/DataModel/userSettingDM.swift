//
//  userSettingDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 22/11/22.
//

import Foundation

struct getUserSettingParams: Codable {
    let userId:  Int?
    
    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
    }
}

// MARK: - getUserSettingReq
struct getUserSettingReq: Codable {
    let userSettingDetail: UserSettingDetail?
    let errorCode, statusCode: Int?
    
    
    //MARK: - api method
    static func getUserSettingApiCall(param : getUserSettingParams ,_ completion : ((Result<getUserSettingReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .userSetting, param: Param, forceDecoding: true, decodableObj: getUserSettingReq.self, complection: {
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

    enum CodingKeys: String, CodingKey {
        case userSettingDetail = "UserSettingDetail"
        case errorCode, statusCode
    }
}

// MARK: - UserSettingDetail
struct UserSettingDetail: Codable {
    let userID: Int?
    let language: String?
    let muteNavigation, vibrate, position, alarmSound: Bool?
    let alarmFlash, showStatusSilentNotification: Bool?
    let distance: Int?
    let distanceUnit, message: String?

    enum CodingKeys: String, CodingKey {
        case userID = "UserId"
        case language = "Language"
        case muteNavigation = "Mute_Navigation"
        case vibrate = "Vibrate"
        case position = "Position"
        case alarmSound = "Alarm_Sound"
        case alarmFlash = "Alarm_Flash"
        case showStatusSilentNotification = "ShowStatusSilentNotification"
        case distance = "Distance"
        case distanceUnit = "DistanceUnit"
        case message = "Message"
    }
}
