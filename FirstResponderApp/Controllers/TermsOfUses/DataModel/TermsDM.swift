//
//  TermsDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 21/11/22.
//

import Foundation
// MARK: - TermsApiRequest
struct TermsApiRequest: Codable {
    let errorCode, statusCode: Int?
    let globalSettings: [GlobalSettingData]?
    
    
    //MARK: - Terms Of Use Api
    static func termsApiCall( _ completion : ((Result<TermsApiRequest>)->Void)?) {
        
        APICall.webRequest(apiType: .GET, endPoint: .getTerms, param: nil, forceDecoding: true, decodableObj: TermsApiRequest.self, complection: {
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
    
    
    //MARK: - Get accept Terms Of Use Api
    static func getAcceptTermsApiCall( _ completion : ((Result<TermsApiRequest>)->Void)?) {
        
        APICall.webRequest(apiType: .GET, endPoint: .getAcceptTermsOfUse, param: nil, forceDecoding: true, decodableObj: TermsApiRequest.self, complection: {
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
        case errorCode, statusCode
        case globalSettings = "GlobalSettings"
    }
}

// MARK: - GlobalSetting
struct GlobalSettingData: Codable {
    let settingName, settingDescription, settingValue, displayName: String?
    let displayDescription: String?
    let soundBase64String: String?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case settingName = "SettingName"
        case settingDescription = "SettingDescription"
        case settingValue = "SettingValue"
        case displayName = "DisplayName"
        case displayDescription = "DisplayDescription"
        case soundBase64String = "SoundBase64String"
        case message = "Message"
    }
}
