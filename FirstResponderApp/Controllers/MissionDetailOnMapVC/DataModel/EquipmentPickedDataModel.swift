//
//  EquipmentPickedDataModel.swift
//  FirstResponderApp
//
//  Created by bd05 on 1/3/23.
//

import Foundation

struct EquipmentPickedParam : Encodable{
    var UserId : Int
    var AlarmId : Int
    var EquipmentID : Int
    
}

struct EquipmentPickedRquest: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let equipmentPickupData: String?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode, equipmentPickupData
    }
    
    
    //MARK: - EQUIPMENT PICKED Api
    static func EquipmenPickedApiCall(param : EquipmentPickedParam, _ completion : ((Result<EquipmentPickedRquest>)->Void)?) {
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        APICall.webRequest(apiType: .POST,endPoint: .EquipmentPicked, param: Param, forceDecoding: true, decodableObj: EquipmentPickedRquest.self, complection: {
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
