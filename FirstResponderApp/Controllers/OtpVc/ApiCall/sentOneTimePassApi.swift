//
//  sentOneTimePassApi.swift
//  FirstResponderApp
//
//  Created by bd10 on 22/11/22.
//

import Foundation
extension otpVc{
    
    //MARK: - sent one time password Api
    func sentOneTimePassApi(userId: Int,emailId: String?, phone: String?){
        
        Loader.showLoader(self.view)
        sentOneTimePassReq.sentOneTimePassApiCall(param:sentOneTimePassParams(userId: userId,emailId: emailId, phone: phone) ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.otpResendMsg  ?? "")
                }else{
                    self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.otpResendErrorMsg ?? "")
                  
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
    
    
    //MARK: - check one time password Api
    func checkOneTimePassApi(){
        Loader.showLoader(self.view)
        sentOneTimePassReq.checkOneTimePassApiCall(param:checkOneTimePassParams(userId: userId,otp: otpTextField.text) ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    let vc = CreatPasswordVC(nibName: "CreatPasswordVC", bundle: nil)
                    vc.userId = self.userId
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
