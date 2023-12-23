//
//  LocationPermissionScreen.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/23/22.
//

import UIKit
import CoreLocation
import BonsaiController
class LocationPermissionScreen: UIViewController , CLLocationManagerDelegate{

    @IBOutlet weak var allowTxt: UILabel!
    @IBOutlet weak var mainViewView: UIView!
    @IBOutlet weak var continewBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var textViewPermision: UITextView!
    var btnDidtap :((String,Double, Double)->())?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var Latitude = 0.00
    var Longitude = 0.00
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
         
    }
    func setUpUI(){
        setUpLanguage()
        allowTxt.textColor = MyTheme.buttonBlackBackGroundColor
        allowTxt.font = MyTheme.myFontSemiBold(22)
        mainViewView.backgroundColor = MyTheme.buttonwhiteBackGroundColor
        textViewPermision.font = MyTheme.myFontMedium(18)
        textViewPermision.textColor = MyTheme.buttonBlackBackGroundColor
        cancelBtn.backgroundColor = MyTheme.backGroundDarkRedColor
        continewBtn.backgroundColor = MyTheme.backGroundDarkRedColor
      
    }
    
    func setUpLanguage(){
        allowTxt.text = SetUpAppLanguage.shareInstance.AppLanguageData?.locationPermissionPopupTitle
        continewBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.welcomeContinue, for: .normal)
        cancelBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.cancel, for: .normal)
        textViewPermision.text = SetUpAppLanguage.shareInstance.AppLanguageData?.locationPermissionAlertPopupTitleLabel
    }
    
    func locationAceesPOpup() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        
       
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            guard let currentLocation = locationManager.location else {
                return
            }
            Latitude = currentLocation.coordinate.latitude
            Longitude = currentLocation.coordinate.longitude
     
            UserTempData.saveData(.Latitude, String(Latitude) )
            UserTempData.saveData(.Longitude, String(Longitude))
            print("Latitude = \(currentLocation.coordinate.latitude)")
            print("Longitude = \(currentLocation.coordinate.longitude)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdate")
        if let location: CLLocationCoordinate2D = manager.location?.coordinate {
            print(location.latitude)
            print(location.longitude)
            
            Latitude = location.latitude
           Longitude = location.longitude
     
            UserTempData.saveData(.Latitude, String(location.latitude))
            UserTempData.saveData(.Longitude, String(location.longitude))
            if Latitude != 0.00 {
                btnDidtap?("continue",Latitude ,Longitude)
                self.dismiss(animated: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFail")
        print(error.localizedDescription)
        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
           // self.navigationController?.popViewController(animated: true)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(cAlertAction) in
           // self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func continewBtn(_ sender: Any) {
        locationAceesPOpup()
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
extension LocationPermissionScreen : BonsaiControllerDelegate{
  func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
    return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / (4/1.2)), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / (4/1.2)))
    }
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
      return BonsaiController(fromDirection: .bottom, backgroundColor: UIColor(white: 0, alpha: 0.5), presentedViewController: presented, delegate: self)
    }
}
