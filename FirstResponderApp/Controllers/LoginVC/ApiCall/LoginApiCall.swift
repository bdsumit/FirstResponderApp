//
//  LoginApiCall.swift
//  FirstResponderApp
//
//  Created by bd10 on 21/11/22.
//

import Foundation
import UIKit

extension LoginVC{
    func loginApi(){
       let uniqID = UIDevice.current.identifierForVendor?.uuidString
        Loader.showLoader(self.view)
        LoginApiRequest.loginApiCall(param:loginParams(emailId: self.email.text, password: self.passwordText.text, macId: uniqID,DeviceId: UserDefaults.standard.string(forKey: TDeviceToken)) ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    if res.userDetail != nil{
                        UserPersonalDetail.saveDetails(detail: res.userDetail!)
                        
                        if res.userDetail?.language == "Swedish"{
                            SetUpAppLanguage.shareInstance.setCurrentAppLanguage(languageType: .swidish)
                            UserTempData.saveData(.appCurrentLanguage, "Swedish")
                        }else{
                            SetUpAppLanguage.shareInstance.setCurrentAppLanguage(languageType: .english)
                            UserTempData.saveData(.appCurrentLanguage, "English")
                        }
                        
                        
                        
                        
                    }
                    BaseClassHelper.sharedInstance.updateUserStatusApi(status: "ONLINE", self, { successuserStatus in
                    })
                    
                    // MARK: - CHECK LOCATION PERMISSION
                  
                        if LocationManager.shared.isLocationServiceEnabled() == true {
                            let vc = DashBoardVC(nibName: "DashBoardVC", bundle: nil)
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            //You could show an alert like this.
                            let vc = PermissionScreen(nibName: "PermissionScreen", bundle: nil)
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    
                    
                   
                }else{
                   
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
}
