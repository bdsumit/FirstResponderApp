//
//  LatLongOnMapVC.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/18/22.
//

import UIKit
import MapKit
class LatLongOnMapVC: UIViewController {

    @IBOutlet weak var mainBGView: UIView!
    @IBOutlet weak var footerLbl: UILabel!
    @IBOutlet weak var latLngMapvc: MKMapView!
    @IBOutlet weak var latituteLbl: UILabel!
    @IBOutlet weak var latValue: UILabel!
    @IBOutlet weak var longLbl: UILabel!
    @IBOutlet weak var longValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI(){
        setUpLanguage()
        //Font colour
        latValue.text = UserTempData.returnValue(.Latitude) as? String
        longValue.text = UserTempData.returnValue(.Longitude) as? String
        
        footerLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        longValue.textColor = MyTheme.buttonwhiteBackGroundColor
        latValue.textColor = MyTheme.buttonwhiteBackGroundColor
        latituteLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        longLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        footerLbl.font = MyTheme.myFontRegular(15)
        longLbl.font = MyTheme.myFontSemiBold(21)
        latituteLbl.font = MyTheme.myFontSemiBold(21)
        latValue.font = MyTheme.myFontSemiBold(21)
        longValue.font = MyTheme.myFontSemiBold(21)
        // back ground colour
        mainBGView.backgroundColor = MyTheme.backGroundDarkGrayColor
    }
    func setUpLanguage() {
        footerLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
        latituteLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.latitudeTitle
        longLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.latitudeTitle
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
