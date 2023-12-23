//
//  ProffessionTvCell.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/17/22.
//

import UIKit

class ProffessionTvCell: UITableViewCell {
    @IBOutlet weak var mainBg: UIView!
    @IBOutlet weak var workTxtFld: UITextField!
    
    @IBOutlet weak var crrTypeTxtFld: UITextField!
    @IBOutlet weak var proffessionTxtfld: UITextField!
    
  //  var sendProffessionalData : ((String,String,String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    func setUpUI(){
        //Font colour
        workTxtFld.textColor = MyTheme.buttonwhiteBackGroundColor
        crrTypeTxtFld.textColor = MyTheme.buttonwhiteBackGroundColor
        proffessionTxtfld.textColor = MyTheme.buttonwhiteBackGroundColor
        //Font SIze
        workTxtFld.font = MyTheme.myFontMedium(18)
        crrTypeTxtFld.font = MyTheme.myFontMedium(18)
        proffessionTxtfld.font = MyTheme.myFontMedium(18)
       
        // back ground colour
        mainBg.backgroundColor = MyTheme.backGroundLightGrayColor
        let workPlace = SetUpAppLanguage.shareInstance.AppLanguageData?.workingPlace ?? ""
        let profession = SetUpAppLanguage.shareInstance.AppLanguageData?.proffession ?? ""
        let cprEducation = SetUpAppLanguage.shareInstance.AppLanguageData?.cprEducation ?? ""
        
        workTxtFld.attributedPlaceholder = NSAttributedString(
            string: workPlace,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        proffessionTxtfld.attributedPlaceholder = NSAttributedString(
            string: profession,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        crrTypeTxtFld.attributedPlaceholder = NSAttributedString(
            string: cprEducation,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
//        workTxtFld.delegate = self
//        crrTypeTxtFld.delegate = self
//        proffessionTxtfld.delegate = self
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        sendProffessionalData?(proffessionTxtfld.text ?? "", workTxtFld.text ?? "", crrTypeTxtFld.text ?? "")
//    }
    
}
