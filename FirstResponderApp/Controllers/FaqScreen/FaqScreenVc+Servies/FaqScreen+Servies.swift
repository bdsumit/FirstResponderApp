//
//  FaqScreen+Servies.swift
//  Alecom
//
//  Created by bd01 on 21/11/22.
//

import Foundation
extension FAQVC{
    func FetchFaqListApi(){
        
        Loader.showLoader(self.view)
        GetFAQListRequest.FAQApiCall({ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    self.FaqData =  res.questionAnswerList
                    self.faqTable.reloadData()
                }else{
                   
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }    }

