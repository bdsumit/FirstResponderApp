//
//  SettingScreen.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/16/22.
//

import UIKit
import AudioToolbox
import AVFoundation

class SettingScreen: UIViewController {
    
    @IBOutlet weak var goBackLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var settingLbl: UILabel!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var footerLbl: UILabel!
    var player: AVPlayer?
    var getUserSettingData  : UserSettingDetail?
    let userId = UserPersonalDetail.fetchUserDetail()?.userID
    
    var storeUserSettings = (userId : "",language : "", muteNavigation: false, vibrate: false, position : false, alarmSound : false, alarmFlash : false, showstatusSilent : false)

    var SettingArray : [String?] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        BaseClassHelper.sharedInstance.getUserSettingApi(self, { userSettingDetaills in
            self.getUserSettingData = userSettingDetaills
            self.settingTableView.reloadData()
        })
        setUpLanguage()
    }

    func setUpUI(){
        setUpLanguage()
        //Font colour
        goBackLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        footerLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        settingLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        //Font SIze
        goBackLbl.font = MyTheme.myFontMedium(18)
        footerLbl.font = MyTheme.myFontRegular(15)
        settingLbl.font = MyTheme.myFontBold(24)
        // back ground colour
        settingView.backgroundColor = MyTheme.backGroundLightGrayColor
        bgView.backgroundColor = MyTheme.backGroundDarkGrayColor
        logoutBtn.backgroundColor = MyTheme.redColor
    }
    func setUpLanguage(){
        
         SettingArray = [SetUpAppLanguage.shareInstance.AppLanguageData?.profileSettings ,  SetUpAppLanguage.shareInstance.AppLanguageData?.activeOnOff ,  SetUpAppLanguage.shareInstance.AppLanguageData?.muteNavigation ,  SetUpAppLanguage.shareInstance.AppLanguageData?.vibration ,  SetUpAppLanguage.shareInstance.AppLanguageData?.alarmSound, SetUpAppLanguage.shareInstance.AppLanguageData?.alarmFlash,  SetUpAppLanguage.shareInstance.AppLanguageData?.showStatusSilentNotification,  SetUpAppLanguage.shareInstance.AppLanguageData?.geoPosition,  SetUpAppLanguage.shareInstance.AppLanguageData?.language,
                     SetUpAppLanguage.shareInstance.AppLanguageData?.feedback ,
                     SetUpAppLanguage.shareInstance.AppLanguageData?.support,  SetUpAppLanguage.shareInstance.AppLanguageData?.faq,
                     SetUpAppLanguage.shareInstance.AppLanguageData?.about]
        
        
        self.goBackLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.returnSettings
        settingLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.settings
        logoutBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.logout, for: .normal)
        footerLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
        
        settingTableView.reloadData()
    }

    
    
    @IBAction func logOutBtn(_ sender: Any) {
        BaseClassHelper.sharedInstance.fadeOutSound()
        BaseClassHelper.sharedInstance.GetUserAlarmListApi(self, {Alarmdetail , EquipmentDetail in
            //MARK: - CHECK FOR ACTIVE ALARM AND Logout Api call
            if Alarmdetail?[0].alarmStatus == "Active Alarm" || Alarmdetail?[0].alarmStatus == "Arrived" ||  Alarmdetail?[0].alarmStatus == "Accept" ||  Alarmdetail?[0].alarmStatus == "Pending"  ||  Alarmdetail?[0].alarmStatus == "Equipment Picked"{
               let abortWithLogout = SetUpAppLanguage.shareInstance.AppLanguageData?.anActiveAlarmLogout
                let ok = SetUpAppLanguage.shareInstance.AppLanguageData?.ok
                let alertController = UIAlertController(title: "", message: abortWithLogout, preferredStyle: .alert)
                 // Create the actions
                let okAction = UIAlertAction(title: ok, style: UIAlertAction.Style.default) {
                     UIAlertAction in
                    // abort Api Call
                    BaseClassHelper.sharedInstance.AbortMissionAlarmApi(self, missionId: Alarmdetail?[0].missionID  ?? "", {abortSuccessfull in
                        BaseClassHelper.sharedInstance.logoutApi(self)
                    })
                   
                 }
                let cancel = SetUpAppLanguage.shareInstance.AppLanguageData?.cancel
                let cancelAction = UIAlertAction(title: cancel, style: UIAlertAction.Style.cancel) {
                     UIAlertAction in
                     NSLog("Cancel Pressed")
                 }

                 // Add the actions
                 alertController.addAction(okAction)
                 alertController.addAction(cancelAction)

                 // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }else{
                //MARK: - Logout Api call
                let areUSurelogout = SetUpAppLanguage.shareInstance.AppLanguageData?.areYouSureLogout
                let ok = SetUpAppLanguage.shareInstance.AppLanguageData?.ok
                let cancel = SetUpAppLanguage.shareInstance.AppLanguageData?.cancel
                let alertController = UIAlertController(title: "", message: areUSurelogout, preferredStyle: .alert)

                 // Create the actions
                let okAction = UIAlertAction(title: ok, style: UIAlertAction.Style.default) {
                     UIAlertAction in
                    BaseClassHelper.sharedInstance.logoutApi(self)
                 }
                let cancelAction = UIAlertAction(title: cancel, style: UIAlertAction.Style.cancel) {
                     UIAlertAction in
                     NSLog("Cancel Pressed")
                 }

                 // Add the actions
                 alertController.addAction(okAction)
                 alertController.addAction(cancelAction)

                 // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func btnBack(_ sender: Any) {
        BaseClassHelper.sharedInstance.fadeOutSound()
        self.navigationController?.popViewController(animated: true)
    }
    }


