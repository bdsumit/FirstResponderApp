//
//  UserOnlineOfflineVC.swift
//  FirstResponderApp
//
//  Created by bd10 on 16/11/22.
//

import UIKit
import BonsaiController

class UserOnlineOfflineVC: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var copyRightNoteLbl: UILabel!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var yourScheduleAddBtn: UIButton!
    @IBOutlet weak var yourScheduleLbl: UILabel!
    @IBOutlet weak var yourScheduleView: UIView!
    @IBOutlet weak var onlineOfflineLbl: UILabel!
    @IBOutlet weak var onlineOfflineView: UIView!
    @IBOutlet weak var userOnlineOfflineTable: UITableView!
    @IBOutlet weak var segmentCntrl: UISegmentedControl!
    
    var isOnline = "" //Bool()
    var status = UserPersonalDetail.fetchUserDetail()?.status
    var daysArr = ["Mon","Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var getAvailabilityData : [AvailableOpeningHour]?
    var filteredAvailabilityData : [AvailableOpeningHour]?
    var getUserStatusData : UserStatus?
    var updateAvailabilityValues = [updateAvailabilityParams]()
    var Alarmdetail : [AlarmDataList]?
    var sendSelectedDay = ""
    var offlineStatusDuration = ""
    var startTime = ""
    var endTime = ""
    
    @IBOutlet weak var bgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpColorAndFont()
        setUpLanguage()
        
        NotificationCenter.default.addObserver(self,selector:#selector(UpdateOnlineUserStatus(_:)),name: NSNotification.Name("ONLINE"),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(UpdateOfflineUserStatus(_:)),name: NSNotification.Name("OFFLINE"),object: nil)
        
    }
    func setUpLanguage(){
        segmentCntrl.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.statusTab1Text, forSegmentAt: 0)
        segmentCntrl.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.statusTab2Text, forSegmentAt: 1)
        yourScheduleLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.yourSchedule
        yourScheduleAddBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.add, for: .normal)
        copyRightNoteLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
        
        BaseClassHelper.sharedInstance.GetGlobelSettingApi(self, { globelSettingData in
            for globelData in globelSettingData ?? []{
                if globelData.settingName == "OfflineStatusDuration"{
                    self.offlineStatusDuration = globelData.settingValue ?? ""
                    self.getuserAlarmList()
                    self.setUpColorAndFont()
                }
            }
        })
    }
   func getuserAlarmList(){
        BaseClassHelper.sharedInstance.GetUserAlarmListApi(self, {userAlarmlistdata  , EquipmentDetail in
            self.Alarmdetail = userAlarmlistdata
        })
    }
    @objc func UpdateOnlineUserStatus(_ notification: Notification){
        let sendStatus = "ONLINE"
        BaseClassHelper.sharedInstance.updateUserStatusApi(status: sendStatus, self, {successStatus in
            if successStatus == true{
            self.getUserStatusApi()
            }
            
        })
    }
    @objc func UpdateOfflineUserStatus(_ notification: Notification){
        let sendStatus = "OFFLINE"
        BaseClassHelper.sharedInstance.updateUserStatusApi(status: sendStatus, self, {successStatus in
            if successStatus == true{
            self.getUserStatusApi()
            }
        })
    }

    func setUpColorAndFont(){
        //MARK: - getAvailabilityApi call :-
        getAvailabilityApi()
    
        userOnlineOfflineTable.delegate = self
        userOnlineOfflineTable.dataSource = self
        
        //registering cells here
        userOnlineOfflineTable.register(UINib(nibName: "statusAndDaysTVC", bundle: nil), forCellReuseIdentifier: "statusAndDaysTVC")
        bgView.backgroundColor =  MyTheme.backGroundDarkGrayColor
        
        
        //segment color change
        segmentCntrl.backgroundColor = .clear
        segmentCntrl.selectedSegmentTintColor = MyTheme.segmentBgColor
        segmentCntrl.setTitleTextAttributes([NSAttributedString.Key.font: MyTheme.myFontBold(18),.foregroundColor: MyTheme.buttonwhiteBackGroundColor], for: .selected)
        segmentCntrl.setTitleTextAttributes([NSAttributedString.Key.font: MyTheme.myFontBold(18), .foregroundColor: MyTheme.buttonwhiteBackGroundColor], for: .normal)
        
        //remove cornor of segment
        self.segmentCntrl.layer.cornerRadius = 0.0
        self.segmentCntrl.layer.masksToBounds = true
        
        //color and font of the controller
        yourScheduleView.isHidden = true
        onlineOfflineView.backgroundColor = MyTheme.greenColor
        onlineOfflineLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        onlineOfflineLbl.font = MyTheme.myFontBold(20)
        underLineView.backgroundColor = MyTheme.segmentBgColor
        copyRightNoteLbl.font = MyTheme.myFontRegular(copyRightNoteLbl.font.pointSize)
        
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func segmentClickedBtn(_ sender: Any) {
        //hide show views of online/ offline and your schedule
        if segmentCntrl.selectedSegmentIndex == 0{
            yourScheduleView.isHidden = true
            onlineOfflineView.isHidden = false
        }else{
            yourScheduleView.isHidden = false
            onlineOfflineView.isHidden = true
            yourScheduleLbl.textColor = MyTheme.buttonwhiteBackGroundColor
            yourScheduleLbl.font = MyTheme.myFontBold(18)
        }
        userOnlineOfflineTable.reloadData()
    }
    @IBAction func yourScheduleAddBtn(_ sender: Any) {
        
        let vc = AddYourScheduleVC(nibName: "AddYourScheduleVC", bundle: nil)
        vc.transitioningDelegate = self
        vc.getAvailabilityData = self.filteredAvailabilityData ?? []
        vc.sendSaveBtnValues = { [weak self] (saveBtnValues) in
            guard let self = self else{ return}
            print(saveBtnValues)
            self.getAvailabilityApi()
        }
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
    }
    //getting days in swedish
    func daysInSwedish(dayInEnglish : String) -> String{
        switch dayInEnglish {
        case "Mon":
            return "Mån"
        case "Tue":
            return "Tis"
        case "Wed":
            return "Ons"
        case "Thu":
            return "Tors"
        case "Fri":
            return "Fre"
        case "Sat":
            return "lör"
        default:
            return "sön"
        }
    }
    
    func sortWeekDays(weekDay : String){
       // var weekDayNumbers = (Mon : Int(), Tue: Int(), Wed: Int(), Thu: Int(), Fri: Int(), Sat: Int(), Sun: Int())
        let weekDayNumbers = ["Sun": 0,"Mon": 1,"Tue": 2,"Wed": 3,"Thu": 4,"Fri": 5,"Sat": 6,]
        
        print(weekDayNumbers)
    }
    
    @objc func switchOnOffClicked(sender:UISwitch)
    {
        if segmentCntrl.selectedSegmentIndex == 0 {
            var sendStatus = ""
            if sender.isOn{
                sendStatus = "ONLINE"
                BaseClassHelper.sharedInstance.updateUserStatusApi(status: sendStatus, self, {successStatus in
                    self.getUserStatusApi()
                })
            }else{
                
                    //MARK: - CHECK FOR ACTIVE ALARM AND Logout Api call
                    if Alarmdetail?[0].alarmStatus == "Active Alarm" || Alarmdetail?[0].alarmStatus == "Arrived" ||  Alarmdetail?[0].alarmStatus == "Accept" ||  Alarmdetail?[0].alarmStatus == "Pending"  ||  Alarmdetail?[0].alarmStatus == "Equipment Picked"{
                        
                        let offlineAbortAlert = SetUpAppLanguage.shareInstance.AppLanguageData?.offlineAbortAlertMsg
                        let ok = SetUpAppLanguage.shareInstance.AppLanguageData?.ok
                        let cancel = SetUpAppLanguage.shareInstance.AppLanguageData?.cancel
                        let alertController = UIAlertController(title: "", message: offlineAbortAlert , preferredStyle: .alert)
                         // Create the actions
                        let okAction = UIAlertAction(title: ok, style: UIAlertAction.Style.default) {
                             UIAlertAction in
                            sendStatus = "OFFLINE"
                            BaseClassHelper.sharedInstance.updateUserStatusApi(status: sendStatus, self, {successStatus in
                                self.getUserStatusApi()
                                self.SetUserStatusApi(startTime: self.startTime, endTime: self.endTime)
                            })
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
                    }else{
                        sendStatus = "OFFLINE"
                        BaseClassHelper.sharedInstance.updateUserStatusApi(status: sendStatus, self, {successStatus in
                            let date = NSDate()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm"
                            self.startTime = dateFormatter.string(from: date as Date)
                            let offlineStatusDuration = Int(self.offlineStatusDuration) ?? 0
                            
                            
                            let calendar = Calendar.current
                            let timeAfterAdded = calendar.date(byAdding: .minute, value: offlineStatusDuration, to: date as Date)

                            self.endTime = dateFormatter.string(from: (timeAfterAdded ?? Date()) as Date)
                            
                            UserTempData.saveData(.getOnlineTime, self.endTime)
                            self.getUserStatusApi()
                            self.SetUserStatusApi(startTime: self.startTime, endTime: self.endTime)
                        })
                    }
            }
        }else{
            print(sender.tag)
            //isavailability false , send same model
            
            let startTime = filteredAvailabilityData?[sender.tag].startTime
            let endTime = filteredAvailabilityData?[sender.tag].endTime
            let dayInEnglish = filteredAvailabilityData?[sender.tag].weekDaysEngLish ?? ""
            var isTrue = filteredAvailabilityData?[sender.tag].isAvailable
            if  isTrue == true{
                isTrue = false
                filteredAvailabilityData?[sender.tag].isAvailable = isTrue
            }else{
                isTrue = true
                filteredAvailabilityData?[sender.tag].isAvailable = isTrue
            }
            updateAvailabilityValues.append(updateAvailabilityParams(userId: UserPersonalDetail.fetchUserDetail()?.userID,weekDaysEngLish : dayInEnglish,weekDaysSwedish: daysInSwedish(dayInEnglish: dayInEnglish), startTime: startTime,endTime: endTime,isAvailable: isTrue))
            updateAvailabilityApi(updateAvailabilityParams: updateAvailabilityValues)
        }
        
        userOnlineOfflineTable.reloadData()
    }
}
extension UserOnlineOfflineVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentCntrl.selectedSegmentIndex == 0{
            return 1
        }else{
            return filteredAvailabilityData?.count ?? 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userOnlineOfflineTable.dequeueReusableCell(withIdentifier: "statusAndDaysTVC", for: indexPath) as! statusAndDaysTVC
        if segmentCntrl.selectedSegmentIndex == 0{

//            let date = NSDate()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "HH:mm"
//            startTime = dateFormatter.string(from: date as Date)
//            let offlineStatusDuration = Int(offlineStatusDuration) ?? 0
//
//
//            let calendar = Calendar.current
//            let timeAfterAdded = calendar.date(byAdding: .minute, value: offlineStatusDuration, to: date as Date)
//
//            endTime = dateFormatter.string(from: (timeAfterAdded ?? Date()) as Date)
           
           
            cell.SetUserStatusCallBack = {[weak self] (endTimeSelected) in
                guard let self = self else{return}
                self.endTime = endTimeSelected
                UserTempData.saveData(.getOnlineTime, self.endTime)
                self.SetUserStatusApi(startTime: self.startTime, endTime: endTimeSelected)
            }
         //   UserTempData.saveData(.getOnlineTime, endTime)            // save offline Time
            cell.timeLbl.isHidden = true
            cell.availableTimeLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.availableTime
            cell.daysOrStatusLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.activeOnOff
            cell.switchBtn.addTarget(self,action:#selector(switchOnOffClicked),for:.touchUpInside)
            
            if isOnline == "ONLINE"{
                cell.offlineView.isHidden = true
                cell.underLineView.isHidden = false
                cell.switchBtn.isOn = true
            }else{
                cell.underLineView.isHidden = true
                cell.switchBtn.isOn = false
                
                // Get Todays Day
                let Todaydate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE"
                let TodaysDay = dateFormatter.string(from: Todaydate)
                
                if let FilterdDay = filteredAvailabilityData?.filter({$0.weekDaysEngLish == TodaysDay}), FilterdDay.count > 0 {
                    cell.offlineView.isHidden = true
                    UserTempData.saveData(.todayInCalender, "true")
                }else{
                    UserTempData.saveData(.todayInCalender, "false")
                    cell.offlineView.isHidden = false
                    let getOnlineTime = UserTempData.returnValue(.getOnlineTime) as? String
                    cell.availableTimeTF.text = getOnlineTime
                }
                
            }
        }else{
            cell.offlineView.isHidden = true
            cell.daysOrStatusLbl.text = filteredAvailabilityData?[indexPath.row].weekDaysEngLish
//<---------------- call the function sortWeekDays here ---------------->
            sortWeekDays(weekDay: filteredAvailabilityData?[indexPath.row].weekDaysEngLish ?? "")
            cell.timeLbl.isHidden = false
            cell.timeLbl.text = "\(filteredAvailabilityData?[indexPath.row].startTime ?? "") - \(filteredAvailabilityData?[indexPath.row].endTime ?? "")"
            let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
            cell.switchBtn.tag = indexPath.row
            cell.switchBtn.addTarget(self,action:#selector(switchOnOffClicked),for:.touchUpInside)
            
            if filteredAvailabilityData?[indexPath.row].isAvailable == true{
                cell.switchBtn.isOn = true
            }else{
                cell.switchBtn.isOn = false
            }
            if (indexPath.row == lastRowIndex - 1) {
                cell.underLineView.isHidden = true
            }else{
                cell.underLineView.isHidden = false
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        if segmentCntrl.selectedSegmentIndex == 1 {
            let editAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                // Your Call Here
                print("Edit clicked")
                let vc = AddYourScheduleVC(nibName: "AddYourScheduleVC", bundle: nil)
                
                //clouser function to get savebtnvalues
                vc.sendSaveBtnValues = { [weak self] (saveBtnValues) in
                    guard let self = self else{ return}
                    print(saveBtnValues)
                    self.getAvailabilityApi()
                }
                
                self.sendSelectedDay = self.filteredAvailabilityData?[indexPath.row].weekDaysEngLish ?? ""
                vc.transitioningDelegate = self
                vc.selectedDaysArr = [self.sendSelectedDay]
                vc.modalPresentationStyle = .custom
                self.present(vc, animated: true, completion: nil)
                success(true)
            })
            editAction.image = UIImage(named: "edit_icon")
            editAction.backgroundColor = MyTheme.orangeColor
            
            let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                // Your Call Here
                print("delete clicked")
                let sureDeleteCalEntry = SetUpAppLanguage.shareInstance.AppLanguageData?.sureFordelete
                let ok = SetUpAppLanguage.shareInstance.AppLanguageData?.ok
                let cancel = SetUpAppLanguage.shareInstance.AppLanguageData?.cancel
                let alertController = UIAlertController(title: "", message: sureDeleteCalEntry, preferredStyle: .alert)

                 // Create the actions
                let okAction = UIAlertAction(title: ok, style: UIAlertAction.Style.default) {
                     UIAlertAction in
                    // delete api
                    print(updateAvailabilityParams(userId: UserPersonalDetail.fetchUserDetail()?.userID,weekDaysEngLish : self.filteredAvailabilityData?[indexPath.row].weekDaysEngLish ?? "",weekDaysSwedish: self.daysInSwedish(dayInEnglish: self.filteredAvailabilityData?[indexPath.row].weekDaysEngLish ?? ""), startTime: "00:00",endTime: "00:00",isAvailable: false))
                    
                    self.updateAvailabilityApi(updateAvailabilityParams: [updateAvailabilityParams(userId: UserPersonalDetail.fetchUserDetail()?.userID,weekDaysEngLish : self.filteredAvailabilityData?[indexPath.row].weekDaysEngLish ?? "",weekDaysSwedish: self.daysInSwedish(dayInEnglish: self.filteredAvailabilityData?[indexPath.row].weekDaysEngLish ?? ""), startTime: "00:00",endTime: "00:00",isAvailable: false)])
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
            
                success(true)
            })
            deleteAction.image = UIImage(named: "delete_icon")
            deleteAction.backgroundColor = MyTheme.redColor
            
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        }
        return UISwipeActionsConfiguration(actions: [])
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
