//
//  GetSubjectDataModel.swift
//  FirstResponderApp
//
//  Created by bd05 on 12/8/22.
//

import Foundation
struct GetSubjectDataModel: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let customSubjectList: [CustomSubjectList]?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode, customSubjectList
    }
    
    
    //MARK: - Get Api
    static func FetchAllSubjectApiCall(_ completion : ((Result<GetSubjectDataModel>)->Void)?) {
        
        APICall.webRequest(apiType: .GET,endPoint: .getSubject, param: nil, forceDecoding: true, decodableObj: GetSubjectDataModel.self, complection: {
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

// MARK: - CustomSubjectList
struct CustomSubjectList: Codable {
    let id: Int?
    let subject: String?
    let organizationID: Int?
    let organizationName: String?
    let message: String?
    let createdDate, updatedDate: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case subject = "Subject"
        case organizationID = "OrganizationId"
        case organizationName = "OrganizationName"
        case message = "Message"
        case createdDate = "CreatedDate"
        case updatedDate = "UpdatedDate"
    }
}
