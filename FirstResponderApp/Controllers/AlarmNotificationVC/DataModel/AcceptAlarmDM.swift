//
//  GetUserAlarmListDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 12/23/22.
//
import Foundation
// MARK: - Welcome
struct AcceptAlarmParam: Encodable{
    var MissionId : String
    var Description: String
    var UserId : Int
    var AlarmId: Int
    var AlarmStatus: String
}

struct AcceptAlarmRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let equipmentPickupData: EquipmentPickupData?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode, equipmentPickupData
    }
    
    //MARK: - AcceptAlarmRequest Api
    static func AcceptAlarmApiCall(param : AcceptAlarmParam, _ completion : ((Result<AcceptAlarmRequest>)->Void)?) {
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        APICall.webRequest(apiType: .POST,endPoint: .acceptAlarm, param: Param, forceDecoding: true, decodableObj: AcceptAlarmRequest.self, complection: {
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
// MARK: - EquipmentPickupData
struct EquipmentPickupData: Codable {
    let id: Int?
    let posLat, posLon: Double?
    let distance: Int?
    let routeInstructions, action: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case posLat = "PosLat"
        case posLon = "PosLon"
        case distance = "Distance"
        case routeInstructions = "RouteInstructions"
        case action = "Action"
    }
}
