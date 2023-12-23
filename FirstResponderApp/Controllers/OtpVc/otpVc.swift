//
//  otpVc.swift
//  Alecom
//
//  Created by bd01 on 12/10/22.
//

import UIKit

class otpVc: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet var langIcon: UIImageView!
    @IBOutlet weak var resendCodeBtn: UIButton!
    @IBOutlet weak var verficationMsgLbl: UILabel!
    @IBOutlet weak var fotterNoteLbl: UILabel!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var viewBG: UIView!
   
    var userId = 0
    var emailID = ""
    var mobileNo = ""
    var sendOtp = 0
    var isFormEmail = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUpUI()
       
        sendOtp = Int(otpTextField.text ?? "" ) ?? 0
        otpTextField.delegate = self
    
    }

    func setUpUI(){
        setUpLanguage()
        fotterNoteLbl.font = MyTheme.myFontRegular(fotterNoteLbl.font.pointSize)
        verficationMsgLbl.font = MyTheme.myFontMedium(18)
        viewBG.backgroundColor = MyTheme.backGroundDarkRedColor
        verifyBtn.titleLabel?.font = MyTheme.myFontMedium(18)
        verifyBtn.backgroundColor = MyTheme.buttonBlackBackGroundColor
        resendCodeBtn.titleLabel?.font = MyTheme.myFontMedium(18)
        resendCodeBtn.backgroundColor = MyTheme.buttonBlackBackGroundColor
        //print(MyTheme.myStrings.ok)
    }
    func setUpLanguage(){
        let currentLanguage = UserTempData.returnValue(.appCurrentLanguage) as? String
        if currentLanguage == "English"{
            langIcon.image = UIImage(named: "HeaderEnglish")
        }else{
            langIcon.image = UIImage(named: "HeaderIcon")
        }
        
        if isFormEmail == true{
            verficationMsgLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.verifyEmailTitle
        }else{
            verficationMsgLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.verifySMSTitle
        }
        otpTextField.placeholder = SetUpAppLanguage.shareInstance.AppLanguageData?.otpCode ?? ""
        verifyBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.verify, for: .normal)
        resendCodeBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.otpResend, for: .normal)
        fotterNoteLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let charsLimit = 6

        let startingLength = otpTextField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace =  range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace

        return newLength <= charsLimit
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func verfifyOtpBtnClick(_ sender: Any) {
        self.view.endEditing(true)
            if otpTextField.text == ""{
                
                showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.otpCode ?? "")
            }else if otpTextField.text?.count ?? 0 < 6{
                
                showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.enterValidOTP ?? "")
            } else{
                //MARK: - checkOneTime Api call
                checkOneTimePassApi()
            }
        
    }
    
    @IBAction func resendOtpBtnClick(_ sender: Any) {
        
        self.view.endEditing(true)
        if isFormEmail{
            sentOneTimePassApi(userId: self.userId, emailId: self.emailID, phone: nil)
        }else{
            sentOneTimePassApi(userId: self.userId, emailId: nil, phone: self.mobileNo)
        }
        
    }
}

