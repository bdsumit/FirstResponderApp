//
//  LoginBtnTVC.swift
//  Alecom
//
//  Created by bd01 on 06/09/22.
//

import UIKit

class LoginBtnTVC: UITableViewCell {
    
    @IBOutlet weak var loginBTN: UIButton!
    @IBOutlet weak var contactBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    var LoginBtn : (()->())?
    var contactCallBack : (()->())?
    var forgotPasswordClicked : (()->())?
    var assesView = UIViewController()
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setUpUI(){
        setUpLanguage()
        loginBTN.titleLabel?.font = MyTheme.myFontMedium(18)
        forgotBtn.titleLabel?.font = MyTheme.myFontMedium(18)
        contactBtn.titleLabel?.font = MyTheme.myFontMedium(18)
        loginBTN.backgroundColor = MyTheme.buttonBlackBackGroundColor
        contactBtn.backgroundColor = MyTheme.buttonBlackBackGroundColor
        forgotBtn.backgroundColor = MyTheme.buttonBlackBackGroundColor
        //print(MyTheme.myStrings.ok)
    }
    func setUpLanguage(){
        loginBTN.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.login, for: .normal)
        forgotBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.forgotPassword, for: .normal)
        contactBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.register, for: .normal)
    }
    
    @IBAction func loginBtnClick(_ sender: Any) {
        LoginBtn?()
    }
    

    @IBAction func forgotPasswordBtnClick(_ sender: Any) {
        forgotPasswordClicked?()
//       
    }
    
    @IBAction func contactSupportBtnClick(_ sender: Any) {
        contactCallBack?()
       }
}


