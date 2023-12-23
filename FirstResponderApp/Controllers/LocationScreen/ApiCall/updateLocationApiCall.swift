//
//  updateLocationApiCall.swift
//  FirstResponderApp
//
//  Created by bd10 on 25/11/22.
//

import Foundation
extension LocationScreen{
    func updateLocationSettingsApi(updateUserSettingsParams : updateUserSettingsParams){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID
        Loader.showLoader(self.view)
        updateUserSettingReq.updateUserSettingApiCall(param: updateUserSettingsParams ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api sucess")
                    
                    if updateUserSettingsParams.position == true{
                        BaseClassHelper.sharedInstance.updateUserStatusApi(status: "ONLINE", self, { successuserStatus in
                        })
                    }else{
                        BaseClassHelper.sharedInstance.updateUserStatusApi(status: "OFFLINE", self, { successuserStatus in
                        })
                    }
                    self.getUserSettingApi()
                
                }else{
                   
                    self.showToast(message: res.errorMessage ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
            
        })
    }
    
    func getUserSettingApi(){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID
        Loader.showLoader(self.view)
        getUserSettingReq.getUserSettingApiCall(param:getUserSettingParams(userId: userId) ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
               //     self.position = res.userSettingDetail?.position ?? false
                    self.getUserSettingData = res.userSettingDetail
                }else{
                    
                    self.showToast(message: res.userSettingDetail?.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
    
    
    //MARK: - updateUserStatusApi
//    func updateUserStatusApi(status: String){
//        let userId = UserPersonalDetail.fetchUserDetail()?.userID
//        Loader.showLoader(self.view)
//        updateUserStatusReq.updateUserStatusApiCall(param:updateUserStatusParams(userId: userId, Status: status) ,{ response in
//            Loader.hideLoader(self.view)
//            switch response {
//            case .Success(let res) :
//                if res.statusCode == 200 && res.errorCode == 0{
//                    print("Api Success!")
//
//                }else{
//
//                    self.showToast(message: res.message ?? "")
//                }
//            case .CustomError(let str) :
//                self.onShowAlertController(title: "", message: serverIssueMsg)
//            }
//        })
//    }
}
