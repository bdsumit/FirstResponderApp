//
//  updateProfilePhotoDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 28/11/22.
//

import Foundation
struct uploadUserProfilePhotoParams: Codable {
    let userId:  Int?
    let Image: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
        case Image = "Image"
    }
}


// MARK: - uploadUserProfilePhotoReq
struct uploadUserProfilePhotoReq: Codable {
    let message, imageURL: String?
    let errorCode, statusCode: Int?
    
    //MARK: - api method
    static func uploadUserProfilePhotoApiCall(param : uploadUserProfilePhotoParams ,_ completion : ((Result<uploadUserProfilePhotoReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .uploadUserProfilePhoto, param: Param, forceDecoding: true, decodableObj: uploadUserProfilePhotoReq.self, complection: {
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
        case imageURL = "ImageURL"
        case errorCode, statusCode
    }
}
