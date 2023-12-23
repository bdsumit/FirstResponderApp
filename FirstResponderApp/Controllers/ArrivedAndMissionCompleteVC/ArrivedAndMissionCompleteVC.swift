//
//  ArrivedAndMissionCompleteVC.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/22/22.
//

import UIKit
import MapKit
class ArrivedAndMissionCompleteVC: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var recieveAtLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var frontOfVictomView: UIView!
    @IBOutlet weak var completeMissionView: UIView!
    @IBOutlet weak var frontOfVictomLbl: UILabel!
    @IBOutlet weak var completeMission: UILabel!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var therepyView: UIView!
    @IBOutlet weak var callLbl: UILabel!
    @IBOutlet weak var cemeraVideoLbl: UILabel!
    @IBOutlet weak var therepyLbl: UILabel!
    @IBOutlet weak var viewMissionLbl: UILabel!
    @IBOutlet weak var minutesLeft: UILabel!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var mapViewArrive: MKMapView!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var missionView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    func setUpUI(){
        //Font colour
        recieveAtLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        frontOfVictomLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        completeMission.textColor = MyTheme.buttonwhiteBackGroundColor
        viewMissionLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        distanceLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        callLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        cemeraVideoLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        therepyLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        minutesLeft.textColor = MyTheme.buttonwhiteBackGroundColor
        timeRemaining.textColor = MyTheme.buttonwhiteBackGroundColor
        
      
        recieveAtLbl.font = MyTheme.myFontSemiBold(21)
        viewMissionLbl.font = MyTheme.myFontSemiBold(18)
        distanceLbl.font = MyTheme.myFontMedium(18)
        minutesLeft.font = MyTheme.myFontMedium(18)
        timeRemaining.font = MyTheme.myFontMedium(18)
        
        frontOfVictomLbl.font = MyTheme.myFontMedium(16)
        completeMission.font = MyTheme.myFontMedium(16)
        callLbl.font = MyTheme.myFontMedium(15)
        cemeraVideoLbl.font = MyTheme.myFontMedium(15)
        therepyLbl.font = MyTheme.myFontMedium(15)
        // back ground colour
        bgView.backgroundColor = MyTheme.backGroundDarkGrayColor
        headerView.backgroundColor = MyTheme.backGroundDarkRedColor
        callView.backgroundColor = MyTheme.backGroundGreenColor
        missionView.backgroundColor = MyTheme.orangeBgColor
        frontOfVictomView.backgroundColor = MyTheme.backGroundGreenColor
        completeMissionView.backgroundColor = MyTheme.backGroundDarkRedColor
        cameraView.backgroundColor = .clear
        therepyView.backgroundColor = MyTheme.backGroundPurpleColor
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func viewMissionDetail(_ sender: Any) {
        
    }
}
