//
//  MissionDetailOnMapVC.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/21/22.
//

import UIKit
import AVFoundation
import CoreLocation

class MissionDetailOnMapVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate ,CLLocationManagerDelegate{

    @IBOutlet weak var bgView: UIView!
 //   @IBOutlet weak var recieveAtLbl: UILabel!
    @IBOutlet weak var equipmentPickedView: UIView!
 //   @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var victimView: UIView!
    @IBOutlet weak var getVictimLbl: UILabel!
    @IBOutlet weak var addreessLbl: UILabel!
    @IBOutlet weak var viewMissionLbl: UILabel!
//    @IBOutlet weak var minutesLeft: UILabel!
//    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var callImage: UIImageView!
    @IBOutlet weak var noEquipmentAvailView: UIView!
    @IBOutlet weak var topMissionViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var mapDetalView: UIView!
    @IBOutlet weak var arriveView: UIView!
   // @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var missionView: UIView!
    @IBOutlet weak var equipmentPickedLbl: UILabel!
    @IBOutlet weak var NoEquipmentLbl: UILabel!
    @IBOutlet weak var equipmentBgView: UIView!
    @IBOutlet weak var arriveAarmView: UIView!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var therepyView: UIView!
    @IBOutlet weak var callLbl: UILabel!
    @IBOutlet weak var cemeraVideoLbl: UILabel!
    @IBOutlet weak var therepyLbl: UILabel!
    @IBOutlet weak var nearPatientBottomView: UIView!
    @IBOutlet weak var patientAndEquiImg: UIImageView!
  //  @IBOutlet weak var distanceAndTimeView: UIView!
    @IBOutlet weak var missionCompletView: UIView!
    @IBOutlet weak var arriveLbl: UILabel!
    @IBOutlet weak var missionCompleteLbl: UILabel!
    @IBOutlet weak var comprtessionImg: UIImageView!
    var isUploadingCaseImage = false
    var UserALarmListData : [AlarmDataList]?
    var EquipmentListData : EquipmentList?
    var GlobleSettingData : [GlobalSetting]?
    var ClickedImage = UIImageView()
    var customMapViewAcc = LatestMapClass.instanceFromNib()
    var imagePicker = UIImagePickerController()
    var locManager = CLLocationManager()
    var compressionBtnSelect = true
    var mobileNumber = ""
    var directCallingEnable = Bool()
    var arrivalDistance = 0.0
    var isReachDestination = false
    var getuserSettingdata : UserSettingDetail?
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setUpUI()
        
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(UpdaterouteOnMap(_:)),
                         name: NSNotification.Name ("UpdateRoute"),                                           object: nil)
        
        
        BaseClassHelper.sharedInstance.getUserSettingApi(self, { userSettingDetaills in
            self.getuserSettingdata = userSettingDetaills
          //  self.settingTableView.reloadData()
        })
    }
    @objc func UpdaterouteOnMap(_ notification: Notification){
        self.customMapViewAcc.endAction()
        viewWillAppearWork()
     
    }
   func loadMap(){
       customMapViewAcc.vcAccess = self
       
       customMapViewAcc.frame = self.mapDetalView.bounds
       customMapViewAcc.UserALarmListData = UserALarmListData
       customMapViewAcc.EquipmentListData = EquipmentListData
       customMapViewAcc.mapNavigationWork()
       self.mapDetalView.addSubview(customMapViewAcc)
    }
    override func viewWillAppear(_ animated: Bool) {
        //  USER ALARM LIST AND USER DETAIL API
        
        if isUploadingCaseImage == true || isReachDestination == true{
            print("ImageUploading")
        }else{
            viewWillAppearWork()
            setUpLanguage()
        }
    }
    
    func setUpLanguage(){
        missionCompleteLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.missionCompleted
        viewMissionLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.viewDetails
        callLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.call
        cemeraVideoLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.cameraVideo
    }
 
    func viewWillAppearWork(){
        BaseClassHelper.sharedInstance.GetUserAlarmListApi(self,{ UseralarmlistData , EquipmentListDatail in
            self.setUpDesign(UseralarmlistData : UseralarmlistData, EquipmentListData: EquipmentListDatail )
            
            BaseClassHelper.sharedInstance.getUserDetailsApi( self , {userDetails,globelSettingData,alarmVisibilityListData in
                self.GlobleSettingData = globelSettingData
                for globleSettingDetail in globelSettingData ?? []{
                    if globleSettingDetail.settingName == "EnableDirectCalling"{
                        if globleSettingDetail.settingValue == "true"{
                            self.directCallingEnable = true
                            self.callImage.image = UIImage(named: "Call")
                        }else{
                            self.directCallingEnable = false
                            self.callImage.image = UIImage(named: "callBack")
                        }
                    }
                    if globleSettingDetail.settingName == "DispatcherCallingNumber"{
                        
                        self.mobileNumber = globleSettingDetail.settingValue ?? ""
                    }
                    if globleSettingDetail.settingName == "DistanceForArrivedDetection"{
                        self.arrivalDistance = Double(globleSettingDetail.settingValue ?? "") ?? 0.0
                    }
                   }
            })
        })
    }
    
    func buttonAccessFromClass(){
        customMapViewAcc.buttonDidClicked = {[weak self] (value) in
            guard let self = self else {return}
            if value == "AbortMissionClicked"{
                self.onCompression()
                
                let vc = AlarmAcceptPopUp(nibName: "AlarmAcceptPopUp", bundle: nil)
                vc.yesBtnDidTapped = {[weak self] in
                    guard let self = self else {return}
                    if UserTempData.returnValue(.AlarmMissionId) != nil{
                        let alarmMissionId = UserTempData.returnValue(.AlarmMissionId) as? String
                        
                        BaseClassHelper.sharedInstance.AbortMissionAlarmApi(self, missionId: alarmMissionId  ?? "", {abortSuccessfull in
                            if abortSuccessfull == true{
                                for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: DashBoardVC.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }}
                            }
                        })
                    }}
                self.present(vc, animated: true)
            }else if value == "MissionDetailClicked"{
                self.onCompression()
                if self.UserALarmListData?[0].action == "GOTOPATIENT"{
                    let vc =  DetailMissionVC(nibName: "DetailMissionVC", bundle: nil)
                    vc.forPatientOrEquipment = "Patient"
                    vc.EquipmentListData = self.EquipmentListData
                    vc.UserALarmListData = self.UserALarmListData
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc =  DetailMissionVC(nibName: "DetailMissionVC", bundle: nil)
                    vc.forPatientOrEquipment = "Equipment"
                    vc.EquipmentListData = self.EquipmentListData
                    vc.UserALarmListData = self.UserALarmListData
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
    }
    
    func setUpMapFunctionality(UseralarmlistData : [AlarmDataList]? , EquipmentListData : EquipmentList?){
        self.buttonAccessFromClass()
        if UseralarmlistData?[0].action == "GOTOPATIENT"{
            // design work
//            self.arriveAarmView.isHidden = true
//            self.nearPatientBottomView.isHidden = true
//            self.equipmentBgView.isHidden = true
            // MAP WORK

            customMapViewAcc.ToLatitude = Double(UseralarmlistData?[0].posLat ?? "") ?? 0.0
            customMapViewAcc.ToLongitude = Double(UseralarmlistData?[0].posLon ?? "") ?? 0.0
            loadMap()
            customMapViewAcc.forPatient = true
            customMapViewAcc.UserALarmListData = UseralarmlistData
            customMapViewAcc.EquipmentListData = EquipmentListData
            customMapViewAcc.getuserSettingdata = getuserSettingdata
            customMapViewAcc.setUpVictomDesign()
            updatemujeUnmuteInSetting ()
            
            customMapViewAcc.getdisAndDoration =  {[weak self] (distance) in
                guard let self = self else {return}
           //    self.distanceLbl.isHidden = false
            //    self.timeRemaining.isHidden = false
            //    self.minutesLeft.isHidden = false
                
                
           //     self.distanceLbl.text =  "\(distance) M"
       
            //    self.timeRemaining.text = duration
             //   self.minutesLeft.text = AddedTime
                 print(self.arrivalDistance)
                if self.isReachDestination == true{
                    return
                }
                if distance <= self.arrivalDistance{

                         self.UpdateCaseApi(alarmId : self.UserALarmListData?[0].alarmID ?? 0)
                        self.isReachDestination = true
//                         let date = Date()
//                         let calendar = Calendar.current
//                         let hour = calendar.component(.hour, from: date)
//                         let minutes = calendar.component(.minute, from: date)
//                         let arrivedAt = SetUpAppLanguage.shareInstance.AppLanguageData?.arrived ?? ""
//                         self.arriveLbl.text =  "\(arrivedAt) \(hour):\(minutes)"
                         self.arriveAarmView.isHidden = false
                         self.topMissionViewHeightConstrain.constant = 80
                         self.nearPatientBottomView.isHidden = false
                         self.equipmentBgView.isHidden = true
                         self.victimView.isHidden = true
                         self.customMapViewAcc.progressBtn.isHidden = true
                         self.customMapViewAcc.imgProgress.isHidden = true
                         self.customMapViewAcc.progressLbl.isHidden = true
                         self.customMapViewAcc.viewDistance.isHidden = true
                         self.customMapViewAcc.victumView.isHidden = true
                    self.customMapViewAcc.hideSlideBar()
                }else{
                    self.arriveAarmView.isHidden = true
                    self.topMissionViewHeightConstrain.constant = 0
                    self.nearPatientBottomView.isHidden = true
                    self.equipmentBgView.isHidden = true
                    self.victimView.isHidden = false
                    self.customMapViewAcc.progressBtn.isHidden = false
                    self.customMapViewAcc.imgProgress.isHidden = false
                    self.customMapViewAcc.progressLbl.isHidden = false
               
                }
            }
        }else{
           
            if EquipmentListData == nil {
                equipmentNotFoundFeature(alarmId: UseralarmlistData?[0].alarmID ?? 0, missionId: UseralarmlistData?[0].missionID ?? "")
            }else{
              
                // MAP WORK
                customMapViewAcc.ToLatitude = EquipmentListData?.posLat ?? 0.0
                customMapViewAcc.ToLongitude = EquipmentListData?.posLon ?? 0.0
                loadMap()
                customMapViewAcc.UserALarmListData = UseralarmlistData
                customMapViewAcc.EquipmentListData = EquipmentListData
                customMapViewAcc.setUpVictomDesign()
                customMapViewAcc.forPatient = false
                
                customMapViewAcc.getuserSettingdata = getuserSettingdata
                updatemujeUnmuteInSetting ()
                
                customMapViewAcc.getdisAndDoration = {[weak self] (distance) in
                    guard let self = self else {return}
                    if self.isReachDestination == true{
                        return
                    }
                    if distance <= self.arrivalDistance  {
                        
                        self.isReachDestination = true
                        self.arriveAarmView.isHidden = true
                        self.topMissionViewHeightConstrain.constant = 0
                        self.nearPatientBottomView.isHidden = true
                        self.equipmentBgView.isHidden = false
                        self.victimView.isHidden = true
                        self.customMapViewAcc.progressBtn.isHidden = true
                        self.customMapViewAcc.imgProgress.isHidden = true
                        self.customMapViewAcc.progressLbl.isHidden = true
                        self.customMapViewAcc.viewDistance.isHidden = true
                        self.customMapViewAcc.victumView.isHidden = true
                        self.customMapViewAcc.hideSlideBar()
                    }else{
                        self.arriveAarmView.isHidden = true
                        self.topMissionViewHeightConstrain.constant = 0
                        self.nearPatientBottomView.isHidden = true
                        self.equipmentBgView.isHidden = true
                        self.victimView.isHidden = false
                        self.customMapViewAcc.progressBtn.isHidden = false
                        self.customMapViewAcc.imgProgress.isHidden = false
                        self.customMapViewAcc.progressLbl.isHidden = false
                    }
               }
            }
            
           

        }
    }
    
    func setUpDesign(UseralarmlistData : [AlarmDataList]? , EquipmentListData : EquipmentList?){
        self.UserALarmListData = UseralarmlistData
        self.EquipmentListData = EquipmentListData
        self.setUpMapFunctionality(UseralarmlistData : UseralarmlistData , EquipmentListData : EquipmentListData)
        
        if UseralarmlistData?[0].action == "GOTOPATIENT"{
            
            // ALTERATION IN UI
            self.arriveAarmView.isHidden = true
            self.nearPatientBottomView.isHidden = true
            self.equipmentBgView.isHidden = true
//            self.victimView.isHidden = false
//
//            self.patientAndEquiImg.image = UIImage(named: "RoundBrokenHeart")
//            self.getVictimLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.getToPatient ?? ""
//            if UseralarmlistData?[0].street == nil && UseralarmlistData?[0].floor == nil  && UseralarmlistData?[0].city  == nil {
//                self.addreessLbl.isHidden = true
//            }else{
//                let street =  UseralarmlistData?[0].street ?? ""
//                let floor =   UseralarmlistData?[0].floor ?? ""
//                let city =  UseralarmlistData?[0].city ?? ""
//                let floorText = SetUpAppLanguage.shareInstance.AppLanguageData?.floor ?? ""
//                self.addreessLbl.text = "\(street), \(floorText) \(floor) \(city)"
//            }
        }else{
            
            // ALTERATION IN UI
        
            self.arriveAarmView.isHidden = true
            self.topMissionViewHeightConstrain.constant = 0
            self.nearPatientBottomView.isHidden = true
            self.equipmentBgView.isHidden = true
//            self.victimView.isHidden = false
//
//            self.patientAndEquiImg.image = UIImage(named: "RoundDef")
//            self.getVictimLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.goToEquipmentText ?? ""
//            if EquipmentListData?.owner == nil && EquipmentListData?.address == nil  && EquipmentListData?.floor  == nil {
//                self.addreessLbl.isHidden = true
//            }else{
//                let Owner =  EquipmentListData?.owner ?? ""
//                let Address =  EquipmentListData?.address ?? ""
//                let floor = EquipmentListData?.floor ?? ""
//                let floorText = SetUpAppLanguage.shareInstance.AppLanguageData?.floor ?? ""
//                self.addreessLbl.text = "\(Owner), \(Address) , \(floorText) \(floor)"
//            }
        }
    }
    
    

    func setUpUI(){
        self.arriveAarmView.isHidden = true
        self.topMissionViewHeightConstrain.constant = 0
   
        
        //Font colour
   //     recieveAtLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        getVictimLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        viewMissionLbl.textColor = MyTheme.buttonwhiteBackGroundColor
    //    distanceLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        addreessLbl.textColor = MyTheme.buttonwhiteBackGroundColor
    //    minutesLeft.textColor = MyTheme.buttonwhiteBackGroundColor
    //    timeRemaining.textColor = MyTheme.buttonwhiteBackGroundColor
        equipmentPickedLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        NoEquipmentLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        callLbl.textColor = MyTheme.buttonBlackBackGroundColor
        cemeraVideoLbl.textColor = MyTheme.buttonBlackBackGroundColor
        therepyLbl.textColor = MyTheme.buttonBlackBackGroundColor
        arriveLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        missionCompleteLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        
        arriveLbl.font = MyTheme.myFontSemiBold(16)
        missionCompleteLbl.font = MyTheme.myFontSemiBold(16)
        addreessLbl.font = MyTheme.myFontRegular(16)

  //      recieveAtLbl.font = MyTheme.myFontMedium(18)
        getVictimLbl.font = MyTheme.myFontSemiBold(21)
        viewMissionLbl.font = MyTheme.myFontSemiBold(18)
//        distanceLbl.font = MyTheme.myFontMedium(18)
//        minutesLeft.font = MyTheme.myFontMedium(18)
//        timeRemaining.font = MyTheme.myFontMedium(18)
        equipmentPickedLbl.font = MyTheme.myFontMedium(18)
        NoEquipmentLbl.font = MyTheme.myFontMedium(18)
        callLbl.font = MyTheme.myFontMedium(15)
        cemeraVideoLbl.font = MyTheme.myFontMedium(15)
        therepyLbl.font = MyTheme.myFontMedium(15)
        // back ground colour
        bgView.backgroundColor = MyTheme.backGroundDarkGrayColor
 //       headerView.backgroundColor = MyTheme.backGroundDarkRedColor
        victimView.backgroundColor = MyTheme.mapblueCoor
        missionView.backgroundColor = MyTheme.orangeBgColor
      //  equipmentBgView.backgroundColor = MyTheme.backGroundDarkGrayColor
       // equipmentPickedView.backgroundColor = MyTheme.backGroundGreenColor
      //  noEquipmentAvailView.backgroundColor = MyTheme.backGroundPurpleColor
      //  nearPatientBottomView.backgroundColor = MyTheme.backGroundDarkGrayColor
        callView.backgroundColor = .clear
        cameraView.backgroundColor = .clear
        therepyView.backgroundColor = .clear
  //      distanceAndTimeView.backgroundColor = MyTheme.backGroundLightGrayColor
      //  arriveView.backgroundColor = MyTheme.backGroundGreenColor
      //  missionCompletView.backgroundColor = MyTheme.mapblueCoor
    }
    
    func updatemujeUnmuteInSetting (){
        
        customMapViewAcc.updateMuteUnmuteSetting = {[weak self] (ismuteOn) in
            guard let self = self else {return}
            
            var params = updateUserSettingsParams(UserId: UserPersonalDetail.fetchUserDetail()?.userID, language: self.getuserSettingdata?.language, muteNavigation: ismuteOn, vibrate: self.getuserSettingdata?.vibrate, position: self.getuserSettingdata?.position, alarmSound: self.getuserSettingdata?.alarmSound, alarmFlash: self.getuserSettingdata?.alarmFlash,showStatusSilentNoti: self.getuserSettingdata?.showStatusSilentNotification)
            
            BaseClassHelper.sharedInstance.updateUserSettingsApi(updateUserSettingsParams: params, self, {successUpdate in
                if successUpdate == true{
                    BaseClassHelper.sharedInstance.getUserSettingApi(self, { userSettingDetaills in
                        self.getuserSettingdata = userSettingDetaills
                    })
                }
            })
        }
        
    }
    
    func equipmentNotFoundFeature(alarmId : Int , missionId : String){
        BaseClassHelper.sharedInstance.GetGlobelSettingApi(self, {GlobleSettingData in
            let gotoPatient = SetUpAppLanguage.shareInstance.AppLanguageData?.goToPatientPopupTitle
             let ok = SetUpAppLanguage.shareInstance.AppLanguageData?.ok
            for GlobelSettingDetail in GlobleSettingData ?? []{
                if GlobelSettingDetail.settingName == "GoToPatientForEquipment"{
                    let alertController = UIAlertController(title: "", message: gotoPatient, preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: ok, style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        // forcefully Call Change Alarm Status Api
                        self.ChangeAlarmStatusApi(alarmId : alarmId)
                    }
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }else if GlobelSettingDetail.settingName == "AbortAlarmForEquipment" {
                    let abortmissionpopUp = SetUpAppLanguage.shareInstance.AppLanguageData?.abortMissionPopupTitle
                     let ok = SetUpAppLanguage.shareInstance.AppLanguageData?.ok
                    let alertController = UIAlertController(title: "", message: abortmissionpopUp, preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: ok, style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        // forcefully Call abort mission Api
                        BaseClassHelper.sharedInstance.AbortMissionAlarmApi(self, missionId: missionId, {abortSuccessFully in
                            if abortSuccessFully == true{
                                for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: DashBoardVC.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }}
                            }
                        })
                        
                    }
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
    }
    

    @IBAction func NoequipmentBtn(_ sender: Any) {
        onCompression()
        EquipmentNotFound(alarmId : UserALarmListData?[0].alarmID ?? 0 , EquipmentId : UserALarmListData?[0].equipmentID ?? 0, missionId: UserALarmListData?[0].missionID ?? "")
    }
    @IBAction func equipmentPickedBtn(_ sender: Any) {
        onCompression()
        EquipmentPicked(alarmId : UserALarmListData?[0].alarmID ?? 0 , EquipmentId : UserALarmListData?[0].equipmentID ?? 0)
    }
  
//    @IBAction func btnMissionDetail(_ sender: Any) {
//        onCompression()
//        if UserALarmListData?[0].action == "GOTOPATIENT"{
//            let vc =  DetailMissionVC(nibName: "DetailMissionVC", bundle: nil)
//            vc.forPatientOrEquipment = "Patient"
//            vc.EquipmentListData = EquipmentListData
//             vc.UserALarmListData = UserALarmListData
//             self.navigationController?.pushViewController(vc, animated: true)
//        }else{
//            let vc =  DetailMissionVC(nibName: "DetailMissionVC", bundle: nil)
//            vc.forPatientOrEquipment = "Equipment"
//            vc.EquipmentListData = EquipmentListData
//             vc.UserALarmListData = UserALarmListData
//             self.navigationController?.pushViewController(vc, animated: true)
//        }
//
//    }
    
    @IBAction func arrivedBtnClicked(_ sender: Any) {
        onCompression()
        UpdateCaseApi(alarmId : UserALarmListData?[0].alarmID ?? 0)
    }
    @IBAction func missionCompleteBtnClicked(_ sender: Any) {
        onCompression()
        CloseMissionApi(alarmId : UserALarmListData?[0].alarmID ?? 0)
    }
    @IBAction func callBtnClicked(_ sender: Any) {
        onCompression()
        
        if directCallingEnable == true{
            // openDailer
            BaseClassHelper.sharedInstance.dialNumber(number: mobileNumber )
            
        }else{
            self.CallBackApi(alarmId : self.UserALarmListData?[0].alarmID ?? 0)
        }
    }
 
    
    @IBAction func compressionBtnClicked(_ sender: UIButton) {
        if  compressionBtnSelect == true{
            offCompression()
        }else{
            onCompression()
        }
    }
    func offCompression(){
        compressionBtnSelect = false
        BaseClassHelper.sharedInstance.setVolume(Float(fullSound))
        BaseClassHelper.sharedInstance.soundPlay(soundType:  "CompressionAudio", inLoop: true)
        therepyView.backgroundColor = MyTheme.CompressionActiveColor
        therepyLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.stop
        therepyLbl.textColor = MyTheme.buttonwhiteBackGroundColor
    }
    func onCompression(){
        compressionBtnSelect = true
        BaseClassHelper.sharedInstance.fadeOutSound()
        therepyView.backgroundColor = .clear//MyTheme.backGroundPurpleColor
        therepyLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.compression
        therepyLbl.textColor = MyTheme.buttonBlackBackGroundColor
    }
    @IBAction func cameraBtnClicked(_ sender: Any) {
        onCompression()
        let chooseImge = SetUpAppLanguage.shareInstance.AppLanguageData?.chooseImg ?? ""
        let Camera = SetUpAppLanguage.shareInstance.AppLanguageData?.camera ?? ""
     
        let cancel = SetUpAppLanguage.shareInstance.AppLanguageData?.cancel ?? ""
        let alert = UIAlertController(title: "\(chooseImge)", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "\(Camera)", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction.init(title: "\(cancel)", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // IMAGE PICKER WORK
    func openCamera()
      {
          let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch (status)
            {
            case .authorized:
                self.popCamera()

            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (granted) in
                    if (granted)
                    {
                        self.popCamera()
                    }
                    else
                    {
                        self.camDenied()
                    }
                }

            case .denied:
                self.camDenied()
            case .restricted:
                let restricted = SetUpAppLanguage.shareInstance.AppLanguageData?.restricted ?? ""
                
                let cameraRestriction = SetUpAppLanguage.shareInstance.AppLanguageData?.cameraRestriction ?? ""
                let ok = SetUpAppLanguage.shareInstance.AppLanguageData?.ok ?? ""
                let alert = UIAlertController(title: "\(restricted)",
                                              message: "\(cameraRestriction)",
                                              preferredStyle: .alert)

                let okAction = UIAlertAction(title: "\(ok)", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            @unknown default:
                fatalError()
            }
      }
      
      func popCamera(){
          DispatchQueue.main.async {
              if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
              {
                  self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                  self.imagePicker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(.rear) ? .rear : .front
                  self.imagePicker.allowsEditing = true
                  self.present(self.imagePicker, animated: true, completion: nil)
              }
              else
              {
                  let warning = SetUpAppLanguage.shareInstance.AppLanguageData?.warning ?? ""
                  let dontHavecamera = SetUpAppLanguage.shareInstance.AppLanguageData?.dontHaveCamera ?? ""
                  let ok = SetUpAppLanguage.shareInstance.AppLanguageData?.ok ?? ""
                  
                  let alert = UIAlertController(title: "\(warning)", message: "\(dontHavecamera)", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "\(ok)", style: .default, handler: nil))
                  self.present(alert, animated: true, completion: nil)
              }
          }
          
         
      }
      func camDenied()
      {
          DispatchQueue.main.async
          {
              let cameraDenieAlart1Msg = SetUpAppLanguage.shareInstance.AppLanguageData?.deniecameraAlert1Msg ?? ""
              let cameraDenieAlart2Msg = SetUpAppLanguage.shareInstance.AppLanguageData?.deniecameraAlert2Msg ?? ""
              let ok = SetUpAppLanguage.shareInstance.AppLanguageData?.ok ?? ""
              let procced = SetUpAppLanguage.shareInstance.AppLanguageData?.procced ?? ""
              let followStep = SetUpAppLanguage.shareInstance.AppLanguageData?.followGivenStep ?? ""
              var alertText = "\(cameraDenieAlart1Msg)"
 
              var alertButton = "\(ok)"
              var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)

              if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!)
              {
                  alertText = "\(cameraDenieAlart2Msg)"

                  alertButton = "\(procced)"

                  goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                      UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                  })
              }

              let alert = UIAlertController(title: "\(followStep)", message: alertText, preferredStyle: .alert)
              alert.addAction(goAction)
              self.present(alert, animated: true, completion: nil)
          }
      }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let orinalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        ClickedImage.image = orinalImage
        UploadCaseImageAPI(alarmId : UserALarmListData?[0].alarmID ?? 0)
        isUploadingCaseImage = true
       // profilePic.contentMode = .scaleAspectFill
    }
}

