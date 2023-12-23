//
//  getUserDetailsDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 25/11/22.
//

import Foundation

struct getUserDetailsParams: Codable {
    let userId:  Int?
    
    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
    }
}


// MARK: - getUserDetailsReq
struct getUserDetailsReq: Codable {
    let userDetail: UserDetail?
    let userSetting: getUserSetting?
    let globalSettings: [GlobalSetting]?
    let errorCode, statusCode: Int?
    let authToken: String?
    let alarmDataVisibilityList: [AlarmDataVisibilityList]?
    
    //MARK: - api method
    static func getUserDetailsApiCall(param : getUserDetailsParams ,_ completion : ((Result<getUserDetailsReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .getUserDetails, param: Param, forceDecoding: true, decodableObj: getUserDetailsReq.self, complection: {
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
        case userDetail = "UserDetail"
        case userSetting = "UserSetting"
        case globalSettings = "GlobalSettings"
        case errorCode, statusCode, authToken, alarmDataVisibilityList
    }
}

//// MARK: - AlarmDataVisibilityList
//struct getAlarmDataVisibilityList: Codable {
//    
//    let id, freeTextDescriptionID: Int?
//    let fieldName, customDescription: String?
//    let isEnable: Bool?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "ID"
//        case freeTextDescriptionID = "FreeTextDescriptionId"
//        case fieldName = "FieldName"
//        case customDescription = "CustomDescription"
//        case isEnable = "IsEnable"
//    }
//}



// MARK: - UserSetting
struct getUserSetting: Codable {
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
