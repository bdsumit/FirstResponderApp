//
//  LanguageScreen.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/17/22.
//

import UIKit

class LanguageScreen: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var goBackLbl: UILabel!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var settingLbl: UILabel!
    @IBOutlet weak var swidishLbl: UILabel!
    @IBOutlet weak var englishLbl: UILabel!
    @IBOutlet weak var footerLbl: UILabel!
    @IBOutlet weak var swidishToggle: UISwitch!
    @IBOutlet weak var seprationView: UIView!
    @IBOutlet weak var englishToggle: UISwitch!
    
    var sendLanguageSelected : ((Bool)->())?
    
    var languageSelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if languageSelected == "English"{
            englishToggle.isOn = true
            swidishToggle.isOn = false
        }else if languageSelected == "Swedish"{
            englishToggle.isOn = false
            swidishToggle.isOn = true
        }
        setUpUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpLanguage()
    }
    func setUpUI(){
        setUpLanguage()
        //Font colour
        goBackLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        footerLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        settingLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        swidishLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        englishLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        //Font SIze
        goBackLbl.font = MyTheme.myFontMedium(18)
        swidishLbl.font = MyTheme.myFontMedium(18)
        englishLbl.font = MyTheme.myFontMedium(18)
        footerLbl.font = MyTheme.myFontRegular(15)
        settingLbl.font = MyTheme.myFontBold(24)
        // back ground colour
        languageView.backgroundColor = MyTheme.backGroundLightGrayColor
        bgView.backgroundColor = MyTheme.backGroundDarkGrayColor
        seprationView.backgroundColor = MyTheme.backGroundwhiteGrayColor
        
       
    }
    func setUpLanguage(){
        footerLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
        settingLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.settings
        goBackLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.returnSettings
    }
    @IBAction func langaugeBtnSwitch(_ sender: UIButton) {
        if sender.tag == 0{
            //call api here and send swedish
        //    selectLanguageApi(language: "Swedish")
            changeLanguageApi(language: "Swedish")
        }else{
            //call api here and send english
        //    selectLanguageApi(language: "English")
            changeLanguageApi(language: "English")
        }
    }
    

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
