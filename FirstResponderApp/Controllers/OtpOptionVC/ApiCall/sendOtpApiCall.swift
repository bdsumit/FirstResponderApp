//
//  sendOtpApiCall.swift
//  FirstResponderApp
//
//  Created by bd10 on 22/11/22.
//

import Foundation
extension OtpOptionVC{
    //MARK: - sent one time password Api
    func sentOneTimePassApi(userId: Int,emailId: String?, phone: String?){
        
        Loader.showLoader(self.view)
        sentOneTimePassReq.sentOneTimePassApiCall(param:sentOneTimePassParams(userId: userId,emailId: emailId, phone: phone) ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    
                    print("Api Success!")
                    let vc = otpVc(nibName: "otpVc", bundle: nil)
                    vc.userId = userId
                    vc.isFormEmail = self.isFormEmail
                    vc.emailID = emailId ?? ""
                    vc.mobileNo = phone ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                  
                    self.showToast(message: res.message ?? "" )
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
}

