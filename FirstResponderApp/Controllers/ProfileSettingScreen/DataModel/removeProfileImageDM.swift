//
//  removeProfileImageDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 28/11/22.
//

import Foundation

struct removeProfilePhotoParams: Codable {
    let userId:  Int?
    
    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
    }
}

// MARK: - removeProfileImageReq
struct removeProfileImageReq: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let userList: [UserList]?
    
    //MARK: - api method
    static func removeProfilePhotoApiCall(param : removeProfilePhotoParams ,_ completion : ((Result<removeProfileImageReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .removeProfilePhoto, param: Param, forceDecoding: true, decodableObj: removeProfileImageReq.self, complection: {
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
        case errorCode, statusCode, userList
    }
}

// MARK: - UserList
struct UserList: Codable {
    let firstName, lastName: String?
    let username, password, deviceKey, deviceID: String?
    let profileChangesStatus: Int?
    let phoneNumber, emailID: String?
    let organizationID: Int?
    let organizationName: String?
    let distance: Int?
    let distanceUnit: String?
    let language: String?
    let userID: Int?
    let isEnabled, isDeleted: Bool?
    let isApproved: Int?
    let message: String?
    let image: String?
    let status: String?
    let createdDate: String?
    let certificateID, alias: String?
    let isCoordinateBase: Bool?
    let base64String, resourceName, passwordResetToken: String?
    let workingPlace: String?
    let proffession, cprEducation: String?
    let reason: String?
    let countryCode: Int?

    enum CodingKeys: String, CodingKey {
        case firstName = "FirstName"
        case lastName = "LastName"
        case username = "Username"
        case password = "Password"
        case deviceKey = "DeviceKey"
        case deviceID = "DeviceId"
        case profileChangesStatus = "ProfileChangesStatus"
        case phoneNumber = "PhoneNumber"
        case emailID = "EmailId"
        case organizationID = "OrganizationId"
        case organizationName = "OrganizationName"
        case distance = "Distance"
        case distanceUnit = "DistanceUnit"
        case language = "Language"
        case userID = "UserId"
        case isEnabled = "IsEnabled"
        case isDeleted = "IsDeleted"
        case isApproved = "IsApproved"
        case message = "Message"
        case image = "Image"
        case status = "Status"
        case createdDate = "CreatedDate"
        case certificateID = "CertificateId"
        case alias = "Alias"
        case isCoordinateBase = "IsCoordinateBase"
        case base64String = "Base64String"
        case resourceName = "ResourceName"
        case passwordResetToken = "PasswordResetToken"
        case workingPlace = "WorkingPlace"
        case proffession = "Proffession"
        case cprEducation = "CPREducation"
        case reason = "Reason"
        case countryCode = "CountryCode"
    }
}


