//
//  updateUserSettingDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 24/11/22.
//

import Foundation

struct updateUserSettingsParams: Codable {
    let UserId:  Int?
    let language : String?
    let muteNavigation : Bool?
    let vibrate : Bool?
    let position : Bool?
    let alarmSound : Bool?
    let alarmFlash : Bool?
    let showStatusSilentNoti : Bool?
    
    
    enum CodingKeys: String, CodingKey {
        case UserId = "UserId"
        case language = "Language"
        case muteNavigation = "Mute_Navigation"
        case vibrate = "Vibrate"
        case position = "Position"
        case alarmSound = "Alarm_Sound"
        case alarmFlash = "Alarm_Flash"
        case showStatusSilentNoti = "showStatusSilentNotification"
        
    }
}


// MARK: - updateUserSettingReq
struct updateUserSettingReq: Codable {
    let errorMessage: String?
    let list: [List]?
    let errorCode, statusCode: Int?
    
    
    //MARK: - api method
    static func updateUserSettingApiCall(param : updateUserSettingsParams ,_ completion : ((Result<updateUserSettingReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .updateUserSetting, param: Param, forceDecoding: true, decodableObj: updateUserSettingReq.self, complection: {
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
        case errorMessage
        case list = "List"
        case errorCode, statusCode
    }
}

// MARK: - List
struct List: Codable {
    let userID: Int?
    let language: String?
    let muteNavigation, vibrate, position, alarmSound: Bool?
    let alarmFlash, showStatusSilentNotification: Bool?
    let distance: Int?
    let distanceUnit: String?
    let message: String?

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
