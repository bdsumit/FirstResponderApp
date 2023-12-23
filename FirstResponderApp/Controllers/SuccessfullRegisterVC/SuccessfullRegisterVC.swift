//
//  SuccessfullRegisterVC.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/15/22.
//

import UIKit

class SuccessfullRegisterVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var RegCompleteTxt: UILabel!
    @IBOutlet weak var usermailLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var fotterNoteLbl: UILabel!
    var email = ""
    var SuccessMsg =  ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usermailLbl.text =   "Username : \(email)"
     //   RegCompleteTxt.text = SuccessMsg
        BaseClassHelper.sharedInstance.GetGlobelSettingApi(self, {GlobelSetting in
            for globelData in GlobelSetting  ?? []{
                if globelData.settingName == "RegistrationCompleteHeader"{
                    self.RegCompleteTxt.text = globelData.settingValue
                }
                if globelData.settingName == "RegistrationCompleteText"{
                    self.descriptionLbl.text = globelData.settingValue
                }
                    
            }
            
            
           
        })
       
        setUpUI()
    }
    
    func setUpUI(){
        setUpLanguage()
        fotterNoteLbl.font = MyTheme.myFontRegular(fotterNoteLbl.font.pointSize)
        RegCompleteTxt.font = MyTheme.myFontMedium(22)
        bgView.backgroundColor = MyTheme.backGroundDarkRedColor
        btnSignIn.titleLabel?.font = MyTheme.myFontMedium(18)
        btnSignIn.backgroundColor = MyTheme.buttonBlackBackGroundColor
        descriptionLbl.font = MyTheme.myFontMedium(18)
        usermailLbl.font = MyTheme.myFontMedium(18)
    }
    
    func setUpLanguage(){
        btnSignIn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.login, for: .normal)
        fotterNoteLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
    }
    @IBAction func btnSignIn(_ sender: Any) {
        let vc = LoginVC(nibName: "LoginVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
