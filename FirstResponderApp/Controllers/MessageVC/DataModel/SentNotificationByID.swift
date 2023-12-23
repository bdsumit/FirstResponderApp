//
//  SentNotificationByID.swift
//  FirstResponderApp
//
//  Created by bd05 on 12/20/22.
//

import Foundation

// MARK: - Welcome
struct sentNotificationParam : Encodable{
    var NotificationId : Int
}
struct SentNotificationByIDRequest: Codable {
    let notificationDetail: NotificationDetail?
    let errorCode, statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case notificationDetail = "NotificationDetail"
        case errorCode, statusCode
    }
    
    //MARK: - Delete notification Api
    static func sentNotiByIDApiCall(param : sentNotificationParam ,_ completion : ((Result<SentNotificationByIDRequest>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .sentNotificationById, param: Param, forceDecoding: true, decodableObj: SentNotificationByIDRequest.self, complection: {
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

// MARK: - NotificationDetail
struct NotificationDetail: Codable {
    let typeID, notificationID: Int?
    let notificationType, header, picture, text: String?
    let status, textColor, fontType, fontSize: String?
    let bold, underline, cursives: String?
    let sendnow, send: Bool?
    let categoryID: Int?
    let notificationCategory, sendDate, sendDateNew, scheduledDate: String?
    let scheduledDateNew, createdDate, expiryDate: String?
    let createdBy: String?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case typeID = "TypeId"
        case notificationID = "NotificationId"
        case notificationType = "NotificationType"
        case header = "Header"
        case picture = "Picture"
        case text = "Text"
        case status = "Status"
        case textColor = "TextColor"
        case fontType = "FontType"
        case fontSize = "FontSize"
        case bold = "Bold"
        case underline = "Underline"
        case cursives = "Cursives"
        case sendnow = "Sendnow"
        case send = "Send"
        case categoryID = "CategoryId"
        case notificationCategory = "NotificationCategory"
        case sendDate = "SendDate"
        case sendDateNew = "SendDateNew"
        case scheduledDate = "ScheduledDate"
        case scheduledDateNew = "ScheduledDateNew"
        case createdDate = "CreatedDate"
        case expiryDate = "ExpiryDate"
        case createdBy = "CreatedBy"
        case message = "Message"
    }
}
