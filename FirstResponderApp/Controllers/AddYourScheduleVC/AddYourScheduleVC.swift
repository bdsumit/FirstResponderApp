//
//  AddYourScheduleVC.swift
//  FirstResponderApp
//
//  Created by bd10 on 17/11/22.
//

import UIKit

class AddYourScheduleVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var endTimeTF: UITextField!
    @IBOutlet weak var startTimeTF: UITextField!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var startTimeUnderlineView: UIView!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var addYourScheduleCV: UICollectionView!
    @IBOutlet weak var chooseDaysLbl: UILabel!
    @IBOutlet weak var addYourScheduleLbl: UILabel!
    
    var timePicker = UIDatePicker()
    var weekdaysArr : [String?] = []
    var selectedValuesArr : [[String : String]] = []
    var selectedDaysArr = [String]()
    var selectedDayInOnOffVC = ""
    var sendSaveBtnValues : (([updateAvailabilityParams])->())?
  //  var filteredAvailabilityData : [AvailableOpeningHour]?
    var updateAvailabilityValues = [updateAvailabilityParams]()
    var getAvailabilityData = [AvailableOpeningHour]()
    var alreadyAvailableWeekdaysArr : [String] = []
    var storeSelectedValues = updateAvailabilityParams(userId: UserPersonalDetail.fetchUserDetail()?.userID, weekDaysEngLish: "", weekDaysSwedish: "", startTime: "", endTime: "", isAvailable: true)
    
    var datePicker = UIDatePicker()
    var textFieldVar = UITextField()
    var startTime = ""
    var endTime = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguage()
        addYourScheduleCV.delegate = self
        addYourScheduleCV.dataSource = self
        addYourScheduleCV.register(UINib(nibName: "weekDaysCV", bundle: nil), forCellWithReuseIdentifier: "weekDaysCV")
        saveBtn.backgroundColor = MyTheme.segmentBgColor
        closeBtn.backgroundColor = MyTheme.segmentBgColor
        
        startTimeTF.delegate = self
        endTimeTF.delegate = self
        setupDatePicker()
    }
    func setUpLanguage(){
        weekdaysArr = ["Mon","Tue","Wed", "Thu", "Fri", "Sat", "Sun"]
//        weekdaysArr = [SetUpAppLanguage.shareInstance.AppLanguageData?.mondayShort , SetUpAppLanguage.shareInstance.AppLanguageData?.tuesdayShort,
//        SetUpAppLanguage.shareInstance.AppLanguageData?.wednesdayShort,SetUpAppLanguage.shareInstance.AppLanguageData?.thursdayShort,SetUpAppLanguage.shareInstance.AppLanguageData?.fridayShort,SetUpAppLanguage.shareInstance.AppLanguageData?.saturdayShort,SetUpAppLanguage.shareInstance.AppLanguageData?.sundayShort]
        addYourScheduleLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.addYourSchedule
        chooseDaysLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.chooseDays
        startTimeLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.addStartTime
        endTimeLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.addEndTime
        saveBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.save, for: .normal)
        closeBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.close, for: .normal)
    }
    
    
    func setupDatePicker() {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        startTime = dateFormatter.string(from: Date())
        endTime = "23:59"
        startTimeTF.text = startTime//dateFormatter.string(from: Date())
        endTimeTF.text = endTime//"23:59"
        
        storeSelectedValues.startTime = startTimeTF.text
        storeSelectedValues.endTime = endTimeTF.text
        print(storeSelectedValues)
        
        // Sets up the "button"
       // startTimeTF.text = "Pick a due date"
        startTimeTF.textAlignment = .center
        endTimeTF.textAlignment = .center
        
        // Removes the indicator of the UITextField
        startTimeTF.tintColor = UIColor.clear
        endTimeTF.tintColor = UIColor.clear
        
        // Specifies intput type
        datePicker.datePickerMode = .time
        
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adds the buttons
        var doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        var spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        
            
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Adds the toolbar to the view
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        startTimeTF.inputView = datePicker
        startTimeTF.inputAccessoryView = toolBar
        
        endTimeTF.inputView = datePicker
        endTimeTF.inputAccessoryView = toolBar
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
    
    //Adding dictonary in array
    func getCompleteArr(){
        for finalArray in selectedDaysArr{
            updateAvailabilityValues.append(updateAvailabilityParams(userId: UserPersonalDetail.fetchUserDetail()?.userID,weekDaysEngLish : finalArray,weekDaysSwedish: daysInSwedish(dayInEnglish: finalArray), startTime: startTime,endTime: endTime,isAvailable: true))
        }
        print(updateAvailabilityValues)
        
    }
    
    @objc func doneClick() {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if textFieldVar == startTimeTF{
            print("start")
            startTimeTF.text = dateFormatter.string(from: datePicker.date)
            startTime = startTimeTF.text ?? ""
            startTimeTF.resignFirstResponder()
        }else{
            print("end")
            endTimeTF.text = dateFormatter.string(from: datePicker.date)
            endTime = endTimeTF.text ?? ""
            endTimeTF.resignFirstResponder()
            
        }
        print(storeSelectedValues)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldVar = textField
    }
    
    @objc func cancelClick() {
        startTimeTF.resignFirstResponder()
        endTimeTF.resignFirstResponder()
    }
    
    func endTimePickerBtn(_ sender: Any) {
        print("end time picker ")
        
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        
        for availableDays in  getAvailabilityData{
            let days = availableDays.weekDaysEngLish ?? ""
            alreadyAvailableWeekdaysArr.append(days)
            print(alreadyAvailableWeekdaysArr)
        }
        let intersection = Array(Set(alreadyAvailableWeekdaysArr).intersection(selectedDaysArr))
        if intersection.count > 0 {
            let calenderEntryFor = SetUpAppLanguage.shareInstance.AppLanguageData?.calenderEntry
            let alraedyExist = SetUpAppLanguage.shareInstance.AppLanguageData?.alreadyExist
            let ok = SetUpAppLanguage.shareInstance.AppLanguageData?.ok
            
            let alertController = UIAlertController(title: "", message: "\(calenderEntryFor ?? "") \(intersection)\(alraedyExist ?? "")", preferredStyle: .alert)

             // Create the actions
            let okAction = UIAlertAction(title: ok, style: UIAlertAction.Style.default) {
                 UIAlertAction in
                self.dismiss(animated: true)
             }
           

             // Add the actions
             alertController.addAction(okAction)

             // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }else{
            //--------------update availability Api Call here -------------->
                    for finalArray in selectedDaysArr{
                        updateAvailabilityValues.append(updateAvailabilityParams(userId: UserPersonalDetail.fetchUserDetail()?.userID,weekDaysEngLish : finalArray,weekDaysSwedish: daysInSwedish(dayInEnglish: finalArray), startTime: startTime,endTime: endTime,isAvailable: true))
                    }
                    print(updateAvailabilityValues)
                    
                    updateAvailabilityApi(updateAvailabilityParams: updateAvailabilityValues)
        }
     }
    @IBAction func closeBtnClicked(_ sender: Any) {
            self.dismiss(animated: true)
        
        }
}
extension AddYourScheduleVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = addYourScheduleCV.dequeueReusableCell(withReuseIdentifier: "weekDaysCV", for: indexPath) as! weekDaysCV
        cell.weekdayNameLbl.text = weekdaysArr[indexPath.row]?.uppercased()
        
//        var selectedDaysFromApi = getAvailabilityData[indexPath.row].weekDaysEngLish ?? ""
//        print(selectedDaysFromApi)
        
        
        if self.selectedDaysArr.contains(weekdaysArr[indexPath.row] ?? ""){
            cell.weekDaysView.backgroundColor = MyTheme.greenColor
        }else{
            cell.weekDaysView.backgroundColor = MyTheme.segmentBgColor
        }
      
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (addYourScheduleCV.frame.width)/4, height: 82)//70)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedDaysArr.contains(weekdaysArr[indexPath.row] ?? ""){
            self.selectedDaysArr.remove(at: self.selectedDaysArr.firstIndex(of: weekdaysArr[indexPath.row] ?? "")!)
            }else{
                self.selectedDaysArr.append(weekdaysArr[indexPath.row] ?? "")
            }
        print(selectedDaysArr)
        addYourScheduleCV.reloadData()
    }
    
    
}
