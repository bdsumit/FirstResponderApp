//
//  UploadCaseDetailDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 1/3/23.
//

import Foundation

struct UploadCaseImageRequest: Codable {
    let errorMessage: String?
    let errorCode, statusCode: Int?

    //MARK: - UPLOAD CASE IMAGE Api
    static func UploadCaseImageApiCall(param : [String: AnyObject],image : [String: Data],_ completion : ((Result<UploadCaseImageRequest>)->Void)?) {
       
        APICall.PostAPIWithImage(apiType: .POST, endPoint: .UploadCaseImage, strID: "", jsonString: param, forceDecoding: true, decodableObj: UploadCaseImageRequest.self,imageData: image, complection: {
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
