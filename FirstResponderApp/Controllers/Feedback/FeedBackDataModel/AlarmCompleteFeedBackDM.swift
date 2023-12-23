//
//  AlarmCompleteFeedBackDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 1/3/23.
//

import Foundation
// MARK: - Welcome
struct AlarmCompleteFeedBackRequest: Codable {
    let list: [FeedBackList]?
    let errorCode, statusCode: Int?
    
    
    static func AlarmCompletefeedbackApiCall( _ completion : ((Result<AlarmCompleteFeedBackRequest>)->Void)?) {
        
        APICall.webRequest(apiType: .GET, endPoint: .AllQuestionChoiceFeedBack , param: nil, decodableObj: AlarmCompleteFeedBackRequest.self, complection: {
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

