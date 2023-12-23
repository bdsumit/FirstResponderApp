//
//  UpdateProfilePopUp.swift
//  FirstResponderApp
//
//  Created by bd05 on 12/12/22.
//

import UIKit

class UpdateProfilePopUp: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var mobileTxt: UITextField!
    
    @IBOutlet weak var bottomViuew: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var proffessionTxtFld: UITextField!
    
    @IBOutlet weak var workSpaceTxtFld: UITextField!
    
    @IBOutlet weak var CrrTypeTxtFld: UITextField!
    var storeProfileData = updateUserDetailsParams(userId: "\(UserPersonalDetail.fetchUserDetail()?.userID ?? 0)", Phone: "", fName: "", lName: "", email: "", proffession: "", workplace: "", cprEductaion: "", password: nil, countryCode: "",confPass: "")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()

        firstName.text = UserTempData.returnValue(.UpdatedfirstName) as? String
        lastname.text = UserTempData.returnValue(.UpdatedLastName) as? String
        mobileTxt.text = UserTempData.returnValue(.UpdatedMobNum) as? String
        proffessionTxtFld.text = UserTempData.returnValue(.UpdatedProfession) as? String
        workSpaceTxtFld.text = UserTempData.returnValue(.UpdatedworkSpace) as? String
        CrrTypeTxtFld.text = UserTempData.returnValue(.UpdatedCPR) as? String
    }
    func setUpUI(){
        //Font colour
        lastname.textColor = MyTheme.buttonwhiteBackGroundColor
        firstName.textColor = MyTheme.buttonwhiteBackGroundColor
        mobileTxt.textColor = MyTheme.buttonwhiteBackGroundColor
        proffessionTxtFld.textColor = MyTheme.buttonwhiteBackGroundColor
        workSpaceTxtFld.textColor = MyTheme.buttonwhiteBackGroundColor
        CrrTypeTxtFld.textColor = MyTheme.buttonwhiteBackGroundColor
        //Font SIze
        firstName.font = MyTheme.myFontMedium(18)
        lastname.font = MyTheme.myFontRegular(18)
        mobileTxt.font = MyTheme.myFontMedium(18)
        proffessionTxtFld.font = MyTheme.myFontMedium(18)
        workSpaceTxtFld.font = MyTheme.myFontMedium(18)
        CrrTypeTxtFld.font = MyTheme.myFontMedium(18)
        // back ground colour
        bgView.backgroundColor = MyTheme.buttonwhiteBackGroundColor
        topView.backgroundColor = MyTheme.backGroundDarkGrayColor
        bottomViuew.backgroundColor = MyTheme.backGroundDarkGrayColor
    }


    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
