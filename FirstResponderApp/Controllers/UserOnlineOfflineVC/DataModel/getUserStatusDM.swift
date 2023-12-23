//
//  getUserStatusDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 30/11/22.
//

import Foundation

struct getUserStatusParams: Codable {
    let userId:  Int?
    
    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
    }
}


// MARK: - getUserStatusReq
struct getUserStatusReq: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let userStatus: UserStatus?
    
    //MARK: - api method
    static func getUserStatusApiCall(param : getUserStatusParams ,_ completion : ((Result<getUserStatusReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .getUserStatus, param: Param, forceDecoding: true, decodableObj: getUserStatusReq.self, complection: {
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
        case errorCode, statusCode, userStatus
    }
}

// MARK: - UserStatus
struct UserStatus: Codable {
    let userID: Int?
    let offline: Bool?
    let startTime, endTime: String?
    let message: String?
    let status: String?
    let emailID, alarmStatus, missionID, alarmStatusColor: String?
    let endDateTime: String?

    enum CodingKeys: String, CodingKey {
        case userID = "UserId"
        case offline = "Offline"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case message = "Message"
        case status = "Status"
        case emailID = "EmailId"
        case alarmStatus = "AlarmStatus"
        case missionID = "MissionId"
        case alarmStatusColor = "AlarmStatusColor"
        case endDateTime = "EndDateTime"
    }
}
