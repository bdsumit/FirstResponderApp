//
//  CreatPasswordVC.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/15/22.
//

import UIKit

class CreatPasswordVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var creatPassLbl: UILabel!
    @IBOutlet var langIcon: UIImageView!
    @IBOutlet weak var resetPassBtn: UIButton!
    @IBOutlet weak var footarLbl: UILabel!
    @IBOutlet weak var viewBG: UIView!
    
    var userId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        confirmPass.delegate = self
        setUpUI()
    }
    func setUpUI(){
        setUpLanguage()
        footarLbl.font = MyTheme.myFontRegular(footarLbl.font.pointSize)
        creatPassLbl.font = MyTheme.myFontMedium(20)
        viewBG.backgroundColor = MyTheme.backGroundDarkRedColor
        resetPassBtn.titleLabel?.font = MyTheme.myFontMedium(18)
        resetPassBtn.backgroundColor = MyTheme.buttonBlackBackGroundColor
    }
    func setUpLanguage(){
        let currentLanguage = UserTempData.returnValue(.appCurrentLanguage) as? String
        if currentLanguage == "English"{
            langIcon.image = UIImage(named: "HeaderEnglish")
        }else{
            langIcon.image = UIImage(named: "HeaderIcon")
        }
        creatPassLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.resetNewpassword
        
        passwordTextField.placeholder = SetUpAppLanguage.shareInstance.AppLanguageData?.password ?? ""
        confirmPass.placeholder = SetUpAppLanguage.shareInstance.AppLanguageData?.confirmPassword ?? ""
        resetPassBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.resetPasswordButton, for: .normal)
        footarLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
    }

    @IBAction func resetPassswordBtn(_ sender: Any) {
        self.view.endEditing(true)
        if passwordTextField.text == ""{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.passwordNotlessThen6 ?? "")
        }else  if passwordTextField.text?.count ?? 0 < 6{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.passwordNotlessThen6 ?? "")
        }else if confirmPass.text == ""{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.passwordNotlessThen6 ?? "")
        }else if confirmPass.text?.count ?? 0 < 6{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.passwordNotlessThen6 ?? "")
        }else if passwordTextField.text != confirmPass.text{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.resetPaswordNotMatch ?? "")
        }else{
            // api call update user password
            updateUserPassApi()
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
