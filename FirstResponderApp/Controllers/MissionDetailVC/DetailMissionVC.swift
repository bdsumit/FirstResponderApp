//
//  DetailMissionVC.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/21/22.
//

import UIKit

class DetailMissionVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var footerLbl: UILabel!
    @IBOutlet weak var tableViewDetail: UITableView!
    @IBOutlet weak var segmentControllAlarm: UISegmentedControl!
    var SegmentFirstIConArray = ["info","location","user","phone","emergency","mission"]
    var SegmentScndIConArray = ["user","location","location","phone","emergency","mission"]
    var forPatientOrEquipment = ""
    var UserALarmListData : [AlarmDataList]?   // new data
    var EquipmentListData : EquipmentList?     // new data
    
    var SavedAlarmList : [AlarmDataList]?       // old data
    var savedEquipmentList : EquipmentList?     // old data
    var AlarmDataVisibilityListData : [AlarmDataVisibilityList]?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpLanguage()
        AlarmDataVisibilityListData = UserPersonalDetail.fetchAlarmVisibilityList()
        
        SavedAlarmList =  UserPersonalDetail.fetchAlarmListDetails()
        savedEquipmentList = UserPersonalDetail.fetchEquipmentListDetails()
        
        print(AlarmDataVisibilityListData ?? [])
        
       
        if forPatientOrEquipment == "Equipment"{
            self.segmentControllAlarm.selectedSegmentIndex = 1
        }else{
            self.segmentControllAlarm.selectedSegmentIndex = 0
        }

        segmentControllAlarm.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentControllAlarm.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        tableViewDetail.delegate = self
        tableViewDetail.dataSource = self
        tableViewDetail.register(UINib(nibName: "MissionDetailTvCell", bundle: nil), forCellReuseIdentifier: "MissionDetailTvCell")
        tableViewDetail.register(UINib(nibName: "VictimTvCell", bundle: nil), forCellReuseIdentifier: "VictimTvCell")
        tableViewDetail.register(UINib(nibName: "AlarmAddressTVcell", bundle: nil), forCellReuseIdentifier: "AlarmAddressTVcell")
        
    }
    
    func SetUpData(){
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = DateFormat.dateFormateInApi
        
        let strDate = dateFormater.date(from: UserALarmListData?[0].createdDate ?? "")
        dateFormater.dateFormat = DateFormat.timeFormat
        let dateInDateFrmate = dateFormater.string(from: strDate ?? Date())
      let alarmReicievAt = SetUpAppLanguage.shareInstance.AppLanguageData?.alarmRecievAt ?? ""
        self.headerLbl.text = "\(alarmReicievAt) \(dateInDateFrmate)"
    }

    func setUpUI(){
        SetUpData()
        //Font colour
        footerLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        headerLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        headerLbl.font =  MyTheme.myFontMedium(18)
        footerLbl.font = MyTheme.myFontRegular(15)
        // back ground colour
        bgView.backgroundColor = MyTheme.backGroundDarkGrayColor
        headerView.backgroundColor = MyTheme.backGroundDarkRedColor
    }
    
    func setUpLanguage(){
        segmentControllAlarm.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.alarm, forSegmentAt: 0)
        segmentControllAlarm.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.equipment, forSegmentAt: 1)

        footerLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func abortMissionBtn(_ sender: Any) {
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
                            }}}
                })
            }}
        self.present(vc, animated: true)
    }
    
    @IBAction func segmentControllerDetal(_ sender: Any) {
        tableViewDetail.reloadData()
    }
    
  
    
}

extension DetailMissionVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControllAlarm.selectedSegmentIndex == 0 {
            
            if UserALarmListData?.count ?? 0 >= 0 {
                tableViewDetail.restore()
                return 8
                
            }else{
                
                tableViewDetail.setEmptyMessage(SetUpAppLanguage.shareInstance.AppLanguageData?.noAlarm ?? "")
                return 1
            }
            
        }else{
            
            if savedEquipmentList != nil {
                tableViewDetail.restore()
                return 6
                
            }else{
                tableViewDetail.setEmptyMessage(SetUpAppLanguage.shareInstance.AppLanguageData?.noDefibrillator ?? "")
                return 1
            }
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentControllAlarm.selectedSegmentIndex == 0 {
            
            if indexPath.row == 0 {
                let cell = tableViewDetail.dequeueReusableCell(withIdentifier: "VictimTvCell") as! VictimTvCell
                cell.heartIcon.image = UIImage(named: "RoundBrokenHeart")
                cell.victimLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.getToPatient ?? ""
                return cell
            }else if indexPath.row == 1{
                let cell = tableViewDetail.dequeueReusableCell(withIdentifier: "AlarmAddressTVcell") as! AlarmAddressTVcell
                let ActualDescription = UserALarmListData?[0].alarmDataListDescription ?? ""
                let ActualDecArray = ActualDescription.components(separatedBy:",")
                
                let saveDecription = SavedAlarmList?[0].alarmDataListDescription ?? ""
                let saveDecToArr = saveDecription.components(separatedBy:",")
                
                var descStr : [String]? = []
        
                if let isStreetVisible = AlarmDataVisibilityListData?.filter({$0.fieldName == "Street"}),isStreetVisible[0].isEnable == true{
                    let street = SetUpAppLanguage.shareInstance.AppLanguageData?.street ?? ""
                        descStr?.append("\(street) \(SavedAlarmList?[0].street ?? "")")
                }
                if let isPkVisible = AlarmDataVisibilityListData?.filter({$0.fieldName == "PortKod"}),isPkVisible[0].isEnable == true{
                    descStr?.append(saveDecToArr[0])
                }
                if let isFloorVisible = AlarmDataVisibilityListData?.filter({$0.fieldName == "Floor"}),isFloorVisible[0].isEnable == true{
                    let floor = SetUpAppLanguage.shareInstance.AppLanguageData?.floor ?? ""
                    descStr?.append("\(floor) \(SavedAlarmList?[0].floor ?? "")")
                }
                if let isNameVisible = AlarmDataVisibilityListData?.filter({$0.fieldName == "Name"}),isNameVisible[0].isEnable == true{
                    descStr?.append(saveDecToArr[1])
                }
                if let isZipCodeVisible = AlarmDataVisibilityListData?.filter({$0.fieldName == "ZipCode"}),isZipCodeVisible[0].isEnable == true{
                    let postCode = SetUpAppLanguage.shareInstance.AppLanguageData?.pincode ?? ""
                    descStr?.append("\(postCode) \(SavedAlarmList?[0].zipCode ?? "")")
                }
                if let iscityVisible = AlarmDataVisibilityListData?.filter({$0.fieldName == "City"}),iscityVisible[0].isEnable == true{
                    let city = SetUpAppLanguage.shareInstance.AppLanguageData?.city ?? ""
                    descStr?.append("\(city) \(SavedAlarmList?[0].city ?? "")")
                }
                if let isMuncipalityVisible = AlarmDataVisibilityListData?.filter({$0.fieldName == "Municipality"}),isMuncipalityVisible[0].isEnable == true{
                    let muncipality = SetUpAppLanguage.shareInstance.AppLanguageData?.municipality ?? ""
                    descStr?.append("\(muncipality) \(SavedAlarmList?[0].municipality ?? "")")
                }
                //---------//
       
                var changesStr: [String]? = []
    
                if UserALarmListData?[0].street?.lowercased() ?? "" != SavedAlarmList?[0].street?.lowercased() ?? ""{
                    let street = SetUpAppLanguage.shareInstance.AppLanguageData?.street ?? ""
                    changesStr?.append("\(street) \(UserALarmListData?[0].street ?? "")")
                }
                if UserALarmListData?[0].alarmDataListDescription?.lowercased() != SavedAlarmList?[0].alarmDataListDescription?.lowercased(){
                    changesStr?.append(ActualDecArray[0])
                }
                if UserALarmListData?[0].floor?.lowercased() != SavedAlarmList?[0].floor?.lowercased(){
                    let floor = SetUpAppLanguage.shareInstance.AppLanguageData?.floor ?? ""
                    changesStr?.append("\(floor) \(UserALarmListData?[0].floor ?? "")")
                }
                if UserALarmListData?[0].alarmDataListDescription?.lowercased() != SavedAlarmList?[0].alarmDataListDescription?.lowercased() {
                    changesStr?.append(ActualDecArray[1])
                }
                if  UserALarmListData?[0].zipCode?.lowercased() != SavedAlarmList?[0].zipCode?.lowercased(){
                    let postCode = SetUpAppLanguage.shareInstance.AppLanguageData?.pincode ?? ""
                    changesStr?.append("\(postCode) \(UserALarmListData?[0].zipCode ?? "")")
                }
                if UserALarmListData?[0].city?.lowercased() != SavedAlarmList?[0].city?.lowercased(){
                    let city = SetUpAppLanguage.shareInstance.AppLanguageData?.city ?? ""
                    changesStr?.append("\(city) \(UserALarmListData?[0].city ?? "")")
                }
                if UserALarmListData?[0].municipality?.lowercased() != SavedAlarmList?[0].municipality?.lowercased(){
                    let muncipality = SetUpAppLanguage.shareInstance.AppLanguageData?.municipality ?? ""
                    changesStr?.append("\(muncipality) \(UserALarmListData?[0].municipality ?? "")")
                }
                
                
                let allStr = "\(descStr?.joined(separator: "\n") ?? "")"
                let updateStr = "\(changesStr?.joined(separator: "\n") ?? "")"

                
                let attrStri = NSMutableAttributedString.init(string:allStr)
                let nsRange = NSString(string: allStr)
                        .range(of: updateStr, options: String.CompareOptions.caseInsensitive)
                attrStri.addAttributes([
                    NSAttributedString.Key.backgroundColor: UIColor.yellow
                ], range: nsRange)
                cell.lblPatientDetal.attributedText = attrStri
                
//
//                cell.lblPatientDetal.attributedText = myAttrString
//
//                cell.lblPatientDetal.text = descStr?.joined(separator: "\n")
                
                return cell
            }else{
                let cell = tableViewDetail.dequeueReusableCell(withIdentifier: "MissionDetailTvCell") as! MissionDetailTvCell
                cell.icon.image = UIImage(named: SegmentFirstIConArray[indexPath.row - 2])
                let Description = UserALarmListData?[0].alarmDataListDescription?.lowercased() ?? ""
                let subjectArray = Description.components(separatedBy:",")
                
                let SaveDescription = SavedAlarmList?[0].alarmDataListDescription?.lowercased() ?? ""
                let saveDescription = SaveDescription.components(separatedBy:",")
                
                if indexPath.row == 2 {
                    if Description != SaveDescription{
                        let myString = subjectArray[2]
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.yellow ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }else{
                        let myString = saveDescription[2]
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.white ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                        
                    }
                }else  if indexPath.row == 3 {
                    
                    if UserALarmListData?[0].posLat ?? "" != SavedAlarmList?[0].posLat ?? "" ||  UserALarmListData?[0].posLon  != SavedAlarmList?[0].posLon{
                        
                        
                        let Lattitude = UserALarmListData?[0].posLat ?? ""
                        let Longitude = UserALarmListData?[0].posLon ?? ""
                        let myString = "\(Lattitude) , \(Longitude)"
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.yellow ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }else{
                        let Lattitude = SavedAlarmList?[0].posLat ?? ""
                        let Longitude = SavedAlarmList?[0].posLon ?? ""
                        let myString = "\(Lattitude) , \(Longitude)"
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.white ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }
                }else  if indexPath.row == 4 {
                    if UserALarmListData?[0].firstName?.lowercased() ?? "" != SavedAlarmList?[0].firstName?.lowercased() ?? "" || UserALarmListData?[0].lastName?.lowercased()  != SavedAlarmList?[0].lastName?.lowercased(){
                        let firstName = UserALarmListData?[0].firstName ?? ""
                        let lastName = UserALarmListData?[0].lastName ?? ""
                        
                        let myString = "\(firstName) \(lastName)"
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.yellow ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }else{
                        let firstName = SavedAlarmList?[0].firstName ?? ""
                        let lastName = SavedAlarmList?[0].lastName ?? ""
                        
                        let myString = "\(firstName) \(lastName)"
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.white ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }
                }else  if indexPath.row == 5 {
                    if UserALarmListData?[0].phoneNumber?.lowercased() != SavedAlarmList?[0].phoneNumber?.lowercased(){
                       
                        
                        let myString = UserALarmListData?[0].phoneNumber ?? ""
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.yellow ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }else{
                        let myString = SavedAlarmList?[0].phoneNumber ?? ""
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.white ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                        
                    }
                }else  if indexPath.row == 6{
                    if UserALarmListData?[0].caseType?.lowercased() != SavedAlarmList?[0].caseType?.lowercased(){
                       
                        
                        let myString = UserALarmListData?[0].caseType ?? ""
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.yellow ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }else{
                        let myString = SavedAlarmList?[0].caseType ?? ""
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.white ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }
                    
                }else{
                    if UserALarmListData?[0].missionID?.lowercased() != SavedAlarmList?[0].missionID?.lowercased(){
                        let myString = UserALarmListData?[0].missionID ?? ""
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.yellow ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }else{
                        
                        let myString = SavedAlarmList?[0].missionID ?? ""
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.white ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }
                    
                    
                }
                
                return cell
            }
        }else{
            if indexPath.row == 0 {
                let cell = tableViewDetail.dequeueReusableCell(withIdentifier: "VictimTvCell") as! VictimTvCell
                cell.heartIcon.image = UIImage(named: "RoundDef")
                cell.victimLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.goToEquipmentText ?? ""
                return cell
            }else{
                let cell = tableViewDetail.dequeueReusableCell(withIdentifier: "MissionDetailTvCell") as! MissionDetailTvCell
                cell.icon.image = UIImage(named: SegmentScndIConArray[indexPath.row - 1])
                if indexPath.row == 1 {
                    if EquipmentListData?.owner?.lowercased() != savedEquipmentList?.owner?.lowercased(){
                       
                        
                        let myString = EquipmentListData?.owner ?? ""
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.yellow ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }else{
                        let myString = savedEquipmentList?.owner  ?? ""
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.white ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }
                    
                    
                    
                }else  if indexPath.row == 2 {
                    if EquipmentListData?.address?.lowercased() != savedEquipmentList?.address?.lowercased() || EquipmentListData?.zipCode?.lowercased() != savedEquipmentList?.zipCode?.lowercased() || EquipmentListData?.city?.lowercased() != savedEquipmentList?.city?.lowercased()||EquipmentListData?.floor?.lowercased() != savedEquipmentList?.floor?.lowercased(){
                       
                        let Address = EquipmentListData?.address ?? ""
                        let ZipCode = EquipmentListData?.zipCode ?? ""
                        let City = EquipmentListData?.city ?? ""
                        let floor = EquipmentListData?.floor ?? ""
                        let floortext = SetUpAppLanguage.shareInstance.AppLanguageData?.floor ?? ""
                        let myString = "\(Address), \(ZipCode), \(City) , \(floortext) \(floor)"
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.yellow ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }else{
                        let Address = savedEquipmentList?.address ?? ""
                        let ZipCode = savedEquipmentList?.zipCode ?? ""
                        let City = savedEquipmentList?.city ?? ""
                        let floor = savedEquipmentList?.floor ?? ""
                        let floortext = SetUpAppLanguage.shareInstance.AppLanguageData?.floor ?? ""
                      //  cell.textLbl.text = "\(Address), \(ZipCode), \(City) , \(floortext) \(floor)"
                        
                        let myString = "\(Address), \(ZipCode), \(City) , \(floortext) \(floor)"
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.white ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }
                }else  if indexPath.row == 3 {
                    if EquipmentListData?.posLat != savedEquipmentList?.posLat || EquipmentListData?.posLon != savedEquipmentList?.posLon {
                       
                        let Lattitude = EquipmentListData?.posLat ?? 0.0
                        let Longitude = EquipmentListData?.posLon ?? 0.0
                    
                        let myString = "\(Lattitude) , \(Longitude)"
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.yellow ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }else{
                        let Lattitude = savedEquipmentList?.posLat ?? 0.0
                        let Longitude = savedEquipmentList?.posLon ?? 0.0
                        
                        let myString = "\(Lattitude) , \(Longitude)"
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.white ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }
                    
                    
                    
                }else  if indexPath.row == 4 {
                    if EquipmentListData?.county?.lowercased() != savedEquipmentList?.county?.lowercased(){
                       
                        
                        let myString = EquipmentListData?.county ?? ""
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.yellow ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }else{
                      //  cell.textLbl.text = savedEquipmentList?.county  ?? ""
                        
                        let myString = savedEquipmentList?.county  ?? ""
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.white ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }
                    
                    
                }else{
                    if EquipmentListData?.routeInstructions?.lowercased() != savedEquipmentList?.routeInstructions?.lowercased(){
                       
                        let myString = EquipmentListData?.routeInstructions ?? ""
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.yellow ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }else{
                      //  cell.textLbl.text = savedEquipmentList?.routeInstructions  ?? ""
                        
                        let myString = savedEquipmentList?.routeInstructions  ?? ""
                        let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.white ]
                        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
                        cell.textLbl.attributedText = myAttrString
                    }
                   
                }
                return cell
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if segmentControllAlarm.selectedSegmentIndex == 0 {
           
            if indexPath.row == 2 {
                if let isStreetVisible = AlarmDataVisibilityListData?.filter({$0.fieldName == "Description"}),isStreetVisible[0].isEnable == false {
                
                return 0
            }
            
        }else if indexPath.row == 3 {
            if let isStreetVisible = AlarmDataVisibilityListData?.filter({$0.fieldName == "Alarm Position Coordinates"}),isStreetVisible[0].isEnable == false {
                return 0
            }
        }else if indexPath.row == 4 {
            if let isStreetVisible = AlarmDataVisibilityListData?.filter({$0.fieldName == "Name"}),isStreetVisible[0].isEnable == false {
                return 0
            }
        }else if indexPath.row == 5{
            if let isStreetVisible = AlarmDataVisibilityListData?.filter({$0.fieldName == "PhoneNumber"}),isStreetVisible[0].isEnable == false {
                return 0
            }
        }else if indexPath.row == 6{
            if let isStreetVisible = AlarmDataVisibilityListData?.filter({$0.fieldName == "CaseType"}),isStreetVisible[0].isEnable == false {
                
                return 0
            }
        }else if indexPath.row == 7{
            if let isStreetVisible = AlarmDataVisibilityListData?.filter({$0.fieldName == "MissionId"}),isStreetVisible[0].isEnable == false {
                
                return 0
            }
        }else{
            return UITableView.automaticDimension
        }
        }else{
            if indexPath.row == 1 {
                if EquipmentListData?.owner == nil{
                   return 0
                }
            }else  if indexPath.row == 2 {
                if  EquipmentListData?.address == nil && EquipmentListData?.zipCode == nil && EquipmentListData?.city == nil && EquipmentListData?.floor == nil {
                    return 0
                }
 
            }else  if indexPath.row == 3 {
                if EquipmentListData?.posLat == nil && EquipmentListData?.posLon == nil{
                    return 0
                }
                
            }else  if indexPath.row == 4 {
                if EquipmentListData?.county  == nil{
                    return 0
                }
            }else if indexPath.row == 5{
                if EquipmentListData?.routeInstructions  == nil{
                    return 0
                }
            }else{
                return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentControllAlarm.selectedSegmentIndex == 0 {
            if indexPath.row == 3 {
                self.navigationController?.popViewController(animated: true)
            }else if indexPath.row == 5 {
                // openDailer
                BaseClassHelper.sharedInstance.dialNumber(number: SavedAlarmList?[0].phoneNumber ?? "" )
            }
        }
           
    }
}
