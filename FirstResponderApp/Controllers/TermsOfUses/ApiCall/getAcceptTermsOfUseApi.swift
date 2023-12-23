//
//  getAcceptTermsOfUseApi.swift
//  FirstResponderApp
//
//  Created by bd10 on 21/11/22.
//

import Foundation
extension TermsOfUsesVC{
    func getAcceptTermsOfUseApi(){
        Loader.showLoader(self.view)
        TermsApiRequest.getAcceptTermsApiCall({
            response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    self.RegisterUserClicked?()
                  
                }else{
                  
                    self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.serviceAPIError ??  "")
                }
            case .CustomError(_) :
                self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.serviceAPIError ??  "")
            }
        })
    }
}

