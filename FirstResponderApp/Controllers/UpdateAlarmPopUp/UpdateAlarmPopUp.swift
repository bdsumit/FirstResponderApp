//
//  UpdateAlarmPopUp.swift
//  FirstResponderApp
//
//  Created by bd05 on 1/10/23.
//

import UIKit

class UpdateAlarmPopUp: UIViewController {
    @IBOutlet weak var readMoreLbl: UILabel!
    @IBOutlet weak var detaildLbl: UILabel!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var sideBarView: UIView!
    
    var AlarmListData : [AlarmDataList]?
    var btnReadMoreDidTapped : (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateLbl.text = "\(Date().changeDataFormate(dateInString : (AlarmListData?[0].createdDate ?? ""),formate : DateFormat.formateInApi))"
        self.headerLbl.text = AlarmListData?[0].missionID ?? ""
        self.headerLbl.font = MyTheme.myFontSemiBold(18)
        let floor = AlarmListData?[0].floor ?? ""
        self.detaildLbl.text = "Floor : \(floor)"
        self.sideBarView.backgroundColor = MyTheme.backGroundGreenColor
        
    }
    
    func offsoundAndTorch(){
        BaseClassHelper.sharedInstance.fadeOutSound()
        BaseClassHelper.sharedInstance.flashInloop(isFlashInloop: false)
        BaseClassHelper.sharedInstance.vibrateInLoop(isvibrate: false)
    }

    @IBAction func btnReadMore(_ sender: Any) {
        offsoundAndTorch()
        btnReadMoreDidTapped?()
        self.dismiss(animated: true)
    }
    
    @IBAction func btnCross(_ sender: Any) {
        offsoundAndTorch()
        self.dismiss(animated: true)
    }
    
}
