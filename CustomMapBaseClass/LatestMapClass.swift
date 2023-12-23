//
//  LatestMapClass.swift
//  FirstResponderApp
//
//  Created by bd05 on 2/3/23.
//

import Foundation
import UIKit
import heresdk

struct resoureceRequest : Encodable{
    var latitude : Double?
    var longitude : Double?
    var image : String
    var name : String?
}

class LatestMapClass : UIView, PanDelegate, DoubleTapDelegate, TwoFingerPanDelegate, PinchRotateDelegate, TwoFingerTapDelegate {

    @IBOutlet var viewDirection: UIView!
    @IBOutlet weak var recieveAtLbl: UILabel!
    @IBOutlet var viewDistance: UIView!
    @IBOutlet var mainStack: UIStackView!
    @IBOutlet weak var ivonStackView: UIStackView!
    @IBOutlet var GuidanceImage: UIImageView!
    @IBOutlet var roadLbl: UILabel!
    @IBOutlet private var mapView: MapView!
    @IBOutlet var muteImg: UIImageView!
    @IBOutlet weak var carBtn: UIButton!
    @IBOutlet weak var ChoosSataliteBtn: UIButton!
    @IBOutlet weak var choosLocationBtn: UIButton!
    @IBOutlet weak var drowDottNavigationBtn: UIButton!
    @IBOutlet var distanceUnit: UILabel!
    @IBOutlet weak var DirectionBtm: UIButton!
    @IBOutlet weak var choosStepBtn: UIButton!
    @IBOutlet var muteBtn: UIButton!
    @IBOutlet var meterLeftBtn: UILabel!
    @IBOutlet var cordinateBtn: UIButton!
    @IBOutlet var CordinateImg: UIImageView!
    @IBOutlet var vichelSpeed: UILabel!
    @IBOutlet var guidancestackHeightCons: NSLayoutConstraint!
    @IBOutlet var soundView: UIView!
    @IBOutlet var speedlimitView: UIView!
    @IBOutlet var maxSpeed: UILabel!
    @IBOutlet var progressBtn: UIButton!
    @IBOutlet var remainingDisView: UIView!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet var speedView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet var btnRecenter: UIButton!
    @IBOutlet var destinationIcon: UIImageView!
    @IBOutlet var progressLbl: UILabel!
    @IBOutlet var remainingDistance: UILabel!
    @IBOutlet var sliderBar: UISlider!
    @IBOutlet var victumView: UIView!
    @IBOutlet var addreessLbl: UILabel!
    @IBOutlet var getVictimLbl: UILabel!
    @IBOutlet var imgProgress: UIImageView!
    @IBOutlet var patientAndEquiImg: UIImageView!
    @IBOutlet var goTorouteLbl: UILabel!
    @IBOutlet var laneOneImgV: UIImageView!
    @IBOutlet var laneTwoImgV: UIImageView!
    @IBOutlet var laneThreeImgV: UIImageView!
    @IBOutlet var laneFourImgV: UIImageView!
    var UserALarmListData : [AlarmDataList]?
    var EquipmentListData : EquipmentList?
    var getuserSettingdata : UserSettingDetail?
    var getdisAndDoration : ((Double)->())?
    var updateMuteUnmuteSetting :((Bool)->())?
    var FromLatitude  = Double()
    var FromLongitude = Double()
    var ToLatitude  = Double()
    var ToLongitude = Double()
    var startingCordinates : GeoCoordinates!
    var destinationCordinates : GeoCoordinates!
    var currentRoute : Route?
    var isSataliteSelect = Bool()
    var isNavigationOn = false
    var image : UIImage?
    var imageArray = ""
    var totalDistance = Int()
    var app: App!
    var forPatient = Bool()
    var vcAccess = UIViewController()
    var buttonDidClicked : ((String)->())?
    var divrtAlertShow  = false
    private var isMapSceneLoaded = false
    class func instanceFromNib() -> LatestMapClass {
        return UINib(nibName: "LatestMapClass", bundle: nil).instantiate(withOwner: nil, options: nil).first as! LatestMapClass
    }
    override func awakeFromNib() {
        super.awakeFromNib()
     //   mapNavigationWork ()
        viewDistance.isHidden = true
        victumView.isHidden = true
        progressBtn.isSelected = true
    }
    
//----------- MAP NAVIGATION WORK
    func mapNavigationWork (){
        viewDirection.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        remainingDisView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        viewDistance.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        defaultButtonStateOn()
        self.maxSpeed.text = "N/A"
        setUpUI()
        hideGuidance()
        tapGestureFeaturs()
        mapView.mapScene.loadScene(mapScheme: MapScheme.normalDay, completion: onLoadScene)
        mapTraficfeatures()
    }
    func tapGestureFeaturs(){
        mapView.gestures.enableDefaultAction(forGesture: .doubleTap)
        mapView.gestures.enableDefaultAction(forGesture: .twoFingerTap)
        mapView.gestures.enableDefaultAction(forGesture: .pinchRotate)
        mapView.gestures.enableDefaultAction(forGesture: .pan)
        mapView.gestures.tapDelegate = self
        mapView.gestures.panDelegate = self
        mapView.gestures.doubleTapDelegate = self
        mapView.gestures.twoFingerPanDelegate = self
        mapView.gestures.pinchRotateDelegate = self
        mapView.gestures.twoFingerTapDelegate = self
      }
    func defaultButtonStateOn(){
         cordinateBtn.isSelected = true
         carBtn.isSelected = true
         choosLocationBtn.isSelected = false
         ChoosSataliteBtn.isSelected = false
     }
  func setUpUI(){
        carBtn.setImage(UIImage(named: "driving"), for: UIControl.State.normal)
        choosStepBtn.setImage(UIImage(named: "walkB"), for: UIControl.State.normal)
        ChoosSataliteBtn.setImage(UIImage(named: "sataliteBlack"), for: UIControl.State.normal)
        choosLocationBtn.setImage(UIImage(named: "Blacklocation"), for: UIControl.State.normal)
        drowDottNavigationBtn.setImage(UIImage(named: "RouteOrng"), for: UIControl.State.normal)
        DirectionBtm.setImage(UIImage(named: "navigationBlack"), for: UIControl.State.normal)
      recieveAtLbl.font = MyTheme.myFontMedium(18)
      let dateFormater = DateFormatter()
      dateFormater.dateFormat = DateFormat.dateFormateInApi
      let strDate = dateFormater.date(from: UserALarmListData?[0].createdDate ?? "")
      dateFormater.dateFormat = DateFormat.timeFormat
      let dateInDateFrmate = dateFormater.string(from: strDate ?? Date())
      let recieveAt = SetUpAppLanguage.shareInstance.AppLanguageData?.alarmRecievAt ?? ""
       self.recieveAtLbl.text = "\(recieveAt) \(dateInDateFrmate)"
    }
    
    func setUpVictomDesign(){

        if UserALarmListData?[0].action == "GOTOPATIENT"{
            // ALTERATION IN UI
          
           // self.victumView.isHidden = false
            
            self.patientAndEquiImg.image = UIImage(named: "RoundBrokenHeart")
            self.getVictimLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.getToPatient ?? ""
            if UserALarmListData?[0].street == nil && UserALarmListData?[0].floor == nil  && UserALarmListData?[0].city  == nil {
                self.addreessLbl.isHidden = true
            }else{
                let street =  UserALarmListData?[0].street ?? ""
                let floor =   UserALarmListData?[0].floor ?? ""
                let city =  UserALarmListData?[0].city ?? ""
                let floorText = SetUpAppLanguage.shareInstance.AppLanguageData?.floor ?? ""
                self.addreessLbl.text = "\(street), \(floorText) \(floor) \(city)"
            }
        }else{
            // ALTERATION IN UI
         
           // self.victumView.isHidden = false
            
            self.patientAndEquiImg.image = UIImage(named: "RoundDef")
            self.getVictimLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.goToEquipmentText ?? ""
            if EquipmentListData?.owner == nil && EquipmentListData?.address == nil  && EquipmentListData?.floor  == nil {
                self.addreessLbl.isHidden = true
            }else{
                let Owner =  EquipmentListData?.owner ?? ""
                let Address =  EquipmentListData?.address ?? ""
                let floor = EquipmentListData?.floor ?? ""
                let floorText = SetUpAppLanguage.shareInstance.AppLanguageData?.floor ?? ""
                self.addreessLbl.text = "\(Owner), \(Address) , \(floorText) \(floor)"
            }
        }
    }
     func onLoadScene(mapError: MapError?) {
        guard mapError == nil else {
            print("Error: Map scene not loaded, \(String(describing: mapError))")
            return
        }
      
         self.app = App(viewController: vcAccess, mapView: self.mapView!, guidanceImg: GuidanceImage,roadlbl : self.roadLbl ,distanceInmeter : self.meterLeftBtn)
         let saveLat = UserTempData.returnValue(.Latitude) as? String
         let saveLong = UserTempData.returnValue(.Longitude) as? String
         FromLatitude = Double(saveLat ?? "") ?? 0.0
         FromLongitude = Double(saveLong ?? "") ?? 0.0

         startingCordinates = GeoCoordinates(latitude: FromLatitude, longitude: FromLongitude)
         destinationCordinates = GeoCoordinates(latitude:  ToLatitude, longitude: ToLongitude)
 
         app.startingWaypoint = Waypoint(coordinates: startingCordinates)
         app.destinationWaypoint = Waypoint(coordinates: destinationCordinates)
         
         if getuserSettingdata?.muteNavigation == true{
             muteImg.image = UIImage(named: "sound-off-blue")
             self.app.navigationExample.ismuteVoice = true
         }else{
             self.app.navigationExample.ismuteVoice = false
             muteImg.image = UIImage(named: "sound-on-blue")
         }
        self.isMapSceneLoaded = true
         app.showTwoDimention()
         showdestinationImg(forpatient : forPatient)
        
         self.app.navigationExample.stopGuidNavigation = {[weak self] in
             guard let self = self else{ return}
             self.endAction()
             self.isNavigationOn = false
             self.setUpUI()
             
         }
         self.app.navigationExample.getLaneType = {[weak self] (isLaneShow, imageType, laneNumber)in
             guard let self = self else{ return}
             
             self.laneOneImgV.isHidden = true
             self.laneTwoImgV.isHidden = true
             self.laneThreeImgV.isHidden = true
             self.laneFourImgV.isHidden = true
             if laneNumber == 0{
                 self.laneOneImgV.isHidden = isLaneShow
                 self.laneOneImgV.image = UIImage(named: imageType)
                 
             }
             if laneNumber == 1{
                 self.laneTwoImgV.isHidden = isLaneShow
                 self.laneTwoImgV.image = UIImage(named: imageType)
                 
             }
             if laneNumber == 2{
                 self.laneThreeImgV.isHidden = isLaneShow
                 self.laneThreeImgV.image = UIImage(named: imageType)
                 
             }else{
                 self.laneFourImgV.isHidden = isLaneShow
                 self.laneFourImgV.image = UIImage(named: imageType)
                 
             }
         }
         self.app.navigationExample.getRoadName = {[weak self] (roadIcon ,distanceInMeter ,roadName) in
             guard let self = self else{ return}
             
             self.meterLeftBtn.isHidden = false
             self.roadLbl.isHidden = false
             self.GuidanceImage.isHidden = false
             self.GuidanceImage.image = UIImage(named: roadIcon)
             self.meterLeftBtn.text = distanceInMeter
             self.roadLbl.text = roadName
             self.goTorouteLbl.isHidden = true
         }
        
         self.app.getroute = {[weak self] (rought) in
             guard let self = self else{ return}
   
             self.currentRoute = rought
             self.ZoomUptoOneFrame()
             // that Code for all route information
             
             let distance = rought?.lengthInMeters ?? 0
             let duration = rought?.duration ?? 0
             let distanceInKm = (distance / 1000)
             if distanceInKm >= 1 {
                 self.distanceLbl.text = "\(distanceInKm)"
                 self.distanceUnit.text = "km"
             }else{
                 self.distanceLbl.text = "\(distance)"
                 self.distanceUnit.text = "m"
             }
             self.totalDistance = Int(distance)
             self.sliderBar.setThumbImage(UIImage(named: "in-progress.png"), for: UIControl.State.normal)
             
             let timeTaken = self.convertSecToTime(time: duration)
             
             let addedtime = self.addTimeInCurrentTime(addedtimeString: Int(duration))
         
             self.timeLbl.text = timeTaken
             self.hoursLbl.text = addedtime
            
         }
         app.navigationExample.deviationDistance = {[weak self] (daviationlength) in
             guard let self = self else{return}
             if  self.divrtAlertShow == false{
                 self.divrtAlertShow = true
                 //self.reRouteView.isHidden = false
                 DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                     //self.startNavigationClicked()
                    // self.divrtAlertShow = false
                     self.processReCalculate()
                 }
             }
         }
         app.navigationExample.getCurremntSpeed = {[weak self] (CurrentSpeed) in
             guard let self = self else{ return}
       
             self.vichelSpeed.text  = self.getSpeedInKiloMeterPrHr(SpeedInMeterPrSec: CurrentSpeed)
         }
         app.navigationExample.getSpeedlimit = {[weak self] (speedLimitOfRoad) in
             guard let self = self else{ return}
             
             if self.maxSpeed.text == "N/A"{

                 self.maxSpeed.text = self.getSpeedInKiloMeterPrHr(SpeedInMeterPrSec: speedLimitOfRoad)
             }else{
                 self.maxSpeed.text = self.getSpeedInKiloMeterPrHr(SpeedInMeterPrSec: speedLimitOfRoad)
             }
             

             
         }
         app.disableCameraTracking()
         app.addRouteDeviceLocationButtonClicked(isCarRoute: true)

    }
    func processReCalculate(){
        let saveLat = UserTempData.returnValue(.Latitude) as? String
        let saveLong = UserTempData.returnValue(.Longitude) as? String
        FromLatitude = Double(saveLat ?? "") ?? 0.0
        FromLongitude = Double(saveLong ?? "") ?? 0.0

        startingCordinates = GeoCoordinates(latitude: FromLatitude, longitude: FromLongitude)
        self.app.startingWaypoint = Waypoint(coordinates: self.startingCordinates)
        
        
        //var btn = UIButton()
        //btn.tag = 0
        //self.btnFilters(btn)
        //endAction()
        self.app.clearMap()
                
        self.app.calculateRouteAfterDeviation(isCarRoute: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            //self.app.clearMap()
            //self.startNavigationClicked()
            
            self.app.enableCameraTracking()
            self.app.navigationExample.startNavigation(route: self.currentRoute!, isSimulated: false)
            self.app.showTrafficOnRoute(self.currentRoute!)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.divrtAlertShow = false
            }
        }
        
        //self.reRouteView.isHidden = true
    }
    
    func equipmentfoundProcced(userAlrmList :[AlarmDataList]?, EquipmentData :EquipmentList?){
        self.UserALarmListData = userAlrmList
        self.EquipmentListData = EquipmentData
        destinationCordinates = GeoCoordinates(latitude: Double(self.UserALarmListData?[0].posLat ?? "") ?? 0.0 , longitude: Double(self.UserALarmListData?[0].posLon ?? "") ?? 0.0)
      
        startNewRoute()
    }
//    func notEquipmentfoundProcced(tolatitude: Double , toLongitude: Double){
//
//        destinationCordinates = GeoCoordinates(latitude:  tolatitude, longitude: toLongitude)
//        startNewRoute()
//
//    }
    func startNewRoute(){
        setUpVictomDesign()
        self.app.destinationWaypoint = Waypoint(coordinates: self.destinationCordinates)
        endAction()
        showdestinationImg(forpatient : true)
        app.addRouteDeviceLocationButtonClicked(isCarRoute: true)
    }
    func showdestinationImg(forpatient : Bool){
        if forpatient == true {
            self.destinationIcon.image = UIImage(named: "RoundBrokenHeart.png")
            guard
                let image = UIImage(named: "RoundBrokenHeart.png"),
                let imageData = image.pngData() else {
                    print("Error: Image not found.")
                    return
            }
            let anchorPoint = Anchor2D(horizontal: 0.5, vertical: 1)
            let mapMarker = MapMarker(at: destinationCordinates,
                                      image: MapImage(pixelData: imageData,
                                                      imageFormat: ImageFormat.png),
                                      anchor: anchorPoint)
            mapView.mapScene.addMapMarker(mapMarker)
        }else{
            self.destinationIcon.image = UIImage(named: "RoundDef.png")
            guard
                let image = UIImage(named: "RoundDef.png"),
                let imageData = image.pngData() else {
                    print("Error: Image not found.")
                    return
            }
            let anchorPoint = Anchor2D(horizontal: 0.5, vertical: 1)
            let mapMarker = MapMarker(at: destinationCordinates,
                                      image: MapImage(pixelData: imageData,
                                                      imageFormat: ImageFormat.png),
                                      anchor: anchorPoint)
            mapView.mapScene.addMapMarker(mapMarker)
        }
        
    }
    
    func mapTraficfeatures(){
        // TRAFIC
//        trafficExample = TrafficExample(viewController: vcAccess, mapView: mapView!)
//        trafficExample.onEnableAllButtonClicked()

        mapView.mapScene.enableFeatures([MapFeatures.trafficFlow : MapFeatureModes.trafficFlowWithFreeFlow])
        mapView.mapScene.enableFeatures([MapFeatures.trafficIncidents : MapFeatureModes.defaultMode])
        mapView.mapScene.enableFeatures([MapFeatures.safetyCameras : MapFeatureModes.defaultMode])
        mapView.mapScene.enableFeatures([MapFeatures.vehicleRestrictions : MapFeatureModes.defaultMode])
        mapView.mapScene.enableFeatures([MapFeatures.landmarks : MapFeatureModes.landmarksTextured])
    }
    func convertSecToTime(time: TimeInterval) -> String {
           let hour = Int(time) / 3600
           let minute = Int(time) / 60 % 60
         //  let second = Int(time) % 60
           // return formated string
           return String(format: "%02i:%02i", hour, minute)
       }
    
    func getSpeedInKiloMeterPrHr(SpeedInMeterPrSec : Double) -> String{
        if SpeedInMeterPrSec == 0 {
            return self.maxSpeed.text ?? ""
        }
        let currentSpeed = SpeedInMeterPrSec * 3.6
        let speedInInt = Int(currentSpeed)
        return String(speedInInt)
    }
  
    func ZoomUptoOneFrame(){
        // that for zoom on route
        let routeGeoBox = self.currentRoute?.boundingBox
        let geoOrientation = GeoOrientationUpdate(bearing: 45 , tilt: 0)
        self.mapView.camera.lookAt(area: routeGeoBox!,
                      orientation: geoOrientation)
        
        
        //that for show all route warnings
        let sections = self.currentRoute?.sections
        for section in sections ?? []{
            for notice in section.sectionNotices {
                print("This route contains the following warning: \(notice.code)")
            }
        }
    }
    @IBAction func crossclicked(_ sender: Any) {
        self.app.clearMap()
     
        // onCompression()
         for controller in self.vcAccess.navigationController!.viewControllers as Array {
             if controller.isKind(of: DashBoardVC.self) {
                 self.vcAccess.navigationController!.popToViewController(controller, animated: true)
                 break
             }
         }
        
    }
    @IBAction func abortMissionBtn(_ sender: Any) {

        buttonDidClicked?("AbortMissionClicked")
    }
    @IBAction func MissionDetailBtn(_ sender: Any) {
        buttonDidClicked?("MissionDetailClicked")
    }
    func getUpdatedRought(){
        self.app.navigationExample.getdisAndDoration = {[weak self] (distance , time) in
            guard let self = self else{ return}
            self.getdisAndDoration?(distance)
  
            let distanceInKm = (distance / 1000)
            if distanceInKm >= 1 {
                self.remainingDistance.text = "\(distanceInKm.clean) km"
            }else{
                self.remainingDistance.text = "\(distance.clean) m"
            }
            let distanceCoverd =  (self.totalDistance - Int(distance))
            let actualProgress = (Float(distanceCoverd) / Float(self.totalDistance))
            print(self.totalDistance)
            print(actualProgress)
            self.sliderBar.value = Float(actualProgress)
            self.sliderBar.setThumbImage(UIImage(named: "in-progress.png"), for: UIControl.State.normal)
       
        }
    }
   
    func addTimeInCurrentTime(addedtimeString : Int) -> String{
    
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .second, value: addedtimeString, to: Date())!
     //   let date = Date()
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.timeFormat
        let dateStr = dateFormatter.string(from: date)
        return dateStr

    }
    func hideGuidance(){
        soundView.isHidden = true
       btnRecenter.isHidden = true
        guidancestackHeightCons.constant = 0
     //   viewDirection.isHidden = true
        speedView.isHidden = true
        speedlimitView.isHidden = true
        sliderBar.isHidden = true
        remainingDisView.isHidden = true
        meterLeftBtn.isHidden = true
        roadLbl.isHidden = true
        self.GuidanceImage.isHidden = true
    }
    func showGuidance(){

        soundView.isHidden = false
       // btnRecenter.isHidden = false
        self.speedView.isHidden = false
        speedlimitView.isHidden = false
        remainingDisView.isHidden = false
        
        sliderBar.isHidden = false
        guidancestackHeightCons.constant = 70
   //     viewDirection.isHidden = false
        meterLeftBtn.isHidden = false
        roadLbl.isHidden = false
        self.GuidanceImage.isHidden = false
    }
    func hideSlideBar(){
        soundView.isHidden = true
       btnRecenter.isHidden = true
        CordinateImg.isHidden = true
        guidancestackHeightCons.constant = 0
        
        speedView.isHidden = true
        speedlimitView.isHidden = true
        sliderBar.isHidden = true
    //    remainingDisView.isHidden = true
    //    meterLeftBtn.isHidden = true
        roadLbl.isHidden = true
   //     self.GuidanceImage.isHidden = true
        
        self.carBtn.isHidden = true
        self.choosStepBtn.isHidden = true
        self.ChoosSataliteBtn.isHidden = true
        self.choosLocationBtn.isHidden = true
        self.drowDottNavigationBtn.isHidden = true
        self.DirectionBtm.isHidden = true
    }


    
    func endAction(){
        isNavigationOn = false
        DirectionBtm.isSelected = true
        self.app.clearMap()
        //self.app.clearRoute()
        self.hideGuidance()
        self.app.disableCameraTracking()
        
     }
 

    
    
    @IBAction func muteBtn(_ sender: Any){
        if muteImg.image == UIImage(named: "sound-on-blue"){
   
            muteImg.image = UIImage(named: "sound-off-blue")
            self.app.navigationExample.ismuteVoice = true
            updateMuteUnmuteSetting?(true)
        }else{

            self.app.navigationExample.ismuteVoice = false
            muteImg.image = UIImage(named: "sound-on-blue")
           updateMuteUnmuteSetting?(false)
        }
        
    }
    @IBAction func recenterBtn(_ sender: Any) {
        btnRecenter.isHidden = true
        self.app.enableCameraTracking()
        let _coordinate = app.startingWaypoint?.coordinates
        app.ZoomdestinationLocation(endCordinates :_coordinate!)
    }
    @IBAction func appAllignment(_ sender: Any) {
        if cordinateBtn.isSelected == true{
            cordinateBtn.isSelected = false
            CordinateImg.image = UIImage(named: "2D-blue")
            app.showThreeDimention()
        }else{
            cordinateBtn.isSelected = true
            CordinateImg.image = UIImage(named: "3D-blue")
            app.showTwoDimention()
        }
       
    }
    func updateImageWithType(sateLiteBnt : Bool, locationBtn : Bool, stepBtn : Bool, drawNavigationBtn : Bool, catBtn : Bool, directionBtn : Bool){
      
           ChoosSataliteBtn.setImage(UIImage(named: sateLiteBnt == true ? "sataliteOrng" : "sataliteBlack"), for: UIControl.State.normal)
           drowDottNavigationBtn.setImage(UIImage(named: drawNavigationBtn == true ? "RouteOrng" : "RouteBlck"), for: UIControl.State.normal)
           carBtn.setImage(UIImage(named: catBtn == true ? "driving" : "drivingBlack"), for: UIControl.State.normal)
           choosStepBtn.setImage(UIImage(named: stepBtn == true ? "walkO" : "walkB"), for: UIControl.State.normal)
           DirectionBtm.setImage(UIImage(named: directionBtn == true ? "navigationOrng" : "navigationBlack"), for: UIControl.State.normal)
           choosLocationBtn.setImage(UIImage(named: locationBtn == true ? "Orangelocation" : "Blacklocation"), for: UIControl.State.normal)

       }
    @IBAction func btnProgress(_ sender: Any) {
        if progressBtn.isSelected == true{
            viewDistance.isHidden = false
            victumView.isHidden = false
        }else{
            viewDistance.isHidden = true
            victumView.isHidden = true
        }
        progressBtn.isSelected = !progressBtn.isSelected
        
    }
    @IBAction func btnFilters(_ sender: UIButton) {
        
        let saveLat = UserTempData.returnValue(.Latitude) as? String
        let saveLong = UserTempData.returnValue(.Longitude) as? String
        FromLatitude = Double(saveLat ?? "") ?? 0.0
        FromLongitude = Double(saveLong ?? "") ?? 0.0
        self.goTorouteLbl.isHidden = true
        startingCordinates = GeoCoordinates(latitude: FromLatitude, longitude: FromLongitude)
        app.startingWaypoint = Waypoint(coordinates: startingCordinates)
        mapTraficfeatures()
        switch sender.tag {
        case 0:
           //Car Mode
            endAction()
//                   if isNavigationOn == true{
//
//
//                       carBtn.isSelected = false
//                       drowDottNavigationBtn.isSelected = false
//
//                   }
           // if !carBtn.isSelected{
                carBtn.isSelected = true
                choosStepBtn.isSelected = false
                choosLocationBtn.isSelected = false
                DirectionBtm.isSelected = false
                drowDottNavigationBtn.isSelected = true
                app.addRouteDeviceLocationButtonClicked(isCarRoute: true)
                self.updateImageWithType(sateLiteBnt: ChoosSataliteBtn.isSelected,
                                         locationBtn: choosLocationBtn.isSelected,
                                         stepBtn: choosStepBtn.isSelected,
                                         drawNavigationBtn: drowDottNavigationBtn.isSelected,
                                         catBtn: carBtn.isSelected,
                                         directionBtn: DirectionBtm.isSelected)
           // }
            
           
            

        case 1:
                   
            // steps Mode
            if isNavigationOn == true {
                endAction()
                choosStepBtn.isSelected = false
                drowDottNavigationBtn.isSelected = false
            }
            
            if !choosStepBtn.isSelected{
                carBtn.isSelected = false
                choosStepBtn.isSelected = true
                choosLocationBtn.isSelected = false
                DirectionBtm.isSelected = false
                drowDottNavigationBtn.isSelected = true
                app.addRouteDeviceLocationButtonClicked(isCarRoute: false)
                self.updateImageWithType(sateLiteBnt: ChoosSataliteBtn.isSelected,
                                         locationBtn: choosLocationBtn.isSelected,
                                         stepBtn: choosStepBtn.isSelected,
                                         drawNavigationBtn: drowDottNavigationBtn.isSelected,
                                         catBtn: carBtn.isSelected,
                                         directionBtn: DirectionBtm.isSelected)
            }
            

        case 2:
            //print("Working...")
            
            //satelite mode or normal mode
            //DirectionBtm.isSelected = false
            if ChoosSataliteBtn.isSelected == false{
                ChoosSataliteBtn.isSelected = true
                
                mapView.mapScene.loadScene(mapScheme: MapScheme.satellite, completion: nil)
            }else{
                //mapTraficfeatures()
               
                ChoosSataliteBtn.isSelected = false
                mapView.mapScene.loadScene(mapScheme: MapScheme.normalDay, completion: nil)
            }

            self.updateImageWithType(sateLiteBnt: ChoosSataliteBtn.isSelected,
                                     locationBtn: choosLocationBtn.isSelected,
                                     stepBtn: choosStepBtn.isSelected,
                                     drawNavigationBtn: drowDottNavigationBtn.isSelected,
                                     catBtn: carBtn.isSelected,
                                     directionBtn: DirectionBtm.isSelected)
           
        case 3:
            
//                   if choosLocationBtn.isSelected == false{
//                       choosLocationBtn.isSelected = true
//                       drowDottNavigationBtn.isSelected = false
//                       app.ZoomdestinationLocation(endCordinates :destinationCordinates)
//                   }else{
//                       if isNavigationOn == true{
//                           self.recenterBtn(UIButton.self)
//                       }
//                       else{
//                           ZoomUptoOneFrame()
//                           drowDottNavigationBtn.isSelected = true
//                       }
//                       choosLocationBtn.isSelected = false
//
//                   }
            choosLocationBtn.isSelected = true
            drowDottNavigationBtn.isSelected = false
            app.ZoomdestinationLocation(endCordinates :destinationCordinates)
            
            self.updateImageWithType(sateLiteBnt: ChoosSataliteBtn.isSelected,
                                     locationBtn: choosLocationBtn.isSelected,
                                     stepBtn: choosStepBtn.isSelected,
                                     drawNavigationBtn: drowDottNavigationBtn.isSelected,
                                     catBtn: carBtn.isSelected,
                                     directionBtn: DirectionBtm.isSelected)
            
            
        case 4:
            choosLocationBtn.isSelected = false
            drowDottNavigationBtn.isSelected = true
                
                let btn = UIButton()
                btn.tag = 0
                self.btnFilters(btn)

        
        case 5:
           // print("Working...")
            
            // start navigation
            if isNavigationOn == true{
                

                
            }else{
                //self.endAction()
                startNavigationClicked ()
            }
        default:
            print("Working...")
        }
       
        }
    func startNavigationClicked (){
        getUpdatedRought()
        showGuidance()
        isNavigationOn = true
        choosLocationBtn.isSelected = false
        drowDottNavigationBtn.isSelected = false
        DirectionBtm.isSelected = true
        self.goTorouteLbl.isHidden = false
        
        self.app.enableCameraTracking()
        self.app.navigationExample.startNavigation(route: self.currentRoute!, isSimulated: false)
        self.app.showTrafficOnRoute(self.currentRoute!)

        self.updateImageWithType(sateLiteBnt: ChoosSataliteBtn.isSelected,
                                 locationBtn: choosLocationBtn.isSelected,
                                 stepBtn: choosStepBtn.isSelected,
                                 drawNavigationBtn: drowDottNavigationBtn.isSelected,
                                 catBtn: carBtn.isSelected,
                                 directionBtn: DirectionBtm.isSelected)
    }
        
    }


extension LatestMapClass : TapDelegate {
    // Conform to the TapDelegate protocol.
    func onTap(origin: Point2D) {
        
        let geoCoordinates = mapView.viewToGeoCoordinates(viewCoordinates: origin)
        print("Tap at: \(String(describing: geoCoordinates))")
        self.app.disableCameraTracking()
        btnRecenter.isHidden = false
       // mapView.pickMapItems(at: origin, radius: 2, completion: onMapItemsPicked)
    }
    
    func onTwoFingerTap(origin: heresdk.Point2D) {
        print("onTwoFingerTap")
        self.app.disableCameraTracking()
        btnRecenter.isHidden = false
    }
    

 
    func onPinchRotate(state: heresdk.GestureState, pinchOrigin: heresdk.Point2D, rotationOrigin: heresdk.Point2D, twoFingerDistance: Double, rotation: heresdk.Angle) {
        print("onPinchRotate")
        self.app.disableCameraTracking()
        btnRecenter.isHidden = false
    }
    
    func onTwoFingerPan(state: heresdk.GestureState, origin: heresdk.Point2D, translation: heresdk.Point2D, velocity: Double) {
        print("onTwoFingerPan")
        self.app.disableCameraTracking()
        btnRecenter.isHidden = false
    }

   
    
    func onDoubleTap(origin: heresdk.Point2D) {
        print("onDoubleTap")
        self.app.disableCameraTracking()
        btnRecenter.isHidden = false
    }
    
    func onPan(state: heresdk.GestureState, origin: heresdk.Point2D, translation: heresdk.Point2D, velocity: Double) {
        print("onPan")
        self.app.disableCameraTracking()
        btnRecenter.isHidden = false
    }

   
}
class MyCustomSlider: UISlider {
    override func maximumValueImageRect(forBounds bounds: CGRect) -> CGRect  {
        var r = super.maximumValueImageRect(forBounds: bounds)
        r.origin.x -= 14
        
       
        return r
    }
    override func minimumValueImageRect(forBounds bounds: CGRect) -> CGRect  {
        var l = super.minimumValueImageRect(forBounds: bounds)
        l.origin.x += 14
        return l
    }
  
}
