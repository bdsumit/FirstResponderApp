//
//  updateProfileDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 25/11/22.
//

import Foundation


struct updateUserDetailsParams: Codable {
    var userId:  String?
    var Phone : String?
    var fName : String?
    var lName : String?
    var email : String?
    var proffession : String?
    var workplace : String?
    var cprEductaion : String?
    var password : String?
    var countryCode : String?
    var confPass : String?
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
        case Phone = "Phone"
        case fName = "FirstName"
        case lName = "LastName"
        case email = "EmailId"
        case proffession = "Proffession"
        case workplace = "WorkingPlace"
        case cprEductaion = "CPREducation"
        case password = "Password"
        case countryCode = "CountryCode"
        case confPass 
    }
}

// MARK: - updateUserReq
struct updateUserReq: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let userDetail: profileUserDetail?
    
    //MARK: - api method
    static func updateUserDetailsApiCall(param : updateUserDetailsParams ,_ completion : ((Result<updateUserReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .updateUserDetails, param: Param, forceDecoding: true, decodableObj: updateUserReq.self, complection: {
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
        case errorCode, statusCode
        case userDetail = "UserDetail"
    }
}

// MARK: - UserDetail
struct profileUserDetail: Codable {
    let userID: Int?
    let emailID, firstName, lastName: String?
    let alias, password: String?
    let phone: String?
    let macID, userType: String?
    let image, deviceID: String?
    let isDeleted, isApproved, isRejected: Bool?
    let passwordResetToken: String?
    let language: String?
    let muteNavigation: String?
    let vibrate, position, alarmSound, alarmFlash: Bool?
    let distance: Int?
    let status: String?
    let distanceUnit: String?
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

