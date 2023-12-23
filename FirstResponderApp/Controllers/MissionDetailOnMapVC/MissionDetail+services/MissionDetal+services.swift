//
//  MissionDetal+services.swift
//  FirstResponderApp
//
//  Created by bd05 on 1/3/23.
//

import Foundation
import UIKit
extension MissionDetailOnMapVC{
//MARK:-> UPDATE CASE API ON ARTRIVED BUTTON CLICKED
    func UpdateCaseApi(alarmId : Int  ){
        
        let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
        Loader.showLoader(self.view)
        CaseUpdateRequest.CaseUpdateApiCall(param: CaseUpdateParam(UserId: userId, AlarmId: alarmId, AlarmStatus: "Arrived"), { response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    let date = Date()
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: date)
                    let minutes = calendar.component(.minute, from: date)
                    let arrivedAt = SetUpAppLanguage.shareInstance.AppLanguageData?.arrived ?? ""
                    self.arriveLbl.text =  "\(arrivedAt) \(hour):\(minutes)"
                   
                    print("Update  case Api Success!")
                    self.showToast(message: res.message ?? "")
                }else{
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
    
    
//MARK:-> CLOSE ALARAM API ON MISSION COMPLETE BUTTON CLICKED
        func CloseMissionApi(alarmId : Int  ){
            
            let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
            Loader.showLoader(self.view)
            CloseAlaramRequest.CloseAlarmApiCall(param: CloseAlarmParam(UserId: userId, AlarmId: alarmId), { response in
                Loader.hideLoader(self.view)
                switch response {
                case .Success(let res) :
                    if res.statusCode == 200 && res.errorCode == 0{
                        print("CLOSE ALARAM API Success!")
                        
                        let vc = SuccessCancelMissionVC(nibName: "SuccessCancelMissionVC", bundle: nil)
                        vc.IsFromSuccess = true
                        vc.doneBtnDidTapped = {[weak self] in
                            guard let self = self else {return}
                            
                            let vc = FeedbackVC(nibName: "FeedbackVC", bundle: nil)
                            vc.fromFeedback = "CompleteAlarmFeedback"
                            vc.idAlarmFromAccRejComp = alarmId
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        self.navigationController?.pushViewController(vc, animated: true)

                    }else{
                        self.showToast(message: res.message ?? "")
                    }
                case .CustomError(let str) :
                    self.showToast(message: serverIssueMsg)
                }
            })
        }


    //MARK:-> CALL BACK API ON  BUTTON CLICKED CALLBACK
        func CallBackApi(alarmId : Int){
            
            let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
            Loader.showLoader(self.view)
            CallBackRequest.CallBackApiCall(param: CallBackParam(UserId: userId, AlarmId: alarmId ), { response in
                Loader.hideLoader(self.view)
                switch response {
                case .Success(let res) :
                    if res.statusCode == 200 && res.errorCode == 0{
                        print("CALL BACK API Success!")
                        self.showToast(message: res.message ?? "")
                    }else{
                        self.showToast(message: res.message ?? "")
                    }
                case .CustomError(let str) :
                    self.showToast(message: serverIssueMsg)
                }
            })
        }
    //MARK:-> UPLOAD CASE IMAGE  API ON CAMERA  BUTTON CLICKED
    func UploadCaseImageAPI(alarmId : Int) {
        
        let imgData = ClickedImage.image?.jpegData(compressionQuality: 0.1) ??  Data()
        var imageBody : [String: Data] = [:]
          imageBody = ["Image": imgData]
        
        Loader.showLoader(self.view)
        let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
        let param = ["UserId" : "\(userId)",
                     "AlarmId" : "\(alarmId)",
                     "CreatedBy" : "\(userId)" ] as [String: AnyObject]
        UploadCaseImageRequest.UploadCaseImageApiCall(param: param, image: imageBody,{
            response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                     print(" UPLOAD CASE IMAGE  API  Succesfull")
                    self.showToast(message: res.errorMessage ?? "")
                    }
                    else{
                        self.showToast(message: res.errorMessage ?? "")
                    }
                
            case .CustomError(let str) :
                print(str)
                self.showToast(message: serverIssueMsg)
       
            }
        })
    }
    
    
//MARK:-> EQUIPMENT PICKED API
    func EquipmentPicked(alarmId : Int , EquipmentId : Int){
            
            let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
            Loader.showLoader(self.view)
            EquipmentPickedRquest.EquipmenPickedApiCall(param: EquipmentPickedParam(UserId: userId, AlarmId: alarmId, EquipmentID: EquipmentId), { response in
                Loader.hideLoader(self.view)
                switch response {
                case .Success(let res) :
                    if res.statusCode == 200 && res.errorCode == 0{
                        print("EQUIPMENT PICKED API Success!")
                        // GetUserAlarmList Api Call
                           BaseClassHelper.sharedInstance.GetUserAlarmListApi(self,{ UseralarmlistData , EquipmentDetail in
                               self.equipmentBgView.isHidden = true
                               self.customMapViewAcc.equipmentfoundProcced(userAlrmList: UseralarmlistData, EquipmentData: EquipmentDetail)
                               self.setUpMapFunctionality(UseralarmlistData : UseralarmlistData , EquipmentListData : EquipmentDetail)
//                               self.setUpDesign(UseralarmlistData : UseralarmlistData, EquipmentListData: EquipmentDetail)
                           })
                    }else{
                        self.showToast(message: res.message ?? "")
                    }
                case .CustomError(let str) :
                    self.showToast(message: serverIssueMsg)
                }
            })
        }
    
//MARK:-> EQUIPMENT NoT FOUND  API
    func EquipmentNotFound(alarmId : Int , EquipmentId : Int, missionId : String){
        
        let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
        Loader.showLoader(self.view)
        EquipmentNotFoundRequest.EquipmentNotFoundApiCall(param: EquipmentNotFoundParam(UserId: userId, AlarmId: alarmId, EquipmentID: EquipmentId), { response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("EQUIPMENT NOT FOUND Success!")
                    if res.equipmentPickupData == nil {
                        self.equipmentNotFoundFeature(alarmId : alarmId , missionId : missionId)
                    }else{
                        // GO TO ANOTHER DEFRIBATOR
                        self.viewWillAppearWork()
                    }
                }else{
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
    
    
    
//MARK:-> CHANGE ALARM STATUS when no equipment found
    func ChangeAlarmStatusApi(alarmId : Int){
            let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
            Loader.showLoader(self.view)
        ChangeAlarmStatusRequest.ChangeAlarmStatusApiCall(param: ChangeAlarmStatusParam(UserId: userId, AlarmId: alarmId), { response in
                Loader.hideLoader(self.view)
                switch response {
                case .Success(let res) :
                    if res.statusCode == 200 && res.errorCode == 0{
                        print("CHANGE ALARM STATUS API Success!")
                        BaseClassHelper.sharedInstance.GetUserAlarmListApi(self,{ UseralarmlistData, EquipmentDetail in
                            self.setUpDesign(UseralarmlistData : UseralarmlistData, EquipmentListData: EquipmentDetail)
                        })
                    }else{
                        self.showToast(message: res.message ?? "")
                    }
                case .CustomError(let str) :
                    self.showToast(message: serverIssueMsg)
                }
            })
        }
    
}
