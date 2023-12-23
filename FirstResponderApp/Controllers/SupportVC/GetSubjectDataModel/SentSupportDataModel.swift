//
//  SentSupportDataModel.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/28/22.
//

import Foundation

struct sentUpParam : Encodable{
    var Name : String
    var EmailId : String
    var Subject : String
    var Description : String
    var SupportEmailId : String
}
// MARK: - Welcome
struct SentSupportRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode
    }
    
    //MARK: - Sent Support Api
    static func sentSupportApiCall(param : sentUpParam ,_ completion : ((Result<SentSupportRequest>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .sentSupport, param: Param, forceDecoding: true, decodableObj: SentSupportRequest.self, complection: {
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
