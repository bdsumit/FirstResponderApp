//
//  DashBoardVC.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/15/22.
//

import UIKit

class DashBoardVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet var langIcon: UIImageView!
    @IBOutlet weak var bdView: UIView!
    @IBOutlet weak var noActiveAlarmLbl: UILabel!
    @IBOutlet weak var DashBoredTv: UITableView!
    @IBOutlet weak var footerLbl: UILabel!
    var dashboadNotificationData : [UserNotification]?
    var userDataDetail : UserDetail?
    var userStatus = ""
    var dashboardGreenCount = 0
    var dashboardOrangeCount = 0
    var dashboardGrayCount = 0
    var alarmStatus = ""
    var userAlarmData : [AlarmDataList]?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.getUserLocation(completion: {_ in })
        setUpUI()
        BaseClassHelper.sharedInstance.UpdateDeviceIdApi(self
              
        )
        BaseClassHelper.sharedInstance.AppAliveorDeadApi(self, {appAliveOrDeadData in
            if appAliveOrDeadData?.logoutFromApp == true {
                BaseClassHelper.sharedInstance.logoutApi(self)
            }
        })
        let latitude = UserTempData.returnValue(.Latitude) as? String
        let longitude = UserTempData.returnValue(.Longitude) as? String
        BaseClassHelper.sharedInstance.SaveCurrentLocationApi(lat: Double(latitude ?? "") ?? 0.00  , longitud: Double(longitude ?? "") ?? 0.00)
        DashBoredTv.delegate = self
        DashBoredTv.dataSource = self
        DashBoredTv.register(UINib(nibName: "AlarmDashboardTvcell", bundle: nil), forCellReuseIdentifier: "AlarmDashboardTvcell")
        DashBoredTv.register(UINib(nibName: "DashboardTvCell", bundle: nil), forCellReuseIdentifier: "DashboardTvCell")
        DashBoredTv.register(UINib(nibName: "AbortAlarmTvCell", bundle: nil), forCellReuseIdentifier: "AbortAlarmTvCell")
        
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(updateBroadcastdata(_:)),name:NSNotification.Name ("broadcastDataReload"),object: nil)
        
    }
    @objc func updateBroadcastdata(_ notification: Notification){
        //MARK: - get user notification api to get count of messages
        self.getUserNotificationApi()
    }
   
    func setUpLanguage(){
        let currentLanguage = UserTempData.returnValue(.appCurrentLanguage) as? String
        if currentLanguage == "English"{
            langIcon.image = UIImage(named: "HeaderEnglish")
        }else{
            langIcon.image = UIImage(named: "HeaderIcon")
        }
        
        footerLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
        DashBoredTv.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpLanguage()
        ViewWillApprearApi()
        checkPermissionForLoction()
//   CHECKING LOCATION  AUTHENTICATION
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    func ViewWillApprearApi(){
        BaseClassHelper.sharedInstance.GetUserAlarmListApi(self, {UserAlarmListData ,EquipmentDetail in
            UserPersonalDetail.saveAlarmListDetails(detail: UserAlarmListData)
            UserPersonalDetail.saveEquipmentListDetails(detail: EquipmentDetail)
            
            BaseClassHelper.sharedInstance.GetGlobelSettingApi(self, {GlobelSetting in
               
                BaseClassHelper.sharedInstance.getUserDetailsApi(self, {userDetailData , globelSettingData , AlarmDataVisibilitiList in
                    self.userDataDetail = userDetailData
                    self.userStatus = userDetailData?.status ?? ""
                    UserPersonalDetail.saveAlarmVisibilityListDetails(detail: AlarmDataVisibilitiList ?? [])
                    self.DashBoredTv.reloadData()
                })
     
                    })
            
        })
        BaseClassHelper.sharedInstance.GetUserAlarmListApi(self,{ UserAlarmData ,EquipmentDetail in
            //MARK: - get user notification api to get count of messages
            self.getUserNotificationApi()
            self.userAlarmData = UserAlarmData
            if UserAlarmData?[0].alarmStatus == "Arrived" ||  UserAlarmData?[0].alarmStatus == "Accept" ||  UserAlarmData?[0].alarmStatus == "Pending"  ||  UserAlarmData?[0].alarmStatus == "Equipment Picked"{
                if UserAlarmData?[0].alarmStatus == "Pending"{
            
                              let vc = AlarmNotificationVC(nibName: "AlarmNotificationVC", bundle: nil)
                                vc.AlarmListdata = UserAlarmData
                              vc.BtnDidClicked =  {[weak self] (acceptOrReject, alarmData,vcAccess) in
                                  guard let self = self else {return}
                                 if acceptOrReject == "Accept" {
                                      BaseClassHelper.sharedInstance.AcceptUserAlarmApi(vcAccess,alarmData: alarmData, {successData in
                                          let vc = MissionDetailOnMapVC(nibName: "MissionDetailOnMapVC", bundle: nil)
                                          self.navigationController?.pushViewController(vc, animated: true)
                                        
                                      })
                                 }else{
                                     BaseClassHelper.sharedInstance.RejectUserAlarmApi(vcAccess, alarmData: alarmData,{successData,alarmId  in
                                         let vc = FeedbackVC(nibName: "FeedbackVC", bundle: nil)
                                         vc.fromFeedback = "RejectFeedback"
                                         vc.idAlarmFromAccRejComp = alarmId
                                         self.navigationController?.pushViewController(vc, animated: true)
                                     })
                                 }
                              }
                              self.navigationController?.pushViewController(vc, animated: true)
                          //    self.present(vc, animated: true)
                          
                    
                }else{
                    
                    self.alarmStatus = "Active Alarm"
                }
            }else{
              
                self.alarmStatus = "No Active"
            }
        })
    }
    
    
    func handelNotificationClick() {
          if let NotData =  UserDefaults.standard.dictionary(forKey: notificationDict){
              UserDefaults.standard.set(nil, forKey: notificationDict)
              let orderId = NotData["type"] as? String ?? ""
              let vc = MessageVC(nibName: "MessageVC", bundle: nil)            //  vc.orderId = orderId
              self.navigationController?.pushViewController(vc, animated: true)
          }
      }
    func setUpUI(){
        handelNotificationClick()
        noActiveAlarmLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        footerLbl.font = MyTheme.myFontRegular(18)
        noActiveAlarmLbl.font = MyTheme.myFontMedium(20)
        bdView.backgroundColor = MyTheme.backGroundDarkRedColor
        headerView.backgroundColor = MyTheme.backGroundLightGrayColor
       
    }
    // location
        @objc func appMovedToBackground() {
            checkPermissionForLoction()
            checkNotificationStatus()
        }
    func checkNotificationStatus() {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                switch settings.authorizationStatus {
                case  .denied, .provisional, .notDetermined:
                    let alert = UIAlertController(title: "Unable to use notifications",
                                                  message: "To enable notifications, go to Settings and enable notifications for this app.",
                                                  preferredStyle: UIAlertController.Style.alert)

                  //  let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                   // alert.addAction(okAction)

                    let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                        // Take the user to Settings app to possibly change permission.
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                // Finished opening URL
                            })
                        }
                    })
                    alert.addAction(settingsAction)
                    OperationQueue.main.addOperation {
                        
                        self.present(alert, animated: true,
                                     completion:nil)
                    }
                 // self.present(alert, animated: true)
                    print("Do something according to status")
                case .ephemeral:
                    
                    
                    
                    
                    print("ephemeral")
                case .authorized:
                    print("authorized")
               
                @unknown default:
                    print("defalut")
                }
            }
        }
        // MARK: - CHECK LOCATION PERMISSION
        func checkPermissionForLoction(){
            if LocationManager.shared.isLocationServiceEnabled() == true {
                
                // aap running perfactly without pop up 
            } else {
                //You could show an alert like this.
                let firstResponder = SetUpAppLanguage.shareInstance.AppLanguageData?.firstResponder
                let permissionToAlways = SetUpAppLanguage.shareInstance.AppLanguageData?.locationPermissionTitle ?? ""
                let openPermissionSetting = SetUpAppLanguage.shareInstance.AppLanguageData?.openPermissionSetting ?? ""
                let alertController = UIAlertController(title: firstResponder , message: "\(permissionToAlways)", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: openPermissionSetting, style: .default){(action) in
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                }
                alertController.addAction(OKAction)
                OperationQueue.main.addOperation {
                    
                    self.present(alertController, animated: true,
                                 completion:nil)
                }
            }
        }

    @IBAction func settingBtn(_ sender: Any) {
        let vc = SettingScreen(nibName: "SettingScreen", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension DashBoardVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        if indexPath.row == 0{
            let cell = DashBoredTv.dequeueReusableCell(withIdentifier: "AlarmDashboardTvcell") as! AlarmDashboardTvcell
            if self.alarmStatus == "Active Alarm"{
           
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = DateFormat.dateFormateInApi
                
                let strDate = dateFormater.date(from: userAlarmData?[0].createdDate ?? "" )
                dateFormater.dateFormat = DateFormat.timeFormat
                let dateInDateFrmate = dateFormater.string(from: strDate ?? Date())
                let alarmcameAt = SetUpAppLanguage.shareInstance.AppLanguageData?.alarmCameInAt ?? ""
                self.noActiveAlarmLbl.text = "\(alarmcameAt) \(dateInDateFrmate)"
                cell.viewBG.backgroundColor = MyTheme.blueColor
                cell.activeAlarmImg.isHidden = false
                
                cell.noAlarmLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.activeAarm
                cell.noDataFoundLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.goToMap
                
            }else{
                self.noActiveAlarmLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.noActiveAlarm
                cell.noAlarmLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.noAlarm
                cell.noDataFoundLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.noAlarmDesc
                cell.viewBG.backgroundColor = MyTheme.backGroundDarkGrayColor
                cell.activeAlarmImg.isHidden = true
            }
            return cell
        }else  if indexPath.row == 1{
            let cell = DashBoredTv.dequeueReusableCell(withIdentifier: "AbortAlarmTvCell") as! AbortAlarmTvCell
            cell.abortMission.text = SetUpAppLanguage.shareInstance.AppLanguageData?.aboardMission
            return cell
        }else{
            let cell = DashBoredTv.dequeueReusableCell(withIdentifier: "DashboardTvCell" ) as! DashboardTvCell
            cell.countOne.text = String(dashboardGreenCount)
            cell.countTwo.text = String(dashboardOrangeCount)
            cell.countThree.text = String(dashboardGrayCount)
            let firstName = UserPersonalDetail.fetchUserDetail()?.firstName ?? ""
            let lastname = UserPersonalDetail.fetchUserDetail()?.lastName ?? ""
            cell.userName.text = "\(firstName.capitalized) \(lastname.capitalized)"
            cell.msgLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.myNotis
            
//-------------get status from getuserdetails api --------------------//
            cell.userStatus.text = userStatus
        //    cell.userStatus.text = userDataDetail?.status
            if cell.userStatus.text == "OFFLINE"{
                cell.userBG.backgroundColor =  MyTheme.OfflineStatusColor
                cell.userStatus.textColor = MyTheme.buttonBlackBackGroundColor
                cell.userName.textColor = MyTheme.buttonBlackBackGroundColor
                cell.userName.font = MyTheme.myFontMedium(18)
                cell.userStatus.font = MyTheme.myFontRegular(13)
                cell.userName.text = SetUpAppLanguage.shareInstance.AppLanguageData?.offline
                
                let dateFormatter = DateFormatter()
                let date = Date()
                dateFormatter.dateFormat = DateFormat.yearFormat
                let strData = dateFormatter.string(from: date)
                
                if UserTempData.returnValue(.todayInCalender) != nil{
                    let todayinCalender = UserTempData.returnValue(.todayInCalender) as! String
                    if todayinCalender == "true"{
                        cell.userStatus.isHidden = true
                    }else{
                        
                        cell.userStatus.isHidden = false
                        let offlineTime = UserTempData.returnValue(.getOnlineTime) as! String
                        cell.userStatus.text = "\(strData) \(offlineTime)"
                    }
                }
                
                
            }else{
                cell.userName.textColor = MyTheme.buttonwhiteBackGroundColor
                cell.userStatus.textColor = MyTheme.buttonwhiteBackGroundColor
                cell.userName.font = MyTheme.myFontRegular(18)
                cell.userStatus.font = MyTheme.myFontMedium(18)
                cell.userBG.backgroundColor =  MyTheme.backGroundGreenColor
                cell.userName.text = "\(firstName.capitalized) \(lastname.capitalized)"
                cell.userStatus.text = SetUpAppLanguage.shareInstance.AppLanguageData?.online
            }
                
            
            if userDataDetail?.image ?? "" != ""{
                cell.userProfile.isHidden = false
                cell.userProfile.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
                let imgBaseURL = "https://alitisdev.alitis.se/AlecomFirstResponderAPI/"
                let url = URL(string: "\(imgBaseURL)\(userDataDetail?.image ?? "")")
                cell.userProfile.kf.setImage(with: url)
                cell.userInitials.text = ""
            }else{
                //name here
                let fNameFirst = userDataDetail?.firstName?.first?.description ?? ""
                let lNameFirst = userDataDetail?.lastName?.first?.description ?? ""
                let nameString = "\(fNameFirst.uppercased())\(lNameFirst.uppercased())"
                cell.userInitials.text = nameString
                cell.userProfile.isHidden = true
            }
            
            cell.btnDidClicked = {[weak self] (value) in
                guard let self = self else {return}
               if value == "userDetail"{
                   let vc = UserOnlineOfflineVC(nibName: "UserOnlineOfflineVC", bundle: nil)
                   self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    let vc = MessageVC(nibName: "MessageVC", bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  
        
        if indexPath.row == 1{
            if  self.alarmStatus == "Active Alarm"{
                return UITableView.automaticDimension
            }else{
                return 0
            }
        }else{
            return UITableView.automaticDimension
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if self.alarmStatus == "Active Alarm"{
                let vc = MissionDetailOnMapVC(nibName: "MissionDetailOnMapVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }}else if indexPath.row == 1{
                if  self.alarmStatus == "Active Alarm"{
                    let vc = AlarmAcceptPopUp(nibName: "AlarmAcceptPopUp", bundle: nil)
                    vc.yesBtnDidTapped = {[weak self] in
                        guard let self = self else {return}
                        if UserTempData.returnValue(.AlarmMissionId) != nil{
                            let alarmMissionId = UserTempData.returnValue(.AlarmMissionId) as? String
                            
                            BaseClassHelper.sharedInstance.AbortMissionAlarmApi(self, missionId: alarmMissionId  ?? "", {abortSuccessfull in
                                if abortSuccessfull == true{
                                    self.ViewWillApprearApi()
                                    for controller in self.navigationController!.viewControllers as Array {
                                        if controller.isKind(of: DashBoardVC.self) {
                                            self.navigationController!.popToViewController(controller, animated: true)
                                            break
                                        }}
                                }
                            })
                        }}
                    self.present(vc, animated: true)
                }
            }
        
    }
}
