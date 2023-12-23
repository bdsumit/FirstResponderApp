//
//  getUserNotificationApi.swift
//  FirstResponderApp
//
//  Created by bd10 on 23/11/22.
//

import Foundation
extension MessageVC{
    func getUserNotificationApi(){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID
        Loader.showLoader(self.view)
//---------------change user id from 132 to userId --------------------------------//
        getUserNotificatonReq.getUserNotificationApiCall(param:getUserNotificationParams(UserId: userId) ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    self.userNotificationData = res.userNotification
                    self.normalNotification = self.userNotificationData?.filter { $0.categoryID == 1 }
                    self.emergencyNotification = self.userNotificationData?.filter { $0.categoryID == 2 }
                    //emergency message count
                    let emergencyGreen = self.emergencyNotification?.filter { $0.isRead == false && $0.status == "New" }
                    self.emergencyGreenCount = emergencyGreen?.count ?? 0
                    let emergencyOrange = self.emergencyNotification?.filter{ $0.isRead == false && $0.status == "Updated" }
                    self.emergencyOrangeCount = emergencyOrange?.count ?? 0
                    
                    //normal Message count
                    let normalGreen = self.normalNotification?.filter { $0.isRead == false && $0.status == "New" }
                    self.normalGreenCount = normalGreen?.count ?? 0
                    let normalOrange = self.normalNotification?.filter{ $0.isRead == false && $0.status == "Updated" }
                    self.normalOrangeCount = normalOrange?.count ?? 0
                    
                    
                    //setting emergency and normal message count in green and orange circle
                    self.emergencyUnreadLbl.text = String(self.emergencyGreenCount)
                    self.emergencyReadLbl.text = String(self.emergencyOrangeCount)
                    
                    self.normalUnreadLbl.text = String(self.normalGreenCount)
                    self.normalReadLbl.text = String(self.normalOrangeCount)
                    
                    self.messageTable.reloadData()
                }else{
                   
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
    
// MARk :- READ USER NOTIFICATION API
    
    func ReadNotificationApi(notificationId : Int, indexPath : Int){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
        Loader.showLoader(self.view)

        ReadUserNotification.readUserNotiApiCall(param:ReadUserNotificationParam(UserId: userId, NotificationId: notificationId) ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Read Api Success!")
                    let vc = MessageDetailVC(nibName: "MessageDetailVC", bundle: nil)
                    if self.buttunTag == 0{
                        vc.messageDetailsData = self.emergencyNotification?[indexPath]
                    }else{
                        vc.messageDetailsData = self.normalNotification?[indexPath]
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    
                    self.showToast(message: res.errorMessage ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
    
// MARk :- DELETE USER NOTIFICATION API
    func DeleteNotificationApi(notificationId : Int, indexPath : Int){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
        Loader.showLoader(self.view)

        DeleteUserNotificationRequest.deleteUserNotiApiCall(param:deleteUserParam(UserId: userId, NotificationId: notificationId),{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    self.getUserNotificationApi()
                    print("Delete user notification Api Success!")
                    
                }else{
                   
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
       
        })
    }
}
