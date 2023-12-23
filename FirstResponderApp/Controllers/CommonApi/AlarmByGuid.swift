//
//  AlarmByGuid.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/24/22.
//

import Foundation

struct AlarmFetchUsingGuIdParam : Encodable{
    var AlarmGuId: String
    var userId : Int
}

// MARK: - Welcome
struct GetAlarmByGuIdRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let alarmDetail: AlarmDetail?
    let equipmentList: String?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode, alarmDetail, equipmentList
    }
    
    
    static func alarmByGuIdApiCall(param : AlarmFetchUsingGuIdParam, _ completion : ((Result<GetAlarmByGuIdRequest>)->Void)?) {
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST, endPoint: .getAlarmByGuId , param: Param, decodableObj: GetAlarmByGuIdRequest.self, complection: {
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

// MARK: - AlarmDetail
struct AlarmDetail: Codable {
    let alarmID, userID: Int?
    let missionID, street, floor, city: String?
    let posLat, posLon, municipality, country: String?
    let firstName, lastName, alarmDetailDescription, whiteLists: String?
    let phoneNumber, whiteList, phone, zipCode: String?
    let deviceID, message: String?
    let createdDate: String?
    let alarmStatus, alarmReadStatus: String?
    let updatedTime: String?
    let emailID, status, note: String?
    let alarmStatusID: Int?
    let organizationName: String?
    let organizationID: Int?
    let userAlarmStatus, action: String?
    let equipmentID: Int?
    let alarmCategory, caseType, alarmGuID, alarmStatusColor: String?
    let abortReason: String?
    let channelID: Bool?
    let acceptedCount, equipmentPickupCount: Int?
    let loginDevice, newAlarmSound, updateAlarmSound, abortSound: String?
    let language, alarmReceiverList: String?

    enum CodingKeys: String, CodingKey {
        case alarmID = "AlarmId"
        case userID = "UserId"
        case missionID = "MissionId"
        case street = "Street"
        case floor = "Floor"
        case city = "City"
        case posLat = "PosLat"
        case posLon = "PosLon"
        case municipality = "Municipality"
        case country = "Country"
        case firstName = "FirstName"
        case lastName = "LastName"
        case alarmDetailDescription = "Description"
        case whiteLists = "WhiteLists"
        case phoneNumber = "PhoneNumber"
        case whiteList = "WhiteList"
        case phone = "Phone"
        case zipCode = "ZipCode"
        case deviceID = "DeviceId"
        case message = "Message"
        case createdDate = "CreatedDate"
        case alarmStatus = "AlarmStatus"
        case alarmReadStatus = "AlarmReadStatus"
        case updatedTime = "UpdatedTime"
        case emailID = "EmailId"
        case status = "Status"
        case note = "Note"
        case alarmStatusID = "AlarmStatusId"
        case organizationName = "OrganizationName"
        case organizationID = "OrganizationId"
        case userAlarmStatus = "UserAlarmStatus"
        case action = "Action"
        case equipmentID = "EquipmentId"
        case alarmCategory = "AlarmCategory"
        case caseType = "CaseType"
        case alarmGuID = "AlarmGuId"
        case alarmStatusColor = "AlarmStatusColor"
        case abortReason = "AbortReason"
        case channelID = "ChannelId"
        case acceptedCount = "AcceptedCount"
        case equipmentPickupCount = "EquipmentPickupCount"
        case loginDevice = "LoginDevice"
        case newAlarmSound = "NewAlarmSound"
        case updateAlarmSound = "UpdateAlarmSound"
        case abortSound = "AbortSound"
        case language = "Language"
        case alarmReceiverList
    }
}
