//
//  TermsOfUsesVC.swift
//  Alecom
//
//  Created by bd01 on 06/10/22.
//

import UIKit


class TermsOfUsesVC: UIViewController, UITextViewDelegate  {

    @IBOutlet weak var goBackLbl: UILabel!
    @IBOutlet weak var backGroundColour: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var termsTextView: UITextView!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var footerNote: UILabel!
    @IBOutlet weak var aboutAppLbl: UILabel!
    @IBOutlet weak var versionLbl: UILabel!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet var viewBg: UIView!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var aboutView: UIView!
    var TermsData  : [GlobalSettingData]?
    var isClick =  true
    var RegisterUserClicked :(()->())?
    var isfromController = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUi()
        if isfromController == "AboutScreen"{
            circleView.isHidden = true
            subHeadingLbl.isHidden = true
            aboutAppLbl.isHidden = true
            aboutView.isHidden = false
            agreeBtn.isHidden = true
            goBackLbl.isHidden = false
            BaseClassHelper.sharedInstance.GetGlobelSettingApi(self, {GlobelSettingData in
                
                for globelData in GlobelSettingData  ?? [] {
                    if globelData.settingName == "AboutApp"{
                        
                        self.termsTextView.isHidden = true
                        self.versionLbl.isHidden = false
                        
                        self.versionLbl.text  = globelData.settingValue ?? ""
                        self.headingLbl.text  = globelData.displayName
                    }
                }})
        }else{
            goBackLbl.isHidden = true
            termsOfUseApi()
        }
        checkBtn.setImage(UIImage(named: ""), for: .normal)
        agreeBtn.setTitleColor(.gray, for: .normal)
        agreeBtn.isEnabled = false
        agreeBtn.isUserInteractionEnabled = true
        termsTextView.delegate = self

    }

   
    func setUpUi(){
        //MARK: - GetTermsApi
        setUpLanguage()
        goBackLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        goBackLbl.font = MyTheme.myFontMedium(18)
        versionLbl.font = MyTheme.myFontMedium(15)
        versionLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        footerNote.font = MyTheme.myFontMedium(12)
        aboutAppLbl.font = MyTheme.myFontMedium(12)
        headingLbl.font = MyTheme.myFontMedium(22)
        subHeadingLbl.font = MyTheme.myFontMedium(18)
        termsTextView.font = MyTheme.myFontMedium(15)
        aboutView.backgroundColor = MyTheme.backGroundLightGrayColor
        aboutLbl.font = MyTheme.myFontSemiBold(24)
        aboutLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        
        if isfromController == "AboutScreen"{
            backGroundColour.backgroundColor = MyTheme.backGroundDarkGrayColor
        }else{
            backGroundColour.backgroundColor = MyTheme.backGroundDarkRedColor
        }
        
        agreeBtn.backgroundColor = MyTheme.buttonwhiteBackGroundColor
        
    }
    func setUpLanguage(){
        
        agreeBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.next, for: .normal)
        footerNote.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
        // About Screen
        goBackLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.returnSettings
        aboutLbl.text =  SetUpAppLanguage.shareInstance.AppLanguageData?.about
    }
    func setUPApiData(){
        var termsView = ""
        var urlView = ""
       
        for index in 0..<(TermsData?.count ?? 0 ) {
              if TermsData?[index].settingName == "AcceptTermsOfUse"{
//                let aboutLbl =  convertHtmlToStr (value : TermsData?[index].settingValue ?? "")
//                self.aboutAppLbl.text = aboutLbl
                  self.aboutAppLbl.text = TermsData?[index].settingValue ?? ""
              }
              else if TermsData?[index].settingName == "TermsOfUse" {
                termsView = TermsData?[index].settingValue ?? ""
                  
              }
              else if TermsData?[index].settingName == "TermsOfUseHeader" {
               
             //     let headingLbl =  convertHtmlToStr (value : TermsData?[index].settingValue ?? "")
                  self.headingLbl.text = TermsData?[index].settingValue ?? ""
              }
              else if TermsData?[index].settingName == "TermsOfUseSubHeader" {
                
                //  let subheadingLbl =  convertHtmlToStr (value : TermsData?[index].settingValue ?? "")
                  self.subHeadingLbl.text = TermsData?[index].settingValue ?? ""
              }
              else if TermsData?[index].settingName == "WebsiteUrl" {
                urlView = TermsData?[index].settingValue ?? ""
              }
              else{
                print("out of range")
              }
              let attributedString = NSMutableAttributedString(string: self.termsTextView.text ?? "")
              self.termsTextView.linkTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.underlineStyle.rawValue): NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key: Any]?
              self.termsTextView.attributedText = attributedString
              self.termsTextView.text = "\(termsView)\n\n\n\(urlView)"
            }
      }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func checkBtnDidClick(_ sender: Any) {
        if isClick{
            circleView.backgroundColor = .clear
            checkBtn.setImage(UIImage(named: "check"), for: .normal)
            agreeBtn.isEnabled = true
            agreeBtn.setTitleColor(.black, for: .normal)
            agreeBtn.isUserInteractionEnabled = true
            isClick = false
        }
        else{
            circleView.backgroundColor = .white
            agreeBtn.isEnabled = false
            agreeBtn.setTitleColor(.gray, for: .normal)
            checkBtn.setImage(UIImage(named: ""), for: .normal)
            agreeBtn.isUserInteractionEnabled = false
            isClick = true
        }
    }
    @IBAction func agreeBtnDidClick(_ sender: Any) {
      //  UserData.saveData(.isFirstTimeUser, false)
        
        getAcceptTermsOfUseApi()
        
        print("next did click")
    }
//    func convertHtmlToStr (value : String) -> String{
//        let htmlText = value
//        var attributedText = NSAttributedString()
//        if let htmlData = htmlText.data(using: String.Encoding.unicode) {
//            do {
//                 attributedText = try NSAttributedString(data: htmlData, documentAttributes: nil)
//            } catch let e as NSError {
//                print("Couldn't translate \(htmlText): \(e.localizedDescription) ")
//            }
//        }
//        return attributedText.string
//    }
    
}


