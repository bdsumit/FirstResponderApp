//
//  UserNameTvcell.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/17/22.
//

import UIKit

class UserNameTvcell: UITableViewCell {

    @IBOutlet weak var MainBGview: UIView!
    @IBOutlet weak var usernameTxtFld: UITextField!
    @IBOutlet weak var userLastName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userMobile: UITextField!
    @IBOutlet weak var phoneCode: UILabel!
    var countryCodeDidTap :(()->())?
//    var sendUserDetails : ((String,String,String,String,String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    func setUpUI(){
        //Font colour
        phoneCode.textColor = MyTheme.buttonwhiteBackGroundColor
        usernameTxtFld.textColor = MyTheme.buttonwhiteBackGroundColor
        userLastName.textColor = MyTheme.buttonwhiteBackGroundColor
        userEmail.textColor = MyTheme.buttonwhiteBackGroundColor
        userMobile.textColor = MyTheme.buttonwhiteBackGroundColor
        //Font SIze
        phoneCode.font = MyTheme.myFontMedium(18)
        usernameTxtFld.font = MyTheme.myFontMedium(18)
        userLastName.font = MyTheme.myFontMedium(18)
        userEmail.font = MyTheme.myFontMedium(18)
        userMobile.font = MyTheme.myFontMedium(18)
        // back ground colour
        MainBGview.backgroundColor = MyTheme.backGroundLightGrayColor
        let firstname = SetUpAppLanguage.shareInstance.AppLanguageData?.firstName ?? ""
        let lastname = SetUpAppLanguage.shareInstance.AppLanguageData?.firstName ?? ""
        let email = SetUpAppLanguage.shareInstance.AppLanguageData?.email ?? ""
        let mobile = SetUpAppLanguage.shareInstance.AppLanguageData?.mobileNumber ?? ""
        usernameTxtFld.attributedPlaceholder = NSAttributedString(
            string: firstname,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        userLastName.attributedPlaceholder = NSAttributedString(
            string: lastname,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        userEmail.attributedPlaceholder = NSAttributedString(
            string: email,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        userMobile.attributedPlaceholder = NSAttributedString(
            string: mobile,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )

       
    }

    @IBAction func btnCountryCode(_ sender: Any) {
        countryCodeDidTap?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
