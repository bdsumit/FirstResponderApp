//
//  BaseClassViewController.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/26/22.
//

import Foundation
import UIKit
import AVFAudio
import AVFoundation
import CoreLocation
import MediaPlayer
import AVKit
class BaseClassHelper {
    public static let sharedInstance = BaseClassHelper()
    var playerAv: AVPlayer?
    var player = AVAudioPlayer()
    var timer : Timer? = nil {
           willSet {
               timer?.invalidate()
           }
       }
  
    func flashInloop(isFlashInloop: Bool){
        if isFlashInloop == true{
            
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(flashLoop), userInfo: nil, repeats: true)
    }else{
        guard timer != nil else { return }
           timer?.invalidate()
           timer = nil
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = AVCaptureDevice.TorchMode.off
        }catch {
            print(error)
        }
    }
    }
    @objc func flashLoop() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()

                do {
                    if device.torchMode == .on {
                        device.torchMode = AVCaptureDevice.TorchMode.off
                    }
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }

   
    func soundPlay(soundType : String, inLoop: Bool) {
              do {
                  let file = Bundle.main.url(forResource: soundType, withExtension: "wav")!
                  player = try AVAudioPlayer(contentsOf: file)
                  if inLoop == true{
                      player.numberOfLoops = -1   //set -1 for infinite
                  }else{
                      player.numberOfLoops = 0
                  }
                  player.volume = 1
                  player.prepareToPlay()

                  try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                  try AVAudioSession.sharedInstance().setActive(true)

                  player.play()
              } catch _ {
                  print("catch")
              }
          }
   
        func setVolume(_ volume: Float) {
           let volumeView = MPVolumeView()
           let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

           DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
               slider?.value = volume
           }
       }
    
    func fadeOutSound(){
        
        player.stop()
    }
    func vibrateInLoop(isvibrate : Bool) {
         if isvibrate == true{
              timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
         }else{
             guard timer != nil else { return }
                timer?.invalidate()
                timer = nil
         }
    }
    @objc func fireTimer() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    func oneTimevibrate() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }

    func dialNumber(number : String) {

     if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
                // add error message here
       }
    }
    func getRelativeDistance(ourlat : Double,ourLong : Double,patientlat : Double,patientLong : Double) -> Double{
        
        let coordinate₀ = CLLocation(latitude: ourlat , longitude: ourLong)
        let coordinate₁ = CLLocation(latitude: patientlat, longitude: patientLong)
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)

       return distanceInMeters
    }
    
    func getCountryListApi(_ vcAccess : UIViewController,_ completion: @escaping ([CountryListPhoneCode]?) -> Void){
        CountryListDataModel.getCountryListApiCall({
            response in
            switch response {
            case .Success(let res) :
                if res.statusCode == 200{
                    completion(res.countryList)
                }else{
                    completion(nil)
                }
            case .CustomError(let errorMsg) :
                vcAccess.showToast(message: errorMsg)
            }
        })
    }

    
    func UpdateDeviceIdApi(_ vcAccess : UIViewController   ){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
        Loader.showLoader(vcAccess.view)
        UpdateDeviceIdRequest.UpdateDeviceIdCall(param:UpdateDeviceIdParam(UserId: userId, DeviceId: UserDefaults.standard.string(forKey: TDeviceToken) ?? "", LoginDevice: "IOS") ,{ response in
            Loader.hideLoader(vcAccess.view)
            switch response {
            case .Success(let res) :
                print(res.Message)
            case .CustomError(let str) :
                print(str)
            }
        })
    }
    
    func SaveCurrentLocationApi(lat : Double ,longitud : Double ){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
       
        saveUserCurrentLocationRequest.SaveCurrentLocationApiCall(param:SaveLocationParam(UserId: userId, PosLat: lat, PosLon: longitud) ,{ response in
    
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print(" Save Current LocationApi Success!")
                    
             
                }else{
                    print(" Save Current LocationApi Success!")
                  //  viewAccess.showToast(message: res.errorMessage ?? "")
                }
            case .CustomError(let str) :
                print(" Save Current LocationApi Success!")
               // viewAccess.showToast(message: serverIssueMsg)
            }
        })
    }
    
    
// MARK:- GET GLOBEL SETTING
    func GetGlobelSettingApi(_ vcAccess : UIViewController , _ complitionHandler : @escaping ([GlobalSetting]?)-> Void){
            Loader.showLoader(vcAccess.view)
            GetAllGlobelSetting.globelSettingApiCall({ response in
                Loader.hideLoader(vcAccess.view)
                switch response {
                case .Success(let res) :
                    if res.statusCode == 200 && res.errorCode == 0{
                        print("get globel setiing  Api Success!")
                        
                        for settingData in res.globalSettings ?? [] {
                            if settingData.settingName == "SupportEmailAddress"{
                                UserTempData.saveData(.GlobelSettingValue, settingData.settingValue ?? "")
                            }
                        }
                      complitionHandler(res.globalSettings)
                    }else{
                        
                        vcAccess.showToast(message: "")
                    }
                case .CustomError(let str) :
                    vcAccess.showToast(message: serverIssueMsg)
                }
            })
        }
    
// MARK :-  LOGOUT API
    func logoutApi(_ viewAccess : UIViewController){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID
        Loader.showLoader(viewAccess.view)
        LogoutReq.logoutApiCall(param:logoutParams(UserId: userId) ,{ response in
            Loader.hideLoader(viewAccess.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    UserPersonalDetail.clearData()
                    let vc = CarouselScreen(nibName: "CarouselScreen", bundle: nil)
                    viewAccess.navigationController?.pushViewController(vc, animated: true)
                }else{
                   
                    viewAccess.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                viewAccess.showToast(message: serverIssueMsg)
            }
        })
    }
    
    
    
// MARK :-  Sent Notification By Id Api
    func SendNotificationByIdApi(_ viewAccess : UIViewController , notificationId : String , _ complitionHandler : @escaping (NotificationDetail?) -> (Void)){
       
        Loader.showLoader(viewAccess.view)
        SentNotificationByIDRequest.sentNotiByIDApiCall(param:sentNotificationParam(NotificationId: Int(notificationId) ?? 0)  ,{ response in
            Loader.hideLoader(viewAccess.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Sent Notification By Id Api Success!")
                    complitionHandler(res.notificationDetail)
                }else{
                    viewAccess.showToast(message:"There is some error")
                }
            case .CustomError(let str) :
                viewAccess.showToast(message: serverIssueMsg)
            }
        })
    }
    
    
// READ NOTIFICATION API
    func ReadNotificationApi(_ ViewAccess : UIViewController,notificationId : Int, indexPath : Int, notificationData : NotificationDetail?){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
        Loader.showLoader(ViewAccess.view)

        ReadUserNotification.readUserNotiApiCall(param:ReadUserNotificationParam(UserId: userId, NotificationId: notificationId) ,{ response in
            Loader.hideLoader(ViewAccess.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Read Api Success!")
                    let vc = MessageDetailVC(nibName: "MessageDetailVC", bundle: nil)
                        vc.FromPushNotification = true
                        vc.notificationData = notificationData
                    ViewAccess.navigationController?.pushViewController(vc, animated: true)
                }else{
                    ViewAccess.showToast(message: res.errorMessage ?? "")
                }
            case .CustomError(let str) :
              
                ViewAccess.showToast(message: serverIssueMsg)
            }
        })
    }
    
    
// APP DEAD OR LIVE  API
    func AppAliveorDeadApi(_ ViewAccess : UIViewController,_ complitionHandler : @escaping (AppAliveorDead?) -> Void){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
        Loader.showLoader(ViewAccess.view)

        AppAliveOrDeadRequest.AppAliveOrDeadApiCall(param:appaliveordeadParam(UserId: userId) ,{ response in
            Loader.hideLoader(ViewAccess.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("App alive or dead Api Success!")
                    complitionHandler(res.appAliveorDead)
                }else{
                    ViewAccess.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                ViewAccess.showToast(message: serverIssueMsg)
            }
        })
    }
    
// MARK :- GET USER DETAIL API
    
    func getUserDetailsApi(_ ViewAccess : UIViewController,_ complitionHandler : @escaping (UserDetail?,[GlobalSetting]?,[AlarmDataVisibilityList]?) -> Void){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID
        Loader.showLoader(ViewAccess.view)
        getUserDetailsReq.getUserDetailsApiCall(param:getUserDetailsParams(userId: userId) ,{ response in
            Loader.hideLoader(ViewAccess.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    UserPersonalDetail.saveDetails(detail: res.userDetail!)
                    complitionHandler(res.userDetail , res.globalSettings ,res.alarmDataVisibilityList)
  
                }else{
                   
                    ViewAccess.showToast(message: res.userDetail?.message ?? "")
                }
            case .CustomError(let str) :
              
                ViewAccess.showToast(message: serverIssueMsg)
            }
        })
    }
    
    //MARK: - updateUserStatusApi
    func updateUserStatusApi(status: String ,_ ViewAccess : UIViewController,_ completioHandler : @escaping (Bool) -> Void ){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID
        Loader.showLoader(ViewAccess.view)
        updateUserStatusReq.updateUserStatusApiCall(param:updateUserStatusParams(userId: userId, Status: status) ,{ response in
            Loader.hideLoader(ViewAccess.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("update User Status Api Success!")
                    completioHandler(true)
//                    self.getUserStatusApi()
//                    self.getAvailabilityApi()
                   
                }else{
                
                    ViewAccess.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
              
                ViewAccess.showToast(message: serverIssueMsg)
            }
           
        })
    }
    
    
    //MARK: - get User Status Api
    func getUserStatusApi(_ ViewAccess : UIViewController , _ completionHandler : @escaping(UserStatus?) -> Void){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID
        Loader.showLoader(ViewAccess.view)
        getUserStatusReq.getUserStatusApiCall(param:getUserStatusParams(userId: userId) ,{ response in
            Loader.hideLoader(ViewAccess.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("get User Status Api Success!")
                    completionHandler(res.userStatus)
                }else{
                   
                    ViewAccess.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
            
                ViewAccess.showToast(message: serverIssueMsg)
            }
        })
    }
    
    
// MARK:- ACCEPT USER ALARM API
    func AcceptUserAlarmApi(_ ViewAccess : UIViewController,alarmData : AcceptAlarmParam,_ completionHandler : @escaping(Bool) -> Void){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
        Loader.showLoader(ViewAccess.view)
        AcceptAlarmRequest.AcceptAlarmApiCall(param:AcceptAlarmParam(MissionId: alarmData.MissionId, Description: alarmData.Description, UserId: UserPersonalDetail.fetchUserDetail()?.userID ?? 0, AlarmId: alarmData.AlarmId, AlarmStatus: alarmData.AlarmStatus) ,{ response in
            Loader.hideLoader(ViewAccess.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print(" ACCEPT USER ALARM Api Success!")
                    completionHandler(true)
                }else{
                    ViewAccess.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                ViewAccess.showToast(message: serverIssueMsg)
                
            }
        })
    }
 
    
// MARK:- REJECT USER ALARM API
    func RejectUserAlarmApi(_ ViewAccess : UIViewController,alarmData : AcceptAlarmParam,_ completionHandler : @escaping(Bool,Int) -> Void){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
  //      Loader.showLoader(self.view)
        RejectAlarmRequest.RejectAlarmApiCall(param:AcceptAlarmParam(MissionId: alarmData.MissionId, Description: alarmData.Description, UserId: userId, AlarmId: alarmData.AlarmId, AlarmStatus: alarmData.AlarmStatus) ,{ response in
         //   Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print(" REJECT USER ALARM Api Success!")
                    completionHandler(true , alarmData.AlarmId)
                }else{
                    ViewAccess.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                ViewAccess.showToast(message: serverIssueMsg)
                
            }
        })
    }
// MARK :- GET ALARM BY GUID API CALL
    func GetAlarmByGuIdApi(alarmGuId : String,_ ViewAccess : UIViewController ,_ completionHandler : @escaping( AlarmDetail?) -> Void) {
    
            Loader.showLoader(ViewAccess.view)
            GetAlarmByGuIdRequest.alarmByGuIdApiCall(param: AlarmFetchUsingGuIdParam(AlarmGuId: alarmGuId, userId: UserPersonalDetail.fetchUserDetail()?.userID ?? 0) , { response in
                Loader.hideLoader(ViewAccess.view)
                switch response {
                case .Success(let res) :
                    if res.statusCode == 200 && res.errorCode == 0{
                        print("Fetch Alarm by Gu Id  Api Success!")
                        completionHandler(res.alarmDetail)
                    }else{
                        ViewAccess.showToast(message: res.message ?? "")
                    }
                case .CustomError(let str) :
                    ViewAccess.showToast(message: serverIssueMsg)
                }
            })
        }
    
    func GetUserAlarmListApi(_ vcAccess : UIViewController,_ completionHandler : @escaping ([AlarmDataList]?,EquipmentList?) -> Void){
        Loader.showLoader(vcAccess.view)
        GetUserAlarmListRequest.UserAlarmListApiCall(param: alarmUserParam(UserId: UserPersonalDetail.fetchUserDetail()?.userID ?? 0), { response in
            Loader.hideLoader(vcAccess.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("GET User Alarm List Api Success!")
                    completionHandler(res.alarmDataList, res.equipmentList)
                }else{
                    
                    vcAccess.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                vcAccess.showToast(message: serverIssueMsg)
            }
           
        })
    }
// GET USER SETTING API
    func getUserSettingApi(_ vcAccess : UIViewController,_ completionHandler : @escaping (UserSettingDetail?) -> Void){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID
        getUserSettingReq.getUserSettingApiCall(param:getUserSettingParams(userId: userId) ,{ response in
      //      Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    completionHandler(res.userSettingDetail)
                }else{
                    vcAccess.showToast(message: res.userSettingDetail?.message ?? "")
                }
            case .CustomError(let str) :
                vcAccess.showToast(message: serverIssueMsg)
            }
        })
    }
 // UPDATE USER SETTING API
    func updateUserSettingsApi(updateUserSettingsParams : updateUserSettingsParams,_ vcAccess : UIViewController,_ completionHandler : @escaping (Bool) -> Void){
        updateUserSettingReq.updateUserSettingApiCall(param: updateUserSettingsParams ,{ response in
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("update User Setting Api sucess")
                    completionHandler(true)
//                    BaseClassHelper.sharedInstance.getUserSettingApi(self, { userSettingDetaills in
//                        self.getUserSettingData = userSettingDetaills
//                        self.settingTableView.reloadData()
//                    })
                }else{
                    completionHandler(false)
                    vcAccess.showToast(message: res.errorMessage ?? "")
                }
            case .CustomError(let str) :
                vcAccess.showToast(message: serverIssueMsg)
            }
         
        })
    }
    
    
// MARK:- ABORT  ALARM By MOBILE API
    func AbortMissionAlarmApi(_ ViewAccess : UIViewController,missionId : String,_ completionHandler : @escaping(Bool) -> Void){
        let userId = UserPersonalDetail.fetchUserDetail()?.userID ?? 0
  //      Loader.showLoader(self.view)
        abortMisonFromMobileRequest.AbortAlarmApiCall(param:abortMisonFromMobileParam(UserId: userId, MissionId: missionId) ,{ response in
         //   Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print(" ABORT USER ALARM Api Success!")
                    completionHandler(true)
                }else{
                    ViewAccess.showToast(message: res.message ?? "")
                    completionHandler(false)
                }
            case .CustomError(let str) :
                ViewAccess.showToast(message: serverIssueMsg)
            }
        })
    }
}

