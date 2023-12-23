//
//  FeedBackScreen+Services.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/24/22.
//

import Foundation
extension FeedbackVC{
    
// MARK :- REJECT FEEDBACK API CALL ON ABORT ALARM FROM WEB
    func RejectFeedBackListApi(){
        Loader.showLoader(self.view)
        FeedbackRequest.feedbackApiCall({ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("GET User Alarm List Api Success!")
                    self.FeedBackData = res.list
                    self.feedBackTv.reloadData()
                }else{
                    self.showToast(message: "there is some error")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
// MARK :- APPLICATION FEEDBACK API CALL WHEN COME FROM SETTING PAGE
    func ApplicationFeedBackApi(){
        Loader.showLoader(self.view)
        ApplicationFeedbackRequest.ApplicationfeedbackApiCall({ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("GET User Alarm List Api Success!")
                    self.FeedBackData = res.list
                    self.feedBackTv.reloadData()
                }else{
                   // self.onShowAlertController(title: "", message: res.message)
                    self.showToast(message:  "There is some error")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
    
// MARK :- GET ALL QUESTION CHOICE FEEDBACK API CALL WHEN USER COMPLETE HIS  MISSION
    func AlarmCompleteFeedBackApi(){
        Loader.showLoader(self.view)
        AlarmCompleteFeedBackRequest.AlarmCompletefeedbackApiCall({ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print(" Alarm Complete FEEDBACK Api Success!")
                    self.FeedBackData = res.list
                    self.feedBackTv.reloadData()
                }else{
                   // self.onShowAlertController(title: "", message: res.message)
                    self.showToast(message:  "There is some error")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
    
    
    
    
// MARK :- SEND FEEDBACK API CALL WHEN USER SEND BUTTON
    func SendFeedBackApi(){
        Loader.showLoader(self.view)
        SendFeedBackRequest.SendFeedBackApiCall(param: AddFeedbackArray, { response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print(" SEND FEEDBACK Api Success!")
                    self.showToast(message:res.message ?? "")
                    if self.fromFeedback == "ApplicationFeedback"{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: DashBoardVC.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    }
                   
                }else{
                    self.showToast(message:res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
}
