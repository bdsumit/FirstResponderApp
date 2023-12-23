//
//  FeeedBackDataModel.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/24/22.
//

import Foundation

// MARK: - Welcome
struct FeedbackRequest: Codable {
    let list: [FeedBackList]?
    let errorCode, statusCode: Int?
    
    static func feedbackApiCall( _ completion : ((Result<FeedbackRequest>)->Void)?) {
        
        APICall.webRequest(apiType: .GET, endPoint: .feedBackQuesionChoice , param: nil, decodableObj: FeedbackRequest.self, complection: {
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

// MARK: - List
struct FeedBackList: Codable {
    let questionID: Int?
    let mandatory, questionHidden: Bool?
    let typeID: Int?
    let questionType, questionText: String?
    let answers: [Answer]?
    let questionTypeEnglish: String?

    enum CodingKeys: String, CodingKey {
        case questionID = "QuestionId"
        case mandatory = "Mandatory"
        case questionHidden = "QuestionHidden"
        case typeID = "TypeId"
        case questionType = "QuestionType"
        case questionText = "QuestionText"
        case answers = "Answers"
        case questionTypeEnglish = "QuestionTypeEnglish"
    }
}

// MARK: - Answer
struct Answer: Codable {
    let answerID: Int?
    let answerText: String?
    let answerHidden: Bool?
    let emojiID: Int?
    let emojiImage: String?
    let feedbackTypeID: Int?
    let feedbackType: String?

    enum CodingKeys: String, CodingKey {
        case answerID = "AnswerId"
        case answerText = "AnswerText"
        case answerHidden = "AnswerHidden"
        case emojiID = "EmojiID"
        case emojiImage = "EmojiImage"
        case feedbackTypeID = "FeedbackTypeId"
        case feedbackType = "FeedbackType"
    }
}
