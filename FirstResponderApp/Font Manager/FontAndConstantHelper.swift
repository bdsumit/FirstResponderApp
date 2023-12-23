//
//  FontAndConstantHelper.swift
//  Petara
//
//  Created by bd05 on 8/5/22.
//

import Foundation
import UIKit

class MyTheme{

    class func myFontRegular(_ size: CGFloat) -> UIFont{
        return UIFont(name: "", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    class func myFontMedium(_ size: CGFloat) -> UIFont{
        return UIFont(name: "", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    class func myFontBold(_ size: CGFloat) -> UIFont{
        return UIFont(name: "", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    class func myFontSemiBold(_ size: CGFloat) -> UIFont{
        return UIFont(name: "", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static var backGroundDarkRedColor: UIColor  { return  UIColor(hexFromString: "#B62222", alpha: 1)}
    static var backGroundDarkGrayColor: UIColor  { return  UIColor(hexFromString: "#3B3B3B", alpha: 1)}
    static var backGroundLightGrayColor: UIColor  { return  UIColor(hexFromString: "#48494A", alpha: 1)}
    static var backGroundwhiteGrayColor: UIColor  { return  UIColor(hexFromString: "#8C8C8C", alpha: 1)}
    static var backGroundPurpleColor: UIColor  { return  UIColor(hexFromString: "#6D79B0", alpha: 1)}
    static var mapblueCoor: UIColor  { return  UIColor(hexFromString: "#094DB0", alpha: 1)}
    
    static var backGroundGreenColor: UIColor  { return  UIColor(hexFromString: "#1DBA24", alpha: 1)}
    static var orangeBgColor: UIColor  { return  UIColor(hexFromString: "#F09407", alpha: 1)}

    static var OfflineStatusColor: UIColor  { return  UIColor(hexFromString: "#FAF103", alpha: 1)} 
    static var buttonwhiteBackGroundColor: UIColor { return UIColor(hexFromString: "#FFFFFF", alpha: 1)}
    static var buttonBlackBackGroundColor: UIColor { return UIColor(hexFromString: "#000000", alpha: 1)}
    static var rowBackGroundColor: UIColor { return UIColor(hexFromString: "#004566", alpha: 1)}
    static var redColor: UIColor { return UIColor(hexFromString: "#ff3a3a")}
    static var orangeColor: UIColor { return UIColor(hexFromString: "#f37c00")}
    static var greenColor: UIColor { return UIColor(hexFromString: "#00c168")}
    static var lightGreenColor: UIColor { return UIColor(hexFromString: "#6db45e")}
    static var mustardColor: UIColor { return UIColor(hexFromString: "#ebb42d")}
    static var purpleColor: UIColor { return UIColor(hexFromString: "#72058f")}
    static var SegBgColor: UIColor { return UIColor(hexFromString: "#1a679d")}
    static var yelloColor : UIColor{return UIColor(hexFromString: "#FAF103")}
    static var blueColor : UIColor{return UIColor(hexFromString: "#0579BB")}
    static var segmentBgColor : UIColor{return UIColor(hexFromString: "#8C8C8C")}
    static var alarmTopColor : UIColor{return UIColor(hexFromString: "#CD2121")}
    static var CompressionActiveColor : UIColor{return UIColor(hexFromString: "#8000FF")}

  
}
let enterWorkspace = "Please enter workspace."
var enterProffessional = "Please enter Proffessional tital."
var enterfirstName = "Please enter first name."
var nameTwoDigit = "Firstname must be more than two character"
var lastnameTwoDigit = "Lastname must be more than two character"
var enterLastName = "Please enter last name."
var enterEmail = "Please enter email."
var enterphone = "Please enter phone number."
var mobilenumberValid = "Please enter valid phone number."
var phoneNumberLimit = "Phone number must be greater than 8 digit"
var enterPassword = "Please enter password."
var limitPassword = "Password must be greter than 6 digit"
var enterValidEmail = "Please enter valid email."
var enterConPassword = "Please enter confirm password."
var enterCorrectPassword = "Password and confirm password are not match."
var cprTraining = "Please enter CPR Training."
var SoundbaseUrl = "https://alitisdev.alitis.se/AlecomFirstResponderAPI/"
var fullSound = 1.0
// Alert Messages
    let blankDataMsg = "No records found"
    let serverIssueMsg = "There is some server issue please try after some time."
    let noMedicineMsg = "No medicines found."
    let TDeviceToken = "notificationToken"
    let NoDoctorFound = "No doctor assigned for you!"
    let NoEvents = "You have no events scheduled for today."
    let notificationDict = "NotificationDict"

extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
