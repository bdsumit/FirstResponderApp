//
//  PasswordTxtFld.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/17/22.
//

import UIKit

class PasswordTxtFld: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var bGView: UIView!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var confPassTxtFld: UITextField!
    
    var sendPassword : ((String,String)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    func setUpUI(){
        //Font colour
        passwordTxtFld.textColor = MyTheme.buttonwhiteBackGroundColor
        confPassTxtFld.textColor = MyTheme.buttonwhiteBackGroundColor
        
        passwordTxtFld.delegate = self
        confPassTxtFld.delegate = self
      
        //Font SIze
        passwordTxtFld.font = MyTheme.myFontMedium(18)
        confPassTxtFld.font = MyTheme.myFontMedium(18)
        let password = SetUpAppLanguage.shareInstance.AppLanguageData?.password ?? ""
        let confirmPassword = SetUpAppLanguage.shareInstance.AppLanguageData?.confirmPassword ?? ""

        passwordTxtFld.attributedPlaceholder = NSAttributedString(
            string: password,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        confPassTxtFld.attributedPlaceholder = NSAttributedString(
            string: confirmPassword,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
       
        // back ground colour
        bGView.backgroundColor = MyTheme.backGroundLightGrayColor
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        sendPassword?((passwordTxtFld.text ?? ""),(confPassTxtFld.text ?? ""))
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        var finalPassword = ""
//        if passwordTxtFld.text ?? "" == confPassTxtFld.text ?? ""{
//            finalPassword = passwordTxtFld.text ?? ""
//            sendPassword?(finalPassword)
//        }else{
//            onShowAlertController(title: <#T##String?#>, message: <#T##String?#>)
//        }
//        
//    }
    
}
