//
//  SuccessCancelMissionVC.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/21/22.
//

import UIKit

class SuccessCancelMissionVC: UIViewController {
    @IBOutlet weak var topTital: UILabel!
    
    @IBOutlet weak var goBackBtn: UIButton!
    @IBOutlet weak var sucessImg: UIImageView!
    @IBOutlet weak var successMissionMsg: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var footerLbl: UILabel!
    var IsFromSuccess = Bool()
    var doneBtnDidTapped :(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        if IsFromSuccess == true{
            backGroundView.backgroundColor = MyTheme.backGroundGreenColor
            successMissionMsg.text = SetUpAppLanguage.shareInstance.AppLanguageData?.missionComplete
            goBackBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.done, for: .normal)
            topTital.text = SetUpAppLanguage.shareInstance.AppLanguageData?.success
            sucessImg.image = UIImage(named: "right")
        }else{
            backGroundView.backgroundColor = MyTheme.backGroundDarkRedColor
            topTital.isHidden = true
            successMissionMsg.text = SetUpAppLanguage.shareInstance.AppLanguageData?.canceled
            goBackBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.cancel, for: .normal)
            sucessImg.image = UIImage(named: "abort_icon")
        }
        setUpUI()
    }
    func setUpUI(){
        
        //Font colour
        topTital.textColor = MyTheme.buttonwhiteBackGroundColor
        footerLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        successMissionMsg.textColor = MyTheme.buttonwhiteBackGroundColor
        //Font SIze
        topTital.font = MyTheme.myFontMedium(18)
        footerLbl.font = MyTheme.myFontRegular(15)
        successMissionMsg.font = MyTheme.myFontBold(22)
    
        goBackBtn.backgroundColor = MyTheme.buttonwhiteBackGroundColor
    }

    @IBAction func goBackBtnclick(_ sender: Any) {
            offsoundAndTorch()
            doneBtnDidTapped?()
    }
    func offsoundAndTorch(){
        BaseClassHelper.sharedInstance.fadeOutSound()
        BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: false)
        BaseClassHelper.sharedInstance.vibrateInLoop(isvibrate: false)
    }
}
