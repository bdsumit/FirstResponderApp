//
//  updateAvailabilityDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 01/12/22.
//

import Foundation
struct updateAvailabilityParams: Codable {
    var userId:  Int?
    var weekDaysEngLish: String?
    var weekDaysSwedish: String?
    var startTime: String?
    var endTime: String?
    var isAvailable: Bool?
    
    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
        case weekDaysEngLish = "weekDaysEngLish"
        case weekDaysSwedish = "weekDaysSwedish"
        case startTime = "startTime"
        case endTime = "endTime"
        case isAvailable = "isAvailable"
        
    }
}
// MARK: - updateAvailabilityReq
struct updateAvailabilityReq: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    
    //MARK: - api method
    static func updateAvailabiltyApiCall(param : [updateAvailabilityParams] ,_ completion : ((Result<updateAvailabilityReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .updateAvailability, param: Param, forceDecoding: true, decodableObj: updateAvailabilityReq.self, complection: {
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
    }
}
