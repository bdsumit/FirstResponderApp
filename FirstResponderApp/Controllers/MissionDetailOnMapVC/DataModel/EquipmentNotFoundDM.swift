//
//  EquipmentNotFoundDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 1/3/23.
//

import Foundation

struct EquipmentNotFoundParam : Encodable{
    var UserId : Int
    var AlarmId : Int
    var EquipmentID : Int
    
}


// MARK: - Welcome
struct EquipmentNotFoundRequest: Codable {
    let message: String?
      let errorCode, statusCode: Int?
      let equipmentPickupData: EquipmentPickUPData?

      enum CodingKeys: String, CodingKey {
          case message = "Message"
          case errorCode, statusCode, equipmentPickupData
      }
    
    //MARK: - EQUIPMENT NOT FOUND Api
    static func EquipmentNotFoundApiCall(param : EquipmentNotFoundParam, _ completion : ((Result<EquipmentNotFoundRequest>)->Void)?) {
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        APICall.webRequest(apiType: .POST,endPoint: .EquipmentNotFound, param: Param, forceDecoding: true, decodableObj: EquipmentNotFoundRequest.self, complection: {
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
struct EquipmentPickUPData: Codable {
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
