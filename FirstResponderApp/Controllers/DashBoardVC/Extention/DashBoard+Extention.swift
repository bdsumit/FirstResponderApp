//
//  DashBoard+Extention.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/24/22.
//

import Foundation
extension DashBoardVC {
    
    func getUserNotificationApi(){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID
        Loader.showLoader(self.view)

        getUserNotificatonReq.getUserNotificationApiCall(param:getUserNotificationParams(UserId: userId) ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    
                    self.dashboadNotificationData = res.userNotification
                    
                    let dashboardGreen = self.dashboadNotificationData?.filter { $0.isRead == false && $0.status == "New" }
                    let dashboardOrange = self.dashboadNotificationData?.filter { $0.isRead == false && $0.status == "Updated" }
                    let dashboardGray = self.dashboadNotificationData?.filter { $0.isRead == true}
                    
                    self.dashboardGreenCount = dashboardGreen?.count ?? 0
                    self.dashboardOrangeCount = dashboardOrange?.count ?? 0
                    self.dashboardGrayCount = dashboardGray?.count ?? 0
                    
                    self.DashBoredTv.reloadData()
                }else{
                   
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
    

    
//        func getUserDetailsApi(){
//            let userId = UserPersonalDetail.fetchUserDetail()?.userID
//      //      Loader.showLoader(self.view)
//            getUserDetailsReq.getUserDetailsApiCall(param:getUserDetailsParams(userId: userId) ,{ response in
//             //   Loader.hideLoader(self.view)
//                switch response {
//                case .Success(let res) :
//                    if res.statusCode == 200 && res.errorCode == 0{
//                        print("Api Success!")
//                        self.userStatus = res.userDetail?.status ?? ""
//                        self.DashBoredTv.reloadData()
//                    }else{
//                        
//                        self.showToast(message: res.userDetail?.message ?? "")
//                    }
//                case .CustomError(let str) :
//                    self.onShowAlertController(title: "", message: serverIssueMsg)
//                }
//            })
//    }
    
    
   
    

    
}
