import Foundation
import Firebase
import FirebaseMessaging
//import Fabric
//import Crashlytics
import UserNotifications

protocol IVFFirebaseService {
    func configureFirebase()
}

class VFFirebaseService: NSObject ,IVFFirebaseService{
    private let application = UIApplication.shared
    /*
     * Method name: configureFirebase
     * Description: Setting up the firebase.
     * Parameters: nil
     * Return: nil
     */
    internal func configureFirebase() {
        //register for push token
        requestPushAuthorization()
        
        //register firebase
        FirebaseApp.configure()
        
        //configure crashalytics
        //        Fabric.with([Crashlytics.self])
        
      //  Fabric.sharedSDK().debug = true
        //setup messaging delegate
        
        //set messaging delegate
        Messaging.messaging().delegate = self
        
        
    }
    
    /*
     * Method name: requestPushAuthorization
     * Description: request for Push Authorization
     * Parameters: nil
     * Return: nil
     */
    private func requestPushAuthorization() {
//        let content = UNMutableNotificationContent()
//        content.title = NSString.localizedUserNotificationString(forKey: "reminder!", arguments: nil)
//        content.body = NSString.localizedUserNotificationString(forKey: "Reminder body.", arguments: nil)
//        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "notification_sound.mp3"))
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
//       let identifier = "Reminder-\(Date())"
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        let center = UNUserNotificationCenter.current()
//        center.add(request, withCompletionHandler: { (error) in
//            if error != nil {
//                print("local notification created successfully.")
//            }
//        })
        
        application.applicationIconBadgeNumber = 0
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.sound, .alert, .badge]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        }else{
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
}
//firebase messaging delegate methods
extension VFFirebaseService : MessagingDelegate {
    //this method called when user recieved device token
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(fcmToken ?? "")
        UserDefaults.standard.set(fcmToken, forKey: TDeviceToken)
        UserDefaults.standard.synchronize()
      
    }
    
    /*func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
     }*/
}
//UNUser Notification Center Delegate method
extension VFFirebaseService : UNUserNotificationCenterDelegate {
    //This method called when push arrived in forground mode and its displaying to user
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //-------GET NOTIFICATION DATA---------//
        let userInfo = notification.request.content.userInfo as! [String:Any]
        print(userInfo)
     
        //-------REFRESH ORDER STATUS AUTOMETIC---------//
        let notType = userInfo["type"] as? String ?? ""

        if (userInfo["click_action"] as? String) == "profile"{
            NotificationCenter.default.post(name: Notification.Name("GetUserDetalApi"), object: nil, userInfo: nil)
        }else if userInfo["notification"] as? String == "logout"{
           // Api call Logout
            if let latestVc = UIApplication.topViewController(){
                BaseClassHelper.sharedInstance.logoutApi(latestVc)
            }
        }else if userInfo["notification"] as? String == "delete"{
            // Api call Logout
             if let latestVc = UIApplication.topViewController(){
                 BaseClassHelper.sharedInstance.logoutApi(latestVc)
             }
        }else if userInfo["notification"] as? String == "online"{
            // Update user Status Api Call
            NotificationCenter.default.post(name: Notification.Name("ONLINE"), object: nil, userInfo: nil)
        }else if userInfo["notification"] as? String == "Offline"{
            // Update user Status Api Call
           NotificationCenter.default.post(name: Notification.Name("OFFLINE"), object: nil, userInfo: nil)
            
        }else if userInfo["notification"] as? String == "faq"{
             // faq Api call
             NotificationCenter.default.post(name: Notification.Name("faqApiCall"), object: nil, userInfo: nil)
         }else if userInfo["notification"] as? String == "syncsound"{
             // Globel setting api call
//             if let latestVc = UIApplication.topViewController(){
//                 BaseClassHelper.sharedInstance.GetGlobelSettingApi(latestVc, { globlesettingData in
//                     for globeldata in globlesettingData  ?? []{
//                         if globeldata.settingName == "AbortSound"{
//                             let settingValue = globeldata.settingValue ?? ""
//                             let AbortSound = SoundbaseUrl + settingValue
//                             UserTempData.saveData(.abortSound, AbortSound)
//                         }
//                         if globeldata.settingName == "EmergencyNotification"{
//                             let settingValue = globeldata.settingValue ?? ""
//                             let emergencySound = SoundbaseUrl + settingValue
//                             UserTempData.saveData(.emergencySound, emergencySound)
//                         }
//                         if globeldata.settingName == "NewAlarmSound"{
//                             let settingValue = globeldata.settingValue ?? ""
//                             let newAlarmSound = SoundbaseUrl + settingValue
//                             UserTempData.saveData(.newAlarmSound, newAlarmSound)
//                         }
//                         if globeldata.settingName == "NormalNotification"{
//                             let settingValue = globeldata.settingValue ?? ""
//                             let normalBrodCstSound = SoundbaseUrl + settingValue
//                             UserTempData.saveData(.normalBrodcastSound, normalBrodCstSound)
//                         }
//                         if globeldata.settingName == "UpdateAlarmSound"{
//
//                             let settingValue = globeldata.settingValue ?? ""
//                             let UpdateAlarmSound = SoundbaseUrl + settingValue
//                             UserTempData.saveData(.updateAlarmSound, UpdateAlarmSound)
//                         }
//                         if globeldata.settingName == "CompressionAudio"{
//
//                             let settingValue = globeldata.settingValue ?? ""
//                             let CompressionSound = SoundbaseUrl + settingValue
//                             UserTempData.saveData(.compressionSound, CompressionSound)
//                         }
//                     }
//                 })
//             }
         }else if userInfo["notification"] as? String == "broadcast"{
         
             BaseClassHelper.sharedInstance.setVolume(Float(fullSound))
             BaseClassHelper.sharedInstance.oneTimevibrate()
             
             BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: true)
             let deadlineTime = DispatchTime.now() + .seconds(1)
             
             DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                 BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: false)
             }
            
           //  BaseClassHelper.sharedInstance.soundPlay(soundType: "EmergencyNotification", inLoop: false)
            
             NotificationCenter.default.post(name: Notification.Name("broadcastDataReload"), object: nil, userInfo: nil)
         }else if userInfo["notification"] as? String == "UpdateAppAliveOrDead"{
                 if let latestVc = UIApplication.topViewController(){
                     BaseClassHelper.sharedInstance.AppAliveorDeadApi(latestVc , {appAliveOrDeadData in
                         if appAliveOrDeadData?.logoutFromApp == true {
                             BaseClassHelper.sharedInstance.logoutApi(latestVc)
                         }
                     })
                 }
             }else if userInfo["notification"] as? String == "syncsetting"{
                 NotificationCenter.default.post(name: Notification.Name("syncSetting"), object: nil, userInfo: nil)
                
        
             }else if userInfo["notification"] as? String == "alarm" && userInfo["AlarmType"] as? String == "New"{
                 if let latestVc = UIApplication.topViewController(){
                     if latestVc.isKind(of: AlarmNotificationVC.self) {
                         return
                     }
                     if latestVc.isKind(of: MissionDetailOnMapVC.self) {
                         return
                     }
                     if latestVc.isKind(of: DetailMissionVC.self) {
                         return
                     }
                 }
                 if UserTempData.returnValue(.vibration) != nil  && UserTempData.returnValue(.isflashOn) != nil{
                     if UserTempData.returnValue(.vibration) as? String == "true" {
                         BaseClassHelper.sharedInstance.vibrateInLoop(isvibrate: true)
                     }
                     if UserTempData.returnValue(.isflashOn) as? String == "true" {
                         BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: true)
                     }
               
                        
                   
                 }else {
                     BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: true)
                     let seconds = 1.0
                     DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                         BaseClassHelper.sharedInstance.vibrateInLoop(isvibrate: true)
                     }
                    
                 }
                 
                 BaseClassHelper.sharedInstance.setVolume(Float(fullSound))
                 BaseClassHelper.sharedInstance.soundPlay(soundType: "NewAlarmSound", inLoop: true)
                 if let latestVc = UIApplication.topViewController(){
                     BaseClassHelper.sharedInstance.GetUserAlarmListApi(latestVc, {UserAlarmListData , EquipmentList in
                         let vc = AlarmNotificationVC(nibName: "AlarmNotificationVC", bundle: nil)
                         vc.AlarmListdata = UserAlarmListData
                         vc.BtnDidClicked =  {[weak self] (acceptOrReject, alarmData,viewContAccess) in
                             guard let self = self else {return}
                            if acceptOrReject == "Accept" {
                                BaseClassHelper.sharedInstance.fadeOutSound()
                                BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: false)
                                BaseClassHelper.sharedInstance.vibrateInLoop(isvibrate: false)
                                
                                 BaseClassHelper.sharedInstance.AcceptUserAlarmApi(viewContAccess,alarmData: alarmData, {successData in
                                     if successData == true{
                                         let vc = MissionDetailOnMapVC(nibName: "MissionDetailOnMapVC", bundle: nil)
                                         latestVc.navigationController?.pushViewController(vc, animated: true)
                                     }
                                 })
                            }else{
                                BaseClassHelper.sharedInstance.fadeOutSound()
                                BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: false)
                                BaseClassHelper.sharedInstance.vibrateInLoop(isvibrate: false)
                                
                                BaseClassHelper.sharedInstance.RejectUserAlarmApi(viewContAccess, alarmData: alarmData,{successData , alarmId in
                                    let vc = FeedbackVC(nibName: "FeedbackVC", bundle: nil)
                                    vc.fromFeedback = "RejectFeedback"
                                    vc.idAlarmFromAccRejComp = alarmId
                                    latestVc.navigationController?.pushViewController(vc, animated: true)
                                })
                            }
                         }
                         latestVc.navigationController?.pushViewController(vc, animated: true)
                      //   latestVc.present(vc, animated: true)
                            })
                 }
             }else if userInfo["notification"] as? String == "alarm" && userInfo["AlarmType"] as? String == "Abort"{
                 
                 if UserTempData.returnValue(.vibration) != nil  && UserTempData.returnValue(.isflashOn) != nil{
                    
                     if UserTempData.returnValue(.isflashOn) as! String == "true" {
                         BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: true)
                     }
                     if UserTempData.returnValue(.vibration) as! String == "true" {
                         let seconds = 1.0
                         DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                             BaseClassHelper.sharedInstance.vibrateInLoop(isvibrate: true)
                         }
                     }
                        
                 
                 }else {
                     BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: true)
                     let seconds = 1.0
                     DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                         BaseClassHelper.sharedInstance.vibrateInLoop(isvibrate: true)
                     }
                    
                 }
                 BaseClassHelper.sharedInstance.setVolume(Float(fullSound))
                 BaseClassHelper.sharedInstance.soundPlay(soundType: "AbortSound", inLoop: true)
                 if let latestVc = UIApplication.topViewController(){
                     BaseClassHelper.sharedInstance.GetAlarmByGuIdApi(alarmGuId: userInfo["AlarmGuId"] as! String, latestVc, {AlarmDetailFromGuid in
                         let vc = SuccessCancelMissionVC(nibName: "SuccessCancelMissionVC", bundle: nil)
                         vc.IsFromSuccess = false
                         vc.doneBtnDidTapped = {[weak self]  in
                             guard let self = self else {return}

                                 let vc = FeedbackVC(nibName: "FeedbackVC", bundle: nil)
                                 vc.fromFeedback = "RejectFeedback"
                             vc.idAlarmFromAccRejComp = AlarmDetailFromGuid?.alarmID ?? 0
                                 latestVc.navigationController?.pushViewController(vc, animated: true)
                         }
                         latestVc.navigationController?.pushViewController(vc, animated: true)
                     })

                 }
             }else if userInfo["notification"] as? String == "alarm" && userInfo["AlarmType"] as? String == "Update"{
                 NotificationCenter.default.post(name: Notification.Name("UpdateRoute"), object: nil, userInfo: nil)
                    
                     if UserTempData.returnValue(.vibration) != nil  || UserTempData.returnValue(.isflashOn) != nil{
                         if UserTempData.returnValue(.vibration) as! String == "true" {
                             BaseClassHelper.sharedInstance.vibrateInLoop(isvibrate: true)
                         }
                         if UserTempData.returnValue(.isflashOn) as! String == "true" {
                             BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: true)
                         }
                             
                       
                     }else {
                         BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: true)
                         let seconds = 1.0
                         DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                             BaseClassHelper.sharedInstance.vibrateInLoop(isvibrate: true)
                         }
                        
                     }
                 BaseClassHelper.sharedInstance.setVolume(Float(fullSound))
                 BaseClassHelper.sharedInstance.soundPlay(soundType: "UpdateAlarmSound", inLoop: true)
                 if let latestVc = UIApplication.topViewController(){
                     BaseClassHelper.sharedInstance.GetUserAlarmListApi(latestVc, {UserAlarmList , EquipmentListDetail in
                         let vc = UpdateAlarmPopUp(nibName: "UpdateAlarmPopUp", bundle: nil)
                         vc.AlarmListData = UserAlarmList
                         vc.btnReadMoreDidTapped = {[weak self]  in
                             guard let self = self else {return}

                             if UserAlarmList?[0].action == "GOTOPATIENT"{
                                 let vc =  DetailMissionVC(nibName: "DetailMissionVC", bundle: nil)
                                 vc.forPatientOrEquipment = "Patient"
                                 vc.EquipmentListData = EquipmentListDetail
                                  vc.UserALarmListData = UserAlarmList
                                 latestVc.navigationController?.pushViewController(vc, animated: true)
                             }else{
                                 let vc =  DetailMissionVC(nibName: "DetailMissionVC", bundle: nil)
                                 vc.forPatientOrEquipment = "Equipment"
                                 vc.EquipmentListData = EquipmentListDetail
                                  vc.UserALarmListData = UserAlarmList
                                 latestVc.navigationController?.pushViewController(vc, animated: true)
                             }
                         }
                           latestVc.present(vc, animated: true)
                     })

                 }
             }
        
//        if (userInfo["silent"]  as? String ?? "" ) == "true" {
//            return
//        }
        completionHandler([.alert, .badge, .sound])
         
        
    }
    //This method called user click on push
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //-------GET NOTIFICATION DATA---------//
        
        let userInfo = response.notification.request.content.userInfo as! [String:Any]
        print(userInfo)
        let notType = userInfo["type"] as? String ?? ""
        
        
         if userInfo["notification"] as? String == "broadcast"{
            let NotificationId = userInfo["NotificationId"] as? String ?? "0"
            if let latestVc = UIApplication.topViewController(){
                BaseClassHelper.sharedInstance.SendNotificationByIdApi(latestVc, notificationId: NotificationId, {notificationDetal in
                    if let latestVc = UIApplication.topViewController(){
                        BaseClassHelper.sharedInstance.ReadNotificationApi(latestVc, notificationId : notificationDetal?.notificationID ?? 0, indexPath: 0, notificationData: notificationDetal)
                    }
                })
            }
             
         }
        center.removeDeliveredNotifications(withIdentifiers: userInfo["notification"] as! [String])
//                if (userInfo["silent"]  as? String ?? "" ) == "true" {
//                    return
//                }
        completionHandler()
    }
}

