//
//  OtpOptionVC.swift
//  Alecom
//
//  Created by bd01 on 12/10/22.
//

import UIKit

class OtpOptionVC: UIViewController {

    @IBOutlet var langIcon: UIImageView!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var mobileVerficationLbl: UILabel!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var mobileRadioImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var emailVerificationLbl: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailRadioImg: UIImageView!
    @IBOutlet weak var fotterNoteLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var viewBG: UIView!
    var emailId = ""
    var mobileNo = ""
    var userID = 0
    var isFormEmail = true
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.hideKeyboardWhenTappedAround()
       
        let mobileEndLetters = mobileNo.suffix(3)
        let emailEndLetters = emailId.suffix(13)
        emailLbl.text = "(" + "********" + emailEndLetters + ")"
        mobileLbl.text = "(" + "*******" + mobileEndLetters + ")"


    }
   

    func setUpUI(){
        setUpLanguage()
        fotterNoteLbl.font = MyTheme.myFontRegular(fotterNoteLbl.font.pointSize)
        viewBG.backgroundColor = MyTheme.backGroundDarkRedColor
        submitBtn.titleLabel?.font = MyTheme.myFontMedium(18)
        submitBtn.backgroundColor = MyTheme.buttonBlackBackGroundColor
        mobileLbl.font = MyTheme.myFontMedium(13)
        mobileVerficationLbl.font = MyTheme.myFontMedium(15)
        emailLbl.font = MyTheme.myFontMedium(13)
        emailVerificationLbl.font = MyTheme.myFontMedium(15)
        
    }
    
    func setUpLanguage(){
        let currentLanguage = UserTempData.returnValue(.appCurrentLanguage) as? String
        if currentLanguage == "English"{
            langIcon.image = UIImage(named: "HeaderEnglish")
        }else{
            langIcon.image = UIImage(named: "HeaderIcon")
        }
        submitBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.submit, for: .normal)
        emailVerificationLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.verifyEmail
        mobileVerficationLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.verifySMS
       
        fotterNoteLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func mobileDidClicked(_ sender: UIButton) {
        if sender.tag == 1 {
            isFormEmail = true
            self.emailRadioImg.image = UIImage(named: "radio_s")
            self.mobileRadioImg.image = UIImage(named: "radio_u")
        }else if sender.tag == 2 {
            isFormEmail = false
            self.emailRadioImg.image = UIImage(named: "radio_u")
        self.mobileRadioImg.image = UIImage(named: "radio_s")
        }
    }
    

    @IBAction func submitBtnDidClick(_ sender: Any) {
        if isFormEmail{
            self.sentOneTimePassApi(userId: userID, emailId: emailId, phone: nil)
        }else{
            self.sentOneTimePassApi(userId: userID, emailId: nil, phone: mobileNo)
        }
       
        
       
    }
    
}
