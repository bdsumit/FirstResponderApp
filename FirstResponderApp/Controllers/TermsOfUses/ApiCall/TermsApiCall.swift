//
//  TermsApiCall.swift
//  FirstResponderApp
//
//  Created by bd10 on 21/11/22.
//

import Foundation
extension TermsOfUsesVC{
    func termsOfUseApi(){
        Loader.showLoader(self.view)
        TermsApiRequest.termsApiCall({
            response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 {
                    print("Api Success!")
                    self.TermsData = res.globalSettings
                    self.setUPApiData()
                }else{
                   
                    self.showToast(message: "Server Issue! Please Check")
                }
            case .CustomError(_) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
}
