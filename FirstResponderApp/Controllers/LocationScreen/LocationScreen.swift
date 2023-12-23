//
//  LocationScreen.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/17/22.
//

import UIKit

class LocationScreen: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var goBackLbl: UILabel!
    @IBOutlet weak var footerLbl: UILabel!
    @IBOutlet weak var headerBG: UIView!
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var sharePositionLbl: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var locationToggle: UISwitch!
    @IBOutlet weak var lattitudeLbl: UILabel!
    @IBOutlet weak var logitudeLbl: UILabel!
    @IBOutlet weak var latValue: UILabel!
    @IBOutlet weak var longValue: UILabel!
    @IBOutlet weak var showOnMapBtn: UIButton!
    @IBOutlet weak var alarmAlert: UILabel!
    @IBOutlet weak var latLongView: UIView!
    var userstatusdata : UserStatus?
    var getUserSettingData  : UserSettingDetail?
    let userId = UserPersonalDetail.fetchUserDetail()?.userID
 //   var position = Bool()
    var refreshData : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BaseClassHelper.sharedInstance.getUserStatusApi(self, {userStatusData in

            self.userstatusdata = userStatusData
            self.setUIData ()
            BaseClassHelper.sharedInstance.SaveCurrentLocationApi( lat:  Double(self.latValue.text ?? "") ?? 0.00 , longitud: Double(self.longValue.text ?? "") ?? 0.00)
            
            self.getUserSettingApi()
        })
        
        setUpUI()
        
    }
    
    func setUIData () {
        if userstatusdata?.status == "ONLINE"{
            locationToggle.isOn = true
            alertView.isHidden = true
            latLongView.isHidden = false
            showOnMapBtn.isHidden = false
        }else{
            locationToggle.isOn = false
            alertView.isHidden = false
            latLongView.isHidden = true
            showOnMapBtn.isHidden = true
        }
    }
    
    func setUpUI(){
        setUpLanguage()
        
        latValue.text = UserTempData.returnValue(.Latitude) as? String
        longValue.text = UserTempData.returnValue(.Longitude) as? String
        //Font colour
        goBackLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        footerLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        headerText.textColor = MyTheme.buttonwhiteBackGroundColor
        sharePositionLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        lattitudeLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        logitudeLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        latValue.textColor = MyTheme.buttonwhiteBackGroundColor
        longValue.textColor = MyTheme.buttonwhiteBackGroundColor
        alarmAlert.textColor = MyTheme.buttonwhiteBackGroundColor
        
        //Font SIze
        goBackLbl.font = MyTheme.myFontMedium(18)
        footerLbl.font = MyTheme.myFontRegular(15)
        headerText.font = MyTheme.myFontBold(24)
        
        sharePositionLbl.font = MyTheme.myFontMedium(18)
        lattitudeLbl.font = MyTheme.myFontSemiBold(21)
        logitudeLbl.font = MyTheme.myFontSemiBold(21)
        latValue.font = MyTheme.myFontSemiBold(21)
        longValue.font = MyTheme.myFontSemiBold(21)
        alarmAlert.font = MyTheme.myFontRegular(15)
        
        // back ground colour
        headerBG.backgroundColor = MyTheme.backGroundLightGrayColor
        mainView.backgroundColor = MyTheme.backGroundDarkGrayColor
        showOnMapBtn.backgroundColor = MyTheme.buttonBlackBackGroundColor
        sepratorView.backgroundColor = MyTheme.backGroundwhiteGrayColor
        alertView.backgroundColor = MyTheme.redColor
    
    }
    func setUpLanguage(){
        footerLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
        headerText.text = SetUpAppLanguage.shareInstance.AppLanguageData?.geoPosition
        sharePositionLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.geoPosition
        alarmAlert.text = SetUpAppLanguage.shareInstance.AppLanguageData?.offlinePositionStatusLabel
        lattitudeLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.latitudeTitle
        logitudeLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.latitudeTitle
        showOnMapBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.mapOpen, for: .normal)
        goBackLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.returnSettings
    }
    @IBAction func btnBack(_ sender: Any) {
        refreshData?()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func toggleBtn(_ sender: Any) {
        if locationToggle.isOn == true{
            alertView.isHidden = true
            latLongView.isHidden = false
            showOnMapBtn.isHidden = false
           
            //update setting api call
            var params = updateUserSettingsParams(UserId: self.userId, language: self.getUserSettingData?.language, muteNavigation: self.getUserSettingData?.muteNavigation, vibrate: self.getUserSettingData?.vibrate, position: true, alarmSound: self.getUserSettingData?.alarmSound, alarmFlash: self.getUserSettingData?.alarmFlash,showStatusSilentNoti: self.getUserSettingData?.showStatusSilentNotification)
            self.updateLocationSettingsApi(updateUserSettingsParams : params)
            
        }else{
            alertView.isHidden = false
            latLongView.isHidden = true
            showOnMapBtn.isHidden = true
            
            var params = updateUserSettingsParams(UserId: self.userId, language: self.getUserSettingData?.language, muteNavigation: self.getUserSettingData?.muteNavigation, vibrate: self.getUserSettingData?.vibrate, position: false, alarmSound: self.getUserSettingData?.alarmSound, alarmFlash: self.getUserSettingData?.alarmFlash,showStatusSilentNoti: self.getUserSettingData?.showStatusSilentNotification)
            self.updateLocationSettingsApi(updateUserSettingsParams : params)
        }
    }
    @IBAction func showMapBtn(_ sender: Any) {
        let vc = LatLongOnMapVC(nibName: "LatLongOnMapVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
