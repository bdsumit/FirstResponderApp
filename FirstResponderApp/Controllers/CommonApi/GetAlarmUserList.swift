//
//  GetAlarmUserList.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/24/22.
//

import Foundation

struct alarmUserParam : Encodable{
    var UserId : Int
}

// MARK: - Welcome
struct GetUserAlarmListRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let alarmDataList: [AlarmDataList]?
    let equipmentList: EquipmentList?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode, alarmDataList, equipmentList
    }
    static func UserAlarmListApiCall(param :alarmUserParam, _ completion : ((Result<GetUserAlarmListRequest>)->Void)?) {
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST, endPoint: .getUserAlarmalist , param: Param, decodableObj: GetUserAlarmListRequest.self, complection: {
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

// MARK: - AlarmDataList
struct AlarmDataList: Codable {
    let alarmID, userID: Int?
    let missionID, street, floor, city: String?
    let posLat, posLon, municipality, country: String?
    let firstName, lastName, alarmDataListDescription, whiteLists: String?
    let phoneNumber: String?
    let whiteList, phone: String?
    let zipCode: String?
    let deviceID, message: String?
    let createdDate, alarmStatus, alarmReadStatus, updatedTime: String?
    let emailID, status, note: String?
    let alarmStatusID: Int?
    let organizationName: String?
    let organizationID: Int?
    let userAlarmStatus: String?
    let action: String?
    let equipmentID: Int?
    let alarmCategory, caseType: String?
    let alarmGuID, alarmStatusColor: String?
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
        case alarmDataListDescription = "Description"
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

// MARK: - EquipmentList
struct EquipmentList: Codable {
    let id: Int?
    let owner, address, zipCode, city: String?
    let floor, municipality, county: String?
    let displayedOn: Bool?
    let posLat, posLon: Double?
    let routeInstructions: String?
    let alwaysAvailable: Bool?
    let createdDate: String?
    let availableSlots: [AvailableSlot]?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case owner = "Owner"
        case address = "Address"
        case zipCode = "ZipCode"
        case city = "City"
        case floor = "Floor"
        case municipality = "Municipality"
        case county = "County"
        case displayedOn = "DisplayedOn"
        case posLat = "PosLat"
        case posLon = "PosLon"
        case routeInstructions = "RouteInstructions"
        case alwaysAvailable = "AlwaysAvailable"
        case createdDate = "CreatedDate"
        case availableSlots = "AvailableSlots"
    }
}

// MARK: - AvailableSlot
struct AvailableSlot: Codable {
    let id: Int?
    let startTime, endTime, weekday: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case weekday = "Weekday"
    }
}
