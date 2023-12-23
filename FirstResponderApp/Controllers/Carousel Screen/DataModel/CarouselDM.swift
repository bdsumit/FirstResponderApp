//
//  CarouselDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 21/11/22.
//

import Foundation
// MARK: - CarouselApiRequest
struct CarouselApiRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let carouselSetting: [CarouselSettingData]?
    
    
    //MARK: - api method
    static func getCarouselApiCall( _ completion : ((Result<CarouselApiRequest>)->Void)?) {
        
        APICall.webRequest(apiType: .GET, endPoint: .carouselSetting, param: nil, forceDecoding: true, decodableObj: CarouselApiRequest.self, complection: {
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
        case carouselSetting = "CarouselSetting"
    }
}

// MARK: - CarouselSetting
struct CarouselSettingData: Codable {
    let id, pageSequence: Int?
    let headerText, descriptionText, pageLogo: String?
    let message: String?
  //  let base64String: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case pageSequence = "PageSequence"
        case headerText = "HeaderText"
        case descriptionText = "DescriptionText"
        case pageLogo = "PageLogo"
        case message = "Message"
      //  case base64String = "Base64String"
    }
}
