//
//  ApplicationFeedbackDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 12/14/22.
//

import Foundation
struct ApplicationFeedbackRequest: Codable {
    let list: [FeedBackList]?
    let errorCode, statusCode: Int?
    
    static func ApplicationfeedbackApiCall( _ completion : ((Result<ApplicationFeedbackRequest>)->Void)?) {
        
        APICall.webRequest(apiType: .GET, endPoint: .applicationFeedBack , param: nil, decodableObj: ApplicationFeedbackRequest.self, complection: {
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

//// MARK: - List
//struct List: Codable {
//    let questionID: Int?
//    let mandatory, questionHidden: Bool?
//    let typeID: Int?
//    let questionType: QuestionType?
//    let questionText: String?
//    let answers: [Answer]?
//    let questionTypeEnglish: QuestionType?
//
//    enum CodingKeys: String, CodingKey {
//        case questionID = "QuestionId"
//        case mandatory = "Mandatory"
//        case questionHidden = "QuestionHidden"
//        case typeID = "TypeId"
//        case questionType = "QuestionType"
//        case questionText = "QuestionText"
//        case answers = "Answers"
//        case questionTypeEnglish = "QuestionTypeEnglish"
//    }
//}
//
//// MARK: - Answer
//struct Answer: Codable {
//    let answerID: Int?
//    let answerText: String?
//    let answerHidden: Bool?
//    let emojiID: Int?
//    let emojiImage: String?
//    let feedbackTypeID: Int?
//    let feedbackType: FeedbackType?
//
//    enum CodingKeys: String, CodingKey {
//        case answerID = "AnswerId"
//        case answerText = "AnswerText"
//        case answerHidden = "AnswerHidden"
//        case emojiID = "EmojiID"
//        case emojiImage = "EmojiImage"
//        case feedbackTypeID = "FeedbackTypeId"
//        case feedbackType = "FeedbackType"
//    }
//}
//
//enum FeedbackType: String, Codable {
//    case applicationFeedback = "ApplicationFeedback"
//}
//
//enum QuestionType: String, Codable {
//    case emoji = "Emoji"
//    case numberRating = "Number Rating"
//    case text = "Text"
//}
