//
//  RegisterDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 21/11/22.
//

import Foundation

struct registerParams: Codable {
    let emailId:  String?
    let firstName: String?
    let lastName : String?
    let alias : String?
    let password : String?
    let phone: String?
    let isDeleted: Bool?
    let isApproved: Bool?
    let deviceId:String?
    let certificateId : String?
    let macId: String?
    let workingPlace : String?
    let profession : String?
    let CPREducation : String?
    let countryCode : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case emailId = "EmailId"
        case firstName = "FirstName"
        case lastName = "LastName"
        case alias = "Alias"
        case password = "Password"
        case phone = "Phone"
        case isDeleted = "IsDeleted"
        case isApproved = "IsApproved"
        case deviceId = "DeviceId"
        case certificateId = "CertificateId"
        case macId = "MacId"
        case workingPlace = "WorkingPlace"
        case profession = "Proffession"
        case CPREducation = "CPREducation"
        case countryCode = "CountryCode"
        
    }
}



// MARK: - RegisterApiRequest
struct RegisterApiRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    
    
    //MARK: - register Api

    static func registerApiCall(param : registerParams ,_ completion : ((Result<RegisterApiRequest>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .registerUser, param: Param, forceDecoding: true, decodableObj: RegisterApiRequest.self, complection: {
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
        case message = "Message"
        case errorCode, statusCode
    }
}
