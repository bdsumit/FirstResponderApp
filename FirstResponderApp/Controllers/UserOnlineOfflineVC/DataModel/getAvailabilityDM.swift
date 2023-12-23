//
//  getAvailabilityDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 26/11/22.
//

import Foundation

struct getAvailabilityParams: Codable {
    let userId:  Int?
    
    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
    }
}


// MARK: - getAvailabilityReq
struct getAvailabilityReq: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let availableOpeningHours: [AvailableOpeningHour]?
    
    //MARK: - api method
    static func getAvailabilityApiCall(param : getAvailabilityParams ,_ completion : ((Result<getAvailabilityReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .getAvailability, param: Param, forceDecoding: true, decodableObj: getAvailabilityReq.self, complection: {
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
        case errorCode, statusCode, availableOpeningHours
    }
}

// MARK: - AvailableOpeningHour
struct AvailableOpeningHour: Codable {
    var id: Int?
    var weekDaysEngLish, weekDaysSwedish, startTime, endTime: String?
    var isAvailable: Bool?
    var userID: Int?
    var createdDate: String?
    var message: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case weekDaysEngLish = "WeekDaysEngLish"
        case weekDaysSwedish = "WeekDaysSwedish"
        case startTime = "StartTime"
        case endTime = "EndTime"
        case isAvailable = "IsAvailable"
        case userID = "UserId"
        case createdDate = "CreatedDate"
        case message = "Message"
    }
}
