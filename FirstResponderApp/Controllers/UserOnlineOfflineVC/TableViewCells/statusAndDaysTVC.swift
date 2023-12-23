//
//  statusAndDaysTVC.swift
//  FirstResponderApp
//
//  Created by bd10 on 16/11/22.
//

import UIKit

class statusAndDaysTVC: UITableViewCell ,UITextFieldDelegate{

    @IBOutlet weak var availableTimeUnderlineView: UIView!
    @IBOutlet weak var availableTimeTF: UITextField!
    @IBOutlet weak var availableTimeLbl: UILabel!
    @IBOutlet weak var onlineOrStatusView: UIView!
    @IBOutlet weak var offlineView: UIView!
    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var daysOrStatusLbl: UILabel!
    
    var datePicker = UIDatePicker()
    var dateFormatter = DateFormatter()
    var SetUserStatusCallBack : ((String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        timeLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        daysOrStatusLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        timeLbl.font = MyTheme.myFontBold(18)
        daysOrStatusLbl.font = MyTheme.myFontBold(18)
        underLineView.backgroundColor = MyTheme.segmentBgColor
        
        availableTimeLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        availableTimeTF.textColor = MyTheme.buttonwhiteBackGroundColor
        availableTimeLbl.font = MyTheme.myFontBold(15)
        availableTimeTF.font = MyTheme.myFontBold(20)
        availableTimeTF.delegate = self
        setupDatePicker()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setupDatePicker() {
        // Sets up the "button"
       // startTimeTF.text = "Pick a due date"
        availableTimeTF.textAlignment = .center
        
        
        // Removes the indicator of the UITextField
        availableTimeTF.tintColor = UIColor.clear
        
        
        // Specifies intput type
        datePicker.minimumDate = Date()
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

        
        availableTimeTF.inputView = datePicker
        availableTimeTF.inputAccessoryView = toolBar
        
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        availableTimeUnderlineView.backgroundColor = MyTheme.greenColor
    }
    
    @objc func doneClick() {
        dateFormatter.dateFormat = "HH:mm"
       // dateFormatter.timeStyle = .short
        availableTimeTF.text = dateFormatter.string(from: datePicker.date )
        SetUserStatusCallBack?(availableTimeTF.text ?? "")
        print(datePicker.date)
        availableTimeUnderlineView.backgroundColor = MyTheme.buttonBlackBackGroundColor
        availableTimeTF.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        availableTimeTF.resignFirstResponder()
    }
    
    func endTimePickerBtn(_ sender: Any) {
        print("end time picker ")
        
    }
    
}
