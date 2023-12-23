//
//  SupportTVC.swift
//  Alecom
//
//  Created by bd01 on 15/09/22.
//

import UIKit

class SupportTVC: UITableViewCell {

    @IBOutlet weak var detailText: UITextField!
    @IBOutlet weak var headingLbl: UILabel!
    
    @IBOutlet weak var Bgview: UIView!
    //   let subjectValues = ["Ask about the app", "Ask about alarm", "Follow -up" , "Miscellaneous"]
    var subjectData : [CustomSubjectList]?
    var gradePicker: UIPickerView!
    var PickerData :((String)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    func setUpPicker() {
        gradePicker = UIPickerView()
        gradePicker.dataSource = self
        gradePicker.delegate = self
        detailText.inputView = gradePicker
        detailText.text = subjectData?[0].subject
    }
    func setUpUI(){
        //Font colour
        
        headingLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        //Font SIze
        detailText.font = MyTheme.myFontMedium(18)
        headingLbl.font = MyTheme.myFontSemiBold(22)
        setUpPicker()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension SupportTVC :  UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return subjectData?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = subjectData?[row].subject
       return row
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        detailText.text = subjectData?[row].subject
        PickerData?(detailText.text ?? "")
       
    }
}
