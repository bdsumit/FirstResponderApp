//
//  AlarmAcceptPopUp.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/22/22.
//

import UIKit
import BonsaiController

class AlarmAcceptPopUp: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var popUpBG: UIView!
    @IBOutlet weak var cancelMissionLbl: UILabel!
    @IBOutlet weak var sureBtn: UILabel!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    var yesBtnDidTapped : (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpLanguage()
    }
    
    func setUpUI(){
        //Font colour
        cancelMissionLbl.textColor = MyTheme.buttonBlackBackGroundColor
        sureBtn.textColor = MyTheme.buttonBlackBackGroundColor
   
        sureBtn.font = MyTheme.myFontRegular(17)
        cancelMissionLbl.font = MyTheme.myFontMedium(20)
        // back ground colour
        noBtn.backgroundColor = MyTheme.backGroundGreenColor
        yesBtn.backgroundColor = MyTheme.backGroundDarkRedColor
        mainView.backgroundColor = .clear
        popUpBG.backgroundColor = MyTheme.buttonwhiteBackGroundColor
    }
    func setUpLanguage(){
        cancelMissionLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.missionCancel
        yesBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.yes, for: .normal)
        noBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.no, for: .normal)
        sureBtn.text = SetUpAppLanguage.shareInstance.AppLanguageData?.missionCancelDesc
    }
    @IBAction func btnCross(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func noBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func yesBtn(_ sender: Any) {
        self.dismiss(animated: true)
        self.yesBtnDidTapped?()
       
    }
}
extension AlarmAcceptPopUp : BonsaiControllerDelegate{
  func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
    return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / (4/1.2)), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / (4/1.2)))
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
      return BonsaiController(fromDirection: .bottom, backgroundColor: UIColor(white: 0, alpha: 0.5), presentedViewController: presented, delegate: self)
    }
}
