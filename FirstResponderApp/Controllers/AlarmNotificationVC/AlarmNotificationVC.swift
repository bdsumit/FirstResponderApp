//
//  AlarmNotificationVC.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/18/22.
//

import UIKit
import CoreLocation
//import NMAKit
class AlarmNotificationVC: UIViewController {

    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var mainBgView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTital: UILabel!
    @IBOutlet weak var cardiecArrest: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
 
    @IBOutlet weak var takeMission: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    var AlarmListdata : [AlarmDataList]?
    var alarmData = AcceptAlarmParam(MissionId: "", Description: "", UserId: 0, AlarmId: 0, AlarmStatus: "")
    var BtnDidClicked :((String,AcceptAlarmParam, UIViewController)->())?
    var AlarmVisibilityList : [AlarmDataVisibilityList]?
    
  //  var progress: Progress? = nil
    var calculatedDistance = 0.0
    var distanceFromMap = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveLat = UserTempData.returnValue(.Latitude) as? String
        let saveLong = UserTempData.returnValue(.Longitude) as? String
      let ourlat = Double(saveLat ?? "") ?? 0.0
       let ourLong = Double(saveLong ?? "") ?? 0.0
        
        let patientlat = Double(AlarmListdata?[0].posLat ?? "") ?? 0.0
        let patientLong =  Double(AlarmListdata?[0].posLon ?? "") ?? 0.0
        
        calculatedDistance = BaseClassHelper.sharedInstance.getRelativeDistance(ourlat: ourlat, ourLong: ourLong, patientlat: patientlat, patientLong: patientLong)
        
        
        self.alarmData.MissionId = AlarmListdata?[0].missionID ?? ""
        UserTempData.saveData(.AlarmMissionId, AlarmListdata?[0].missionID ?? "")
        self.alarmData.Description = AlarmListdata?[0].alarmDataListDescription ?? ""
        self.alarmData.AlarmId = AlarmListdata?[0].alarmID ?? 0
        self.alarmData.AlarmStatus = AlarmListdata?[0].alarmStatus ?? ""
        BaseClassHelper.sharedInstance.getUserDetailsApi(self,  { userDetails, globalSetting , alarmVissibilityList in
            self.AlarmVisibilityList = alarmVissibilityList
            self.setData()
        })
        setUpUI()
    }
    func setUpLanguage(){
        cardiecArrest.text = SetUpAppLanguage.shareInstance.AppLanguageData?.alarmTextDesc
        let meter = SetUpAppLanguage.shareInstance.AppLanguageData?.meter ?? ""
        let away = SetUpAppLanguage.shareInstance.AppLanguageData?.alarmDistanceLabel ?? ""
        self.distanceLbl.text = "\(calculatedDistance.clean) \(meter) \(away)"
        acceptBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.yes, for: .normal)
        rejectBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.no, for: .normal)
        takeMission.text = SetUpAppLanguage.shareInstance.AppLanguageData?.takeAssignment
    }
    
//    func addRoute(isCarRout : Bool) {
//        coreRouter = NMACoreRouter()
//
//
//        let routingMode = NMARoutingMode.init(
//            routingType: NMARoutingType.fastest,
//            transportMode: isCarRout ? NMATransportMode.car : NMATransportMode.pedestrian,
//            routingOptions: NMARoutingOption.avoidHighway
//        )
//
//        // check if calculation completed otherwise cancel.
//        if !(progress?.isFinished ?? false) {
//            progress?.cancel()
//        }
//
//        // Use banned areas if needed
//      //  addBannedAreas(coreRouter);
//
//        // store progress.
//        progress = coreRouter.calculateRoute(withStops: route, routingMode: routingMode, { (routeResult, error) in
//            if (error != NMARoutingError.none) {
//                NSLog("Error in callback: \(error)")
//                return
//            }
//
//            guard let route = routeResult?.routes?.first else {
//                print("Empty Route result")
//                return
//            }
//
//            guard let box = route.boundingBox, let mapRoute = NMAMapRoute.init(route) else {
//                print("Can't init Map Route")
//                return
//            }
//
//            //MARK: - FOR DISTANCE AND DURATION
//            let dist = (route.length)
//            self.distanceLbl.text = "\(dist) meter away"
//             let durationTime = route.ttaIncludingTraffic(forSubleg: 0)?.duration ?? 0.0// [myRoute ttaExcludingTrafficForSubleg:0].duration;
//
//
//        })
//    }
    
    func setUpUI(){
        setUpLanguage()
        //Font colour
        cardiecArrest.textColor = MyTheme.buttonwhiteBackGroundColor
        distanceLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        takeMission.textColor = MyTheme.buttonwhiteBackGroundColor
        descriptionLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        headerTital.textColor = MyTheme.buttonwhiteBackGroundColor
        //Font SIze
        cardiecArrest.font = MyTheme.myFontMedium(18)
        distanceLbl.font = MyTheme.myFontMedium(18)
        takeMission.font = MyTheme.myFontBold(22)
        distanceLbl.font = MyTheme.myFontSemiBold(18)
        headerTital.font = MyTheme.myFontMedium(18)
        // back ground colour
        headerView.backgroundColor = MyTheme.alarmTopColor
        mainBgView.backgroundColor = MyTheme.backGroundDarkRedColor
        descriptionView.backgroundColor = MyTheme.buttonBlackBackGroundColor
        acceptBtn.backgroundColor = MyTheme.greenColor
        rejectBtn.backgroundColor = MyTheme.backGroundLightGrayColor
    }
    func setData(){
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = DateFormat.dateFormateInApi
        let strDate = dateFormater.date(from: AlarmListdata?[0].createdDate ?? "")
        dateFormater.dateFormat = DateFormat.timeFormat
        let dateInDateFrmate = dateFormater.string(from: strDate ?? Date())
        let recieveAt = SetUpAppLanguage.shareInstance.AppLanguageData?.alarmRecievAt ?? ""
        self.headerTital.text = "\(recieveAt) \(dateInDateFrmate)"

        self.cardiecArrest.text = AlarmListdata?[0].alarmCategory
        
        if let isStreetVisible = self.AlarmVisibilityList?.filter({$0.fieldName == "Description"}),isStreetVisible[0].isEnable == true {
            let Decription = AlarmListdata?[0].alarmDataListDescription ?? ""
            let DecToArr = Decription.components(separatedBy:",")
            self.descriptionLbl.text = DecToArr[2]
        }else  if let isStreetVisible = self.AlarmVisibilityList?.filter({$0.fieldName == "Description"}),isStreetVisible[0].isEnable == false {
            if isStreetVisible[0].customDescription == "" {
                self.descriptionView.isHidden = true
            }else{
                self.descriptionLbl.text = isStreetVisible[0].customDescription
            }
            
        }
        
    }
    func offsoundAndTorch(){
        BaseClassHelper.sharedInstance.fadeOutSound()
        BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: false)
        BaseClassHelper.sharedInstance.vibrateInLoop(isvibrate: false)
    }

    @IBAction func acceptBtnClicked(_ sender: Any) {
        offsoundAndTorch()
        BtnDidClicked?("Accept",alarmData, self)
      //  self.dismiss(animated: true)
    }
    @IBAction func rejectBtnClicked(_ sender: Any) {
        offsoundAndTorch()
        BtnDidClicked?("Reject",alarmData, self)
      //  self.dismiss(animated: true)
        
    }
}
