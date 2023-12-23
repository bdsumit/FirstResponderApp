//
//  CheckRegistrationDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 12/10/22.
//

import Foundation

// MARK: - Check Registration
struct CheckRegistrationRequest: Codable {
    let message, errorMessage: String?
    let errorCode, statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorMessage, errorCode, statusCode
    }
    
    
    
    //MARK: - Check Register Api

    static func CheckRegisterApiCall(param : registerParams ,_ completion : ((Result<CheckRegistrationRequest>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .checkRegistration, param: Param, forceDecoding: true, decodableObj: CheckRegistrationRequest.self, complection: {
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
