//
//  requestForgotPasswordAPi.swift
//  FirstResponderApp
//
//  Created by bd10 on 22/11/22.
//

import Foundation
extension EnterEmailScreen{
    func requestForgotPassApi(){
        
        Loader.showLoader(self.view)
        forgotPasswordReq.forgotPasswordApiCall(param:forgotPassParams(emailId: emailIDTxtField.text) ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    let vc = OtpOptionVC(nibName: "OtpOptionVC", bundle: nil)
                    vc.emailId = res.requestForgotPasswordDetail?.emailID  ?? ""
                    vc.mobileNo = res.requestForgotPasswordDetail?.phone ?? ""
                    vc.userID = res.requestForgotPasswordDetail?.userID ?? 0
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
               
                    self.showToast(message: res.errorMessage ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
}
