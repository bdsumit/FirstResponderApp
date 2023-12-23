//
//  SaveUserCurrentLocationDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 12/6/22.
//

import Foundation
// MARK: - Welcome

struct SaveLocationInDB : Codable {
    var PosLat : Double?
    var PosLon : Double?
}

struct SaveLocationParam : Encodable {
    var UserId : Int
    var PosLat : Double
    var PosLon : Double
}

struct saveUserCurrentLocationRequest: Codable {
    let errorMessage: String?
    let errorCode, statusCode: Int?
    static func SaveCurrentLocationApiCall(param : SaveLocationParam ,_ completion : ((Result<saveUserCurrentLocationRequest>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .saveUserLocation, param: Param, forceDecoding: true, decodableObj: saveUserCurrentLocationRequest.self, complection: {
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
