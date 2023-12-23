//
//  selectLanguageApi.swift
//  FirstResponderApp
//
//  Created by bd10 on 24/11/22.
//

import Foundation
extension LanguageScreen{
//    func selectLanguageApi(language : String){
//        let userId = UserPersonalDetail.fetchUserDetail()?.userID
//        Loader.showLoader(self.view)
//        updateUserSettingReq.updateUserSettingApiCall(param:updateUserSettingsParams(UserId: userId, language: language, muteNavigation: false, vibrate: false, position: false, alarmSound: false, alarmFlash: false,showStatusSilentNoti: false) ,{ response in
//            Loader.hideLoader(self.view)
//            switch response {
//            case .Success(let res) :
//                if res.statusCode == 200 && res.errorCode == 0{
//                   
//                }else{
//                   
//                    self.showToast(message: res.errorMessage ?? "")
//                }
//            case .CustomError(let str) :
//                self.showToast(message: serverIssueMsg)
//            }
//        })
//    }
    
    
// MARK :- CHANGE LANGUAGE API
    func changeLanguageApi(language: String){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
      //  Loader.showLoader(self.view)
        UpdateLanguageRequest.changeLanguageCall(param: changeLanguageParam(UserId: userId, Language: language) ,{ response in
      //      Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("language change Api Success!")
                    
                    if language == "Swedish"{
                        self.swidishToggle.isOn = true
                        self.englishToggle.isOn = false
                        SetUpAppLanguage.shareInstance.setCurrentAppLanguage(languageType: .swidish)
                        UserTempData.saveData(.appCurrentLanguage, "Swedish")
                    }else{
                        self.swidishToggle.isOn = false
                        self.englishToggle.isOn = true
                        SetUpAppLanguage.shareInstance.setCurrentAppLanguage(languageType: .english)
                        UserTempData.saveData(.appCurrentLanguage, "English")
                    }
                    self.setUpUI()
                  
                }else{
                   
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
    
}
