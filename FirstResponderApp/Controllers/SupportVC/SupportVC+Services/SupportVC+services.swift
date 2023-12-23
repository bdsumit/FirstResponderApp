//
//  SupportVC+services.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/28/22.
//

import Foundation
extension SupportVC{
    // MARk :- SENT SUPPORT API
        
        func SentSupportApi(){
            let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
            Loader.showLoader(self.view)

            SentSupportRequest.sentSupportApiCall(param: sentUpParam(Name: supportDetail.Name, EmailId: supportDetail.EmailId, Subject: supportDetail.Subject, Description: supportDetail.Description, SupportEmailId: supportDetail.SupportEmailId) ,{ response in
                Loader.hideLoader(self.view)
                switch response {
                case .Success(let res) :
                    if res.statusCode == 200 && res.errorCode == 0{
                        print("Sent support  Api Success!")
                        self.showToast(message: res.message ?? "")
                        self.navigationController?.popViewController(animated: true)
                    }else{
              
                        self.showToast(message: res.message ?? "")
                    }
                case .CustomError(let str) :
                    self.showToast(message: serverIssueMsg)
                }
            })
        }
    
    
    
// MARk :- GET Subject API
        
        func GetSubjectApi(){
           
            Loader.showLoader(self.view)
            GetSubjectDataModel.FetchAllSubjectApiCall({ response in
                Loader.hideLoader(self.view)
                switch response {
                case .Success(let res) :
                    if res.statusCode == 200 && res.errorCode == 0{
                        print(" GET Subject Api Success!")
                        self.subjectData = res.customSubjectList
                        self.SupportTable.reloadData()
                    }else{
                        self.showToast(message: res.message ?? "")
                    }
                case .CustomError(let str) :
                    self.showToast(message: serverIssueMsg)
                }
            })
        }
}

