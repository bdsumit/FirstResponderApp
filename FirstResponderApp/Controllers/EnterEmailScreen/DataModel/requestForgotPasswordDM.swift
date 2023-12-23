//
//  requestForgotPasswordDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 22/11/22.
//

import Foundation

struct forgotPassParams: Codable {
    let emailId:  String?
    
    
    enum CodingKeys: String, CodingKey {
        case emailId = "EmailId"
        
    }
}


// MARK: - forgotPasswordReq
struct forgotPasswordReq: Codable {
    let message , errorMessage : String?
    let errorCode, statusCode: Int?
    let requestForgotPasswordDetail: RequestForgotPasswordDetail?
    
    
    //MARK: - api method
    static func forgotPasswordApiCall(param : forgotPassParams ,_ completion : ((Result<forgotPasswordReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .requestForgotPass, param: Param, forceDecoding: true, decodableObj: forgotPasswordReq.self, complection: {
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
        case message = "Message"
        case errorMessage
        case errorCode, statusCode, requestForgotPasswordDetail
    }
}

// MARK: - RequestForgotPasswordDetail
struct RequestForgotPasswordDetail: Codable {
    let userID: Int?
    let emailID, firstName: String?
    let lastName, alias, password: String?
    let phone: String?
    let macID, userType, image, deviceID: String?
    let isDeleted, isApproved, isRejected: Bool?
    let passwordResetToken, language, muteNavigation: String?
    let vibrate, position, alarmSound, alarmFlash: Bool?
    let distance: Int?
    let status, distanceUnit: String?
    let organizationID: Int?
    let createdDate, modifiedDate: String?
    let certificateID: String?
    let message: String?
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
