//
//  getAvailabilityApi.swift
//  FirstResponderApp
//
//  Created by bd10 on 26/11/22.
//

import Foundation
extension UserOnlineOfflineVC{
    func getAvailabilityApi(){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID
        Loader.showLoader(self.view)
        getAvailabilityReq.getAvailabilityApiCall(param:getAvailabilityParams(userId: userId) ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    self.getAvailabilityData = res.availableOpeningHours
                    var filteredData = self.getAvailabilityData?.filter{$0.startTime != "00:00" && $0.endTime != "00:00"}
                    self.filteredAvailabilityData = filteredData
                    //MARK: - getUserStatusAPI
                    self.getUserStatusApi()
                }else{
                   
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
    
    
    //MARK: - getUserStatusApi
    func getUserStatusApi(){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID
        Loader.showLoader(self.view)
        getUserStatusReq.getUserStatusApiCall(param:getUserStatusParams(userId: userId) ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    self.isOnline = res.userStatus?.status ?? ""
                    
                    if self.isOnline == "ONLINE"{
                        self.onlineOfflineLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.online
                        self.onlineOfflineView.backgroundColor = MyTheme.greenColor // green
                    }else{
                        self.onlineOfflineLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.offline
                        self.onlineOfflineView.backgroundColor = MyTheme.yelloColor // yellow
                        self.onlineOfflineLbl.textColor = MyTheme.buttonBlackBackGroundColor
                    }
                    
                    self.getUserStatusData = res.userStatus
                    self.userOnlineOfflineTable.reloadData()
                }else{
                   
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
    
   
    
    //MARK: - updateAvailabilityApi
    func updateAvailabilityApi(updateAvailabilityParams : [updateAvailabilityParams]){
        Loader.showLoader(self.view)
        updateAvailabilityReq.updateAvailabiltyApiCall(param:updateAvailabilityParams ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success")
                    self.getAvailabilityApi()
                }else{
                   
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
            //get availabilty api here
           // self.getAvailabilityOnAddYourScheduleApi()
        })
    }
    
    //MARK: - Set user status Api
    func SetUserStatusApi(startTime: String, endTime : String){
        let UserId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
        Loader.showLoader(self.view)
        SetUserStatusRequest.setUserStatusApiCall(param:setUserStatusParam(UserId: UserId, Offline: true, StartTime: startTime, endTime: endTime) ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Set user status Api Success")
                    self.userOnlineOfflineTable.reloadData()
                }else{
                    self.showToast(message: res.errorMessage ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
}
