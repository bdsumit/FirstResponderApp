//
//  GetFAQListDataModel.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/24/22.
//

import Foundation
struct GetFAQListRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let questionAnswerList: [QuestionAnswerList]?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode, questionAnswerList
    }
    static func FAQApiCall(_ completion : ((Result<GetFAQListRequest>)->Void)?) {
    
        
        APICall.webRequest(apiType: .GET, endPoint: .FaqList , param: nil, decodableObj: GetFAQListRequest.self, complection: {
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
    }}

// MARK: - QuestionAnswerList
struct QuestionAnswerList: Codable {
    let id: Int?
    let question, answer: String?
    let message: String?
    let pageSequence: Int?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case question = "Question"
        case answer = "Answer"
        case message = "Message"
        case pageSequence = "PageSequence"
    }
}
