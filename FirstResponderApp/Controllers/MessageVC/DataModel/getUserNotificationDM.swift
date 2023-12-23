//
//  getUserNotificationDM.swift
//  FirstResponderApp
//
//  Created by bd10 on 23/11/22.
//

import Foundation

struct getUserNotificationParams: Codable {
    let UserId:  Int?
    
    
    enum CodingKeys: String, CodingKey {
        case UserId = "UserId"
        
    }
}


// MARK: - getUserNotificatonReq
struct getUserNotificatonReq: Codable {
    let message: String?
    let userNotification: [UserNotification]?
    let errorCode, statusCode: Int?
    
    //MARK: - api method
    static func getUserNotificationApiCall(param : getUserNotificationParams ,_ completion : ((Result<getUserNotificatonReq>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .getUserNotification, param: Param, forceDecoding: true, decodableObj: getUserNotificatonReq.self, complection: {
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
        case userNotification = "UserNotification"
        case errorCode, statusCode
    }
}

// MARK: - UserNotification
struct UserNotification: Codable {
    let userID, notificationID: Int?
    let isRead: Bool?
    let header, picture, text, textColor: String?
    let fontType: String?
    let fontSize: String?
    let bold, underline, cursives: Bool?
    let typeID: Int?
    let message: String?
    let status: String?
    let createdDate: String?
    let categoryID: Int?
    let notificationCategory: String?

    enum CodingKeys: String, CodingKey {
        case userID = "UserId"
        case notificationID = "NotificationId"
        case isRead = "IsRead"
        case header = "Header"
        case picture = "Picture"
        case text = "Text"
        case textColor = "TextColor"
        case fontType = "FontType"
        case fontSize = "FontSize"
        case bold = "Bold"
        case underline = "Underline"
        case cursives = "Cursives"
        case typeID = "TypeId"
        case message = "Message"
        case status = "Status"
        case createdDate = "CreatedDate"
        case categoryID = "CategoryId"
        case notificationCategory = "NotificationCategory"
    }
}



//enum NotificationCategory: String, Codable {
//    case notificationCategoryEmergency = "NotificationCategoryEmergency"
//    case notificationCategoryNormal = "NotificationCategoryNormal"
//}

//enum Status: String, Codable {
//    case new = "New"
//    case updated = "Updated"
//}
