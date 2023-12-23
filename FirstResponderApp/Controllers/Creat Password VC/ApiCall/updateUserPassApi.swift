//
//  updateUserPassApi.swift
//  FirstResponderApp
//
//  Created by bd10 on 22/11/22.
//

import Foundation
extension CreatPasswordVC{
    
    //MARK: - update user password Api
    func updateUserPassApi(){
        Loader.showLoader(self.view)
        sentOneTimePassReq.updateUserPassApiCall(param:updateUserPassParams(userId: userId, password: confirmPass.text),{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.passwordResetSuccessfully ?? "")
                    let vc = LoginVC(nibName: "LoginVC", bundle: nil)
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
