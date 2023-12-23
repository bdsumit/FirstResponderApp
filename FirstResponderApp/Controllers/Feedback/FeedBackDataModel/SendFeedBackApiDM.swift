//
//  SendFeedBackApiDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 1/5/23.
//

import Foundation


struct SendFeedbackParam: Encodable {
    var userID, questionID, feedbackTypeID: Int?
    var questionType: String?
    var answerID: [Int]?
    var answer: [String]?
    var alarmID: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "UserId"
        case questionID = "QuestionId"
        case feedbackTypeID = "FeedbackTypeId"
        case questionType = "QuestionType"
        case answerID = "AnswerId"
        case answer = "Answer"
        case alarmID = "AlarmId"
    }
}


// MARK: - Welcome
struct SendFeedBackRequest: Codable {
    let message: String?
    let errorCode, statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode
    }
    
    static func SendFeedBackApiCall(param : [SendFeedbackParam], _ completion : ((Result<SendFeedBackRequest>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        let alarmId = param[0].alarmID
       
        APICall.webRequest(apiType: .POST, endPoint: alarmId == 0 ? .addUserResponse : .sendFeedBack , param: Param, decodableObj: SendFeedBackRequest.self, complection: {
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
