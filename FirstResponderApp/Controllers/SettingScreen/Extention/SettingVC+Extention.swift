//
//  SettingVC+Extention.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/16/22.
//

import Foundation
import UIKit
import AVFAudio
extension SettingScreen : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as! SettingTableViewCell
        cell.settingTxt.text = SettingArray[indexPath.row]
        if indexPath.row == 2 ||  indexPath.row == 3 || indexPath.row == 4  ||  indexPath.row == 5 || indexPath.row == 6 {
            
            cell.sendSwitchBtnValue = {[weak self] (btnValue) in
                guard let self = self else{ return}
                var params = updateUserSettingsParams(UserId: self.userId, language: self.getUserSettingData?.language, muteNavigation: self.getUserSettingData?.muteNavigation, vibrate: self.getUserSettingData?.vibrate, position: self.getUserSettingData?.position, alarmSound: self.getUserSettingData?.alarmSound, alarmFlash: self.getUserSettingData?.alarmFlash,showStatusSilentNoti: self.getUserSettingData?.showStatusSilentNotification)
                
                switch indexPath.row {
                case 2:
                    
                    self.storeUserSettings.muteNavigation = btnValue
                    params = updateUserSettingsParams(UserId: self.userId, language: self.getUserSettingData?.language, muteNavigation: btnValue, vibrate: self.getUserSettingData?.vibrate, position: self.getUserSettingData?.position, alarmSound: self.getUserSettingData?.alarmSound, alarmFlash: self.getUserSettingData?.alarmFlash,showStatusSilentNoti: self.getUserSettingData?.showStatusSilentNotification)
                    
                    if btnValue == true {
                        UserTempData.saveData(.muteNavigation, "true")
                    }else{
                        UserTempData.saveData(.muteNavigation, "false")
                    }
                    
                case 3:
                   
                    self.storeUserSettings.vibrate = btnValue
                      params = updateUserSettingsParams(UserId: self.userId, language: self.getUserSettingData?.language, muteNavigation: self.getUserSettingData?.muteNavigation, vibrate: btnValue, position: self.getUserSettingData?.position, alarmSound: self.getUserSettingData?.alarmSound, alarmFlash: self.getUserSettingData?.alarmFlash,showStatusSilentNoti: self.getUserSettingData?.showStatusSilentNotification)
                    if btnValue == true {
                        UserTempData.saveData(.vibration, "true")
                       BaseClassHelper.sharedInstance.oneTimevibrate()
                       
                    }else{
                        UserTempData.saveData(.vibration, "false")
                        self.showToast(message: "Stop vibrating")
                    }
                case 4:
                    
                    self.storeUserSettings.alarmSound = btnValue
                      params = updateUserSettingsParams(UserId: self.userId, language: self.getUserSettingData?.language, muteNavigation: self.getUserSettingData?.muteNavigation, vibrate: self.getUserSettingData?.vibrate, position: self.getUserSettingData?.position, alarmSound: btnValue, alarmFlash: self.getUserSettingData?.alarmFlash,showStatusSilentNoti: self.getUserSettingData?.showStatusSilentNotification)
                    
                    if btnValue == true {
                        BaseClassHelper.sharedInstance.soundPlay(soundType: "NewAlarmSound", inLoop: false)
                        BaseClassHelper.sharedInstance.setVolume(Float(fullSound))
                      
                        UserTempData.saveData(.isalarmSoundOn, "true")
                    }else{
                        BaseClassHelper.sharedInstance.fadeOutSound()
                        self.showToast(message: "Stop alarm sound")
                        UserTempData.saveData(.isalarmSoundOn, "false")
                    }
                    
                case 5:
                    
                    self.storeUserSettings.alarmFlash = btnValue
                      params = updateUserSettingsParams(UserId: self.userId, language: self.getUserSettingData?.language, muteNavigation: self.getUserSettingData?.muteNavigation, vibrate: self.getUserSettingData?.vibrate, position: self.getUserSettingData?.position, alarmSound: self.getUserSettingData?.alarmSound, alarmFlash: btnValue,showStatusSilentNoti: self.getUserSettingData?.showStatusSilentNotification)
                    if btnValue == true {
                        BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: true)
                        let deadlineTime = DispatchTime.now() + .seconds(2)
                        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                            BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: false)
                        }
                        UserTempData.saveData(.isflashOn, "true")
                        
                    }else{
                        UserTempData.saveData(.isflashOn, "false")
                       
                    }
                case 6:
                   
                    self.storeUserSettings.showstatusSilent = btnValue
                      params = updateUserSettingsParams(UserId: self.userId, language: self.getUserSettingData?.language, muteNavigation: self.getUserSettingData?.muteNavigation, vibrate: self.getUserSettingData?.vibrate, position: self.getUserSettingData?.position, alarmSound: self.getUserSettingData?.alarmSound, alarmFlash: self.getUserSettingData?.alarmFlash,showStatusSilentNoti: btnValue)
                    
                    if btnValue == true {
                        UserTempData.saveData(.showNotification, "true")
                    }else{
                        UserTempData.saveData(.showNotification, "false")
                    }
                    
                default:
                    print("All ok")
                }
                BaseClassHelper.sharedInstance.updateUserSettingsApi(updateUserSettingsParams: params, self, {successUpdate in
                    if successUpdate == true{
                        BaseClassHelper.sharedInstance.getUserSettingApi(self, { userSettingDetaills in
                            self.getUserSettingData = userSettingDetaills
                            self.settingTableView.reloadData()
                        })
                    }
                })
            }
            
            cell.switchCase.tag = indexPath.row
            cell.getUserSettingData = self.getUserSettingData
            cell.checkBtnOnOff()
            
            cell.forwardBtn.isHidden = true
            cell.switchCase.isHidden = false
            
            
        }else{
            cell.forwardBtn.isHidden = false
            cell.switchCase.isHidden = true
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        BaseClassHelper.sharedInstance.fadeOutSound()  // for Stop Sound
        if indexPath.row == 0{
            
            BaseClassHelper.sharedInstance.getUserDetailsApi( self , {userDetails,globelSettingData, alarmVisibilityListData in
                
                let vc = ProfileSettingVC(nibName: "ProfileSettingVC", bundle: nil)
                vc.userDataFromApi = userDetails
                self.navigationController?.pushViewController(vc, animated: true)
                         
            })
            
        }else if indexPath.row == 1{
            let vc = UserOnlineOfflineVC(nibName: "UserOnlineOfflineVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else if indexPath.row == 9 {
            let vc = FeedbackVC(nibName: "FeedbackVC", bundle: nil)
            vc.fromFeedback = "ApplicationFeedback"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 10 {
            let vc = SupportVC(nibName: "SupportVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if indexPath.row == 7 {
            let vc = LocationScreen(nibName: "LocationScreen", bundle: nil)
            //refresh call back
            vc.refreshData = { [weak self] in
                guard let self = self else{ return}
                BaseClassHelper.sharedInstance.getUserSettingApi(self, { userSettingDetaills in
                    self.getUserSettingData = userSettingDetaills
                    self.settingTableView.reloadData()
                })
                }
          //  vc.position = getUserSettingData?.position ?? false
            vc.getUserSettingData = self.getUserSettingData
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 8 {
            let vc = LanguageScreen(nibName: "LanguageScreen", bundle: nil)
            vc.languageSelected = getUserSettingData?.language ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 11 {
            let vc = FAQVC(nibName: "FAQVC", bundle: nil)
          //  vc.isfromController = "FAQScreen"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 12 {
            let vc = TermsOfUsesVC(nibName: "TermsOfUsesVC", bundle: nil)
            vc.isfromController = "AboutScreen"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
