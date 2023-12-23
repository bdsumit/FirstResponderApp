//
//  GetAllGlobalSettings.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/29/22.
//

import Foundation


// MARK: - Welcome
struct GetAllGlobelSetting: Codable {
    let globalSettings: [GlobalSetting]?
    let errorCode, statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case globalSettings = "GlobalSettings"
        case errorCode, statusCode
    }
    
    
    //MARK: - GetAllGlobelSetting Api
    static func globelSettingApiCall(_ completion : ((Result<GetAllGlobelSetting>)->Void)?) {
     
        APICall.webRequest(apiType: .GET,endPoint: .getGlobelSetting, param: nil, forceDecoding: true, decodableObj: GetAllGlobelSetting.self, complection: {
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


