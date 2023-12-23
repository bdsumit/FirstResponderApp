//
//  DashboardTvCell.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/16/22.
//

import UIKit

class DashboardTvCell: UITableViewCell {

    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userInitials: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var userBG: UIView!
    @IBOutlet weak var msgBg: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var viewSecond: UIView!
    @IBOutlet weak var viewThird: UIView!
    @IBOutlet weak var countOne: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var msgImage: UIImageView!
    @IBOutlet weak var picBgView: UIView!
    @IBOutlet weak var countThree: UILabel!
    @IBOutlet weak var countTwo: UILabel!
    var btnDidClicked :((String)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setUpUI()
    }
    func setUpUI(){
        
//        userName.font = MyTheme.myFontRegular(18)
//        userStatus.font = MyTheme.myFontRegular(18)
        userInitials.font = MyTheme.myFontBold(25)
 //       userName.textColor = MyTheme.buttonwhiteBackGroundColor
       
        countOne.textColor = MyTheme.buttonwhiteBackGroundColor
        countTwo.textColor = MyTheme.buttonwhiteBackGroundColor
        countThree.textColor = MyTheme.buttonwhiteBackGroundColor
        msgLbl.font = MyTheme.myFontRegular(18)
        msgLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        userInitials.textColor = MyTheme.buttonwhiteBackGroundColor
        countOne.font = MyTheme.myFontRegular(15)
        countTwo.font = MyTheme.myFontRegular(15)
        countThree.font = MyTheme.myFontRegular(15)
     //   userBG.backgroundColor = MyTheme.backGroundGreenColor
        msgBg.backgroundColor = MyTheme.backGroundDarkGrayColor
        viewFirst.backgroundColor = MyTheme.backGroundGreenColor
        viewSecond.backgroundColor = MyTheme.orangeBgColor
        viewThird.backgroundColor = MyTheme.backGroundLightGrayColor
        picBgView.backgroundColor = MyTheme.backGroundDarkGrayColor
    }
    @IBAction func userDetailBtn(_ sender: Any) {
        btnDidClicked?("userDetail")
    }
    @IBAction func msgBtn(_ sender: Any) {
        btnDidClicked?("msgDidClick")
    }
}
