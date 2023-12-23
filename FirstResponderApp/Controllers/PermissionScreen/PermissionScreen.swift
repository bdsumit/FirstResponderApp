//
//  PermissionScreen.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/15/22.
//

import UIKit

import AVKit
import CoreLocation
class PermissionScreen: UIViewController , UIViewControllerTransitioningDelegate{
    @IBOutlet weak var bgView: UIView!
    @IBOutlet var langIcon: UIImageView!
    @IBOutlet weak var permissionLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var prmssionTv: UITableView!
    var locationPermissionGranted = Bool()
    var cameraPermissionGranted = Bool()
   // var LoginDidClicked :(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        nextBtn.isEnabled = false
        prmssionTv.delegate = self
        prmssionTv.dataSource = self
        prmssionTv.register(UINib(nibName: "PermissionImageTvCell", bundle: nil), forCellReuseIdentifier: "PermissionImageTvCell")
        prmssionTv.register(UINib(nibName: "AccessPermissionTvCell", bundle: nil), forCellReuseIdentifier: "AccessPermissionTvCell")
    }

    func checkCameraPermission()  {
        let cameraMediaType = AVMediaType.video
        AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    //Do operation
                    print("Granted access for camera")
                  
                    DispatchQueue.main.async {
                        self.cameraPermissionGranted = true
                        self.prmssionTv.reloadData()
                    }
                   
                } else {
                    DispatchQueue.main.async {
                        self.noCameraFound()
                    }
                    print("Denied access for camera ")
                }
            }
        }
        func noCameraFound(){
            let Appname = SetUpAppLanguage.shareInstance.AppLanguageData?.firstResponder ?? ""
            let cameraAccess = SetUpAppLanguage.shareInstance.AppLanguageData?.cameraPermissionPopupTitle ?? ""
            
            let cancel = SetUpAppLanguage.shareInstance.AppLanguageData?.cancel ?? ""
            let alert = UIAlertController(title: "\(Appname)", message:"\(cameraAccess)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "\(cancel)", style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction) in


            }));
            let openSetting =  SetUpAppLanguage.shareInstance.AppLanguageData?.openPermissionSetting ?? ""
            alert.addAction(UIAlertAction(title: "\(openSetting)", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction) in
                UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)

            }));
            self.present(alert, animated: true, completion: nil)
        }
    func setUpUI(){
        setUpLanguage()
        permissionLbl.font = MyTheme.myFontSemiBold(25)
        bgView.backgroundColor = MyTheme.backGroundDarkRedColor
        nextBtn.titleLabel?.font = MyTheme.myFontMedium(18)
        nextBtn.backgroundColor = MyTheme.buttonwhiteBackGroundColor
        nextBtn.tintColor = MyTheme.buttonBlackBackGroundColor
        nextBtn.isHidden = false
    }
    func setUpLanguage(){
        let currentLanguage = UserTempData.returnValue(.appCurrentLanguage) as? String
        if currentLanguage == "English"{
            langIcon.image = UIImage(named: "HeaderEnglish")
        }else{
            langIcon.image = UIImage(named: "HeaderIcon")
        }
        
        nextBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.next, for: .normal)
        permissionLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.permissionTitle
    }

    @IBAction func nextBtnClicked(_ sender: Any) {
        if locationPermissionGranted == false{
            showToast(message: "Please enable Location")
        }else if cameraPermissionGranted == false{
            showToast(message: "Please enable camera permission")
        }else{
            let vc = DashBoardVC(nibName: "DashBoardVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
       
    }
}
extension PermissionScreen : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = prmssionTv.dequeueReusableCell(withIdentifier: "PermissionImageTvCell") as! PermissionImageTvCell
            
            cell.descriptionLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.permissionLabel
            return cell
        }else{
            let cell = prmssionTv.dequeueReusableCell(withIdentifier: "AccessPermissionTvCell" ) as! AccessPermissionTvCell
            if indexPath.row == 1 {
                cell.permissionLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.noLocationPermission
                
                if locationPermissionGranted == true{
                    cell.permsnBtn.setImage(UIImage(named: "right"), for: .normal)
                }else{
                    cell.permsnBtn.setImage(UIImage(named: "needpermission"), for: .normal)
                }
            }else {
                cell.permissionLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.noCameraPermission
                if cameraPermissionGranted == true{
                    cell.permsnBtn.setImage(UIImage(named: "right"), for: .normal)
                }else{
                    cell.permsnBtn.setImage(UIImage(named: "needpermission"), for: .normal)
                }
            }
            if cameraPermissionGranted == true && locationPermissionGranted == true{
                nextBtn.setTitleColor( MyTheme.buttonBlackBackGroundColor, for: .normal)
                nextBtn.isEnabled = true
            }

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            
            let vc = LocationPermissionScreen(nibName: "LocationPermissionScreen", bundle: nil)
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
            vc.btnDidtap = {[weak self] (value, latitude , longitude ) in
                guard let self = self else{ return }
                if value == "continue"{
                    self.locationPermissionGranted = true
                    BaseClassHelper.sharedInstance.SaveCurrentLocationApi( lat: latitude, longitud: longitude)
                    self.prmssionTv.reloadData()
                }else{
                    
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
        else if  indexPath.row == 2{
            self.checkCameraPermission()
        }
    }
}
