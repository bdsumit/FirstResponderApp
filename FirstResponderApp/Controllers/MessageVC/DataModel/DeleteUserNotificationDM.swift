//
//  DeleteUserNotificationDM.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/28/22.
//

import Foundation
import UIKit

struct deleteUserParam :Encodable{
    var UserId : Int
    var NotificationId : Int
}

struct DeleteUserNotificationRequest: Codable {
    let message: String?
    let list: [DeletUserNotiList]?
    let errorCode, statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case list = "List"
        case errorCode, statusCode
    }
    
    
    //MARK: - Delete notification Api
    static func deleteUserNotiApiCall(param : deleteUserParam ,_ completion : ((Result<DeleteUserNotificationRequest>)->Void)?) {
        
        var Param = Data()
        do {
            Param = try JSONEncoder().encode(param)
        }
        catch (let error) {
            print(error.localizedDescription)
        }
        
        APICall.webRequest(apiType: .POST,endPoint: .deleteUserInfo, param: Param, forceDecoding: true, decodableObj: DeleteUserNotificationRequest.self, complection: {
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
struct DeletUserNotiList: Codable {
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
//
//enum FontType: String, Codable {
//    case arial = "Arial"
//    case empty = ""
//}
//
//enum NotificationCategory: String, Codable {
//    case notificationCategoryEmergency = "NotificationCategoryEmergency"
//    case notificationCategoryNormal = "NotificationCategoryNormal"
//}
//
//enum Status: String, Codable {
//    case new = "New"
//    case updated = "Updated"
