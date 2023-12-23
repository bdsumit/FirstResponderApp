//
//  UpdateLanguageDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 2/11/23.
//

import Foundation

struct changeLanguageParam: Encodable{
    var UserId: Int
    var Language: String
}
// MARK: - Welcome
struct UpdateLanguageRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode
    }
    
    //MARK: - change language Api  method
    static func changeLanguageCall(param : changeLanguageParam ,_ completion : ((Result<UpdateLanguageRequest>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .changeLanguage, param: Param, forceDecoding: true, decodableObj: UpdateLanguageRequest.self, complection: {
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
