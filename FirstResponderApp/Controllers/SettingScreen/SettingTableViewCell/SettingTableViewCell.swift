//
//  SettingTableViewCell.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/16/22.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var settingTxt: UILabel!
    @IBOutlet weak var switchCase: UISwitch!
    
    var sendSwitchBtnValue : ((Bool)->())?
    var getUserSettingData  : UserSettingDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        
    }
    func setUpUI(){
        //Font colour
        settingTxt.textColor = MyTheme.buttonwhiteBackGroundColor
        //Font SIze
        settingTxt.font = MyTheme.myFontMedium(18)
        sepratorView.backgroundColor = MyTheme.backGroundwhiteGrayColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func checkBtnOnOff(){
        
        switch switchCase.tag {
        case 2:
            if getUserSettingData?.muteNavigation == true{
                switchCase.isOn = true
            }else{
                switchCase.isOn = false
            }
        case 3:
            if getUserSettingData?.vibrate == true{
                switchCase.isOn = true
            }else{
                switchCase.isOn = false
            }
        case 4:
            if getUserSettingData?.alarmSound == true{
                switchCase.isOn = true
            }else{
                switchCase.isOn = false
            }
        case 5:
            if getUserSettingData?.alarmFlash == true{
                switchCase.isOn = true
            }else{
                switchCase.isOn = false
            }
        case 6:
            if getUserSettingData?.showStatusSilentNotification == true{
                switchCase.isOn = true
            }else{
                switchCase.isOn = false
            }
        default:
            print("ok")
        }
        
    }
    
    @IBAction func switchBtnPressed(_ sender: Any) {
        BaseClassHelper.sharedInstance.fadeOutSound()
        if switchCase.isOn{
            sendSwitchBtnValue?(true)
        }else{
            sendSwitchBtnValue?(false)
        }
    }
}
