//
//  LoginDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 21/11/22.
//

import Foundation

struct loginParams: Codable {
    let emailId:  String?
    let password : String?
    let macId: String?
    let DeviceId : String?
    
    enum CodingKeys: String, CodingKey {
        case emailId = "EmailID"
        case password = "Password"
        case macId = "MacId"
        case DeviceId
    }
}

// MARK: - LoginApiRequest
struct LoginApiRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let userDetail: UserDetail?
    let globalSettings: [GlobalSetting]?
    let userSetting: UserSetting?
    let authToken: String?
    let alarmDataVisibilityList: [AlarmDataVisibilityList]?
    
    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode
        case userDetail = "UserDetail"
        case globalSettings = "GlobalSettings"
        case userSetting, authToken, alarmDataVisibilityList
    }
    
    
    //MARK: - api method
    static func loginApiCall(param : loginParams ,_ completion : ((Result<LoginApiRequest>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .login, param: Param, forceDecoding: true, decodableObj: LoginApiRequest.self, complection: {
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

// MARK: - AlarmDataVisibilityList
struct AlarmDataVisibilityList: Codable {
    let id, freeTextDescriptionID: Int?
    let fieldName, customDescription: String?
    let isEnable: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case freeTextDescriptionID = "FreeTextDescriptionId"
        case fieldName = "FieldName"
        case customDescription = "CustomDescription"
        case isEnable = "IsEnable"
    }
}

// MARK: - GlobalSetting
struct GlobalSetting: Codable {
    let settingName, settingDescription, settingValue: String?
    let displayName, displayDescription, soundBase64String, message: String?
    
    enum CodingKeys: String, CodingKey {
        case settingName = "SettingName"
        case settingDescription = "SettingDescription"
        case settingValue = "SettingValue"
        case displayName = "DisplayName"
        case displayDescription = "DisplayDescription"
        case soundBase64String = "SoundBase64String"
        case message = "Message"
    }
}

// MARK: - UserDetail
struct UserDetail: Codable {
    let userID: Int?
    let emailID, firstName, lastName: String?
    let alias, password: String?
    let phone: String?
    let macID, userType: String?
    let image, deviceID: String?
    let isDeleted, isApproved, isRejected: Bool?
    let passwordResetToken: String?
    let language, muteNavigation: String?
    let vibrate, position, alarmSound, alarmFlash: Bool?
    let distance: Int?
    let status, distanceUnit: String?
    let organizationID: Int?
    let createdDate, modifiedDate, certificateID, message: String?
    let isLogout: Bool?
    let output: Int?
    let userToken: String?
    let profileChangesStatus: Int?
    let workingPlace, proffession, cprEducation: String?
    let countryCode: Int?
    
    enum CodingKeys: String, CodingKey {
        case userID = "UserId"
        case emailID = "EmailId"
        case firstName = "FirstName"
        case lastName = "LastName"
        case alias = "Alias"
        case password = "Password"
        case phone = "Phone"
        case macID = "MacId"
        case userType = "UserType"
        case image = "Image"
        case deviceID = "DeviceId"
        case isDeleted = "IsDeleted"
        case isApproved = "IsApproved"
        case isRejected = "IsRejected"
        case passwordResetToken = "PasswordResetToken"
        case language = "Language"
        case muteNavigation = "Mute_Navigation"
        case vibrate = "Vibrate"
        case position = "Position"
        case alarmSound = "Alarm_Sound"
        case alarmFlash = "Alarm_Flash"
        case distance = "Distance"
        case status = "Status"
        case distanceUnit = "Distance_Unit"
        case organizationID = "OrganizationId"
        case createdDate = "CreatedDate"
        case modifiedDate = "ModifiedDate"
        case certificateID = "CertificateId"
        case message = "Message"
        case isLogout = "IsLogout"
        case output = "Output"
        case userToken = "UserToken"
        case profileChangesStatus = "ProfileChangesStatus"
        case workingPlace = "WorkingPlace"
        case proffession = "Proffession"
        case cprEducation = "CPREducation"
        case countryCode = "CountryCode"
    }
}

// MARK: - UserSetting
struct UserSetting: Codable {
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
