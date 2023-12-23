//
//  updateAvailabilityApi.swift
//  FirstResponderApp
//
//  Created by bd10 on 01/12/22.
//

import Foundation
//MARK: - updateAvailabilityApi : -
extension AddYourScheduleVC{
    func updateAvailabilityApi(updateAvailabilityParams : [updateAvailabilityParams]){
        Loader.showLoader(self.view)
        updateAvailabilityReq.updateAvailabiltyApiCall(param:updateAvailabilityParams ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    self.sendSaveBtnValues?(self.updateAvailabilityValues)
                    self.dismiss(animated: true)
                }else{
                
                    self.showToast(message: res.message ?? "" )
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }

}
