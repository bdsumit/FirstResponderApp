//
//  ProfileSettingVC.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/16/22.
//

import UIKit
import AVFoundation
class ProfileSettingVC: UIViewController, UIViewControllerTransitioningDelegate, UITextFieldDelegate ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{


    @IBOutlet weak var memberSinceLbl: UILabel!
    @IBOutlet weak var goBackLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var ProfsettingView: UIView!
    @IBOutlet weak var profileSettingLbl: UILabel!
    @IBOutlet weak var pendingView: UIView!
    @IBOutlet weak var ProfileSettingTv: UITableView! 
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var picBgView: UIView!
    @IBOutlet weak var footerLbl: UILabel!
    @IBOutlet weak var changePicBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var initials: UILabel!
    @IBOutlet weak var deletePicBtn: UIButton!
    @IBOutlet weak var changeViewLbl: UILabel!
    
    @IBOutlet weak var approveLbl: UILabel!
    var userDataFromApi : UserDetail?
    let userId = UserPersonalDetail.fetchUserDetail()?.userID
    var storeProfileData = updateUserDetailsParams(userId: "\(UserPersonalDetail.fetchUserDetail()?.userID ?? 0)", Phone: "", fName: "", lName: "", email: "", proffession: "", workplace: "", cprEductaion: "", password: nil, countryCode: "",confPass: "")
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpLanguage()
        BaseClassHelper.sharedInstance.getUserDetailsApi(self , {userDetails,globelSettingData,alarmVisibilityListData in
                              self.userDataFromApi = userDetails
                              
                             
        })
        imagePicker.delegate = self
        self.checkImg()
        self.setUpProfileUI()
        pendingView.isHidden = true
        ProfileSettingTv.delegate = self
        ProfileSettingTv.dataSource = self
        ProfileSettingTv.register(UINib(nibName: "UserNameTvcell", bundle: nil), forCellReuseIdentifier: "UserNameTvcell")
        ProfileSettingTv.register(UINib(nibName: "ProffessionTvCell", bundle: nil), forCellReuseIdentifier: "ProffessionTvCell")
        ProfileSettingTv.register(UINib(nibName: "PasswordTxtFld", bundle: nil), forCellReuseIdentifier: "PasswordTxtFld")
        
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(UpdateProfileFromPushNotificatoin(_:)),
                         name: NSNotification.Name ("GetUserDetalApi"),                                           object: nil)
    }
    func setUpLanguage() {
        footerLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
        profileSettingLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.profileSettings
        changePicBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.changePicture, for: .normal)
        deletePicBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.deletePicture, for: .normal)
        updateBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.update, for: .normal)
        let createdDate = userDataFromApi?.createdDate ?? ""
        let membersince = SetUpAppLanguage.shareInstance.AppLanguageData?.memberSince ?? ""
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = DateFormat.dateFormateInApi
        let StringToDate = dateFormator.date(from: createdDate) ?? Date()
        dateFormator.dateFormat = DateFormat.yearFormat
        let dateInString = dateFormator.string(from: StringToDate)
        
        memberSinceLbl.text =  "\(membersince) \(dateInString)"
        goBackLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.returnSettings
        approveLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.updateProfileReviewMsg
        changeViewLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.updateProfileReviewViewChanges
    }
    @objc func UpdateProfileFromPushNotificatoin(_ notification: Notification){
      
        BaseClassHelper.sharedInstance.getUserDetailsApi( self , {userDetails,globelSettingData,alarmVisibilityListData in
                              self.userDataFromApi = userDetails
                              self.checkImg()
                              self.ProfileSettingTv.reloadData()
        })
    }
    
    func setUpProfileUI() {
        
        storeProfileData.fName = userDataFromApi?.firstName ?? ""
        storeProfileData.lName = userDataFromApi?.lastName ?? ""
        storeProfileData.email = userDataFromApi?.emailID ?? ""
        storeProfileData.Phone = userDataFromApi?.phone ?? ""
        storeProfileData.countryCode = String(userDataFromApi?.countryCode ?? 0)
        storeProfileData.workplace = userDataFromApi?.workingPlace ?? ""
        storeProfileData.proffession = userDataFromApi?.proffession ?? ""
        storeProfileData.cprEductaion = userDataFromApi?.cprEducation ?? ""
        //Font colour
        goBackLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        footerLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        profileSettingLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        initials.textColor = MyTheme.buttonwhiteBackGroundColor
        memberSinceLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        
        approveLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        changeViewLbl.textColor = MyTheme.blueColor
        //Font SIze
        approveLbl.font = MyTheme.myFontRegular(13)
        goBackLbl.font = MyTheme.myFontMedium(18)
        changeViewLbl.font = MyTheme.myFontMedium(12)
        footerLbl.font = MyTheme.myFontRegular(15)
        profileSettingLbl.font = MyTheme.myFontBold(24)
        initials.font = MyTheme.myFontBold(25)
        memberSinceLbl.font = MyTheme.myFontRegular(15)
        // back ground colour
        ProfsettingView.backgroundColor = MyTheme.backGroundLightGrayColor
        bgView.backgroundColor = MyTheme.backGroundDarkGrayColor
        updateBtn.backgroundColor = MyTheme.buttonBlackBackGroundColor
        picBgView.backgroundColor = MyTheme.backGroundDarkGrayColor
        pendingView.backgroundColor = MyTheme.backGroundDarkRedColor
        
      //  checkImg()
        
    }
    func checkImg(){
        if userDataFromApi?.image ?? "" != ""{
            let imgBaseURL = "https://alitisdev.alitis.se/AlecomFirstResponderAPI/"
            let url = URL(string: "\(imgBaseURL)\(userDataFromApi?.image ?? "")")
            self.profileImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            profileImage.kf.setImage(with: url)
            
            self.initials.text = ""
        }else{
            //name here
            let fNameFirst = userDataFromApi?.firstName?.first?.description ?? ""
            let lNameFirst = userDataFromApi?.lastName?.first?.description ?? ""
            let nameString = "\(fNameFirst.uppercased())\(lNameFirst.uppercased())"
            self.initials.text = nameString
        }
    }


    @IBAction func updateBtn(_ sender: Any) {
        //MARK: - update user profile api : -
        if (self.storeProfileData.password ?? "") != (self.storeProfileData.confPass ?? ""){
           
            self.showToast(message:SetUpAppLanguage.shareInstance.AppLanguageData?.passwordNotMatch ?? "" )
        }else  if storeProfileData.fName == ""{
           
            self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.enterFirstName ?? "" )
        }else if storeProfileData.fName?.count ?? 0 < 2 {
            
            self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.firstNameShouldNotlessThen2 ?? "" )
        }else if storeProfileData.lName == ""{
          
            self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.enterLastName ?? "" )
        }else if storeProfileData.lName?.count ?? 0 < 2{
          
            self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.lastNameShouldNotlessThen2 ?? "" )
        }else if storeProfileData.email == ""{
            
            self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.enterValidEmail ?? "" )
        }else if !isValidEmail(email: storeProfileData.email ?? ""){
           
            self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.pleaseEnterValidEmail ?? "" )
        }else if storeProfileData.Phone == ""{
            self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.enterphonenumber ?? "" )
        }else if storeProfileData.Phone?.count ?? 0 < 8{
            self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.phoneNumberNotlessThen8 ?? "" )
        }else{
            
           if self.storeProfileData.password != nil{
               if storeProfileData.password?.count ?? 0 < 6{
                   showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.passwordNotlessThen6 ?? "")
               }else if storeProfileData.confPass?.count ?? 0 < 6{
                   showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.passwordNotlessThen6 ?? "")
               }else{
                       UserTempData.saveData(.UpdatedfirstName, storeProfileData.fName ?? "")
                       UserTempData.saveData(.UpdatedLastName, storeProfileData.lName ?? "")
                       UserTempData.saveData(.UpdatedMobNum, storeProfileData.Phone ?? "")
                       UserTempData.saveData(.UpdatedworkSpace, storeProfileData.workplace ?? "")
                       UserTempData.saveData(.UpdatedProfession, storeProfileData.proffession ?? "")
                       UserTempData.saveData(.UpdatedCPR, storeProfileData.cprEductaion ?? "")
                     
                       updateUserDetailsApi(updateUserDetailsParams: storeProfileData)
                   }
            }else{
                UserTempData.saveData(.UpdatedfirstName, storeProfileData.fName ?? "")
                UserTempData.saveData(.UpdatedLastName, storeProfileData.lName ?? "")
                UserTempData.saveData(.UpdatedMobNum, storeProfileData.Phone ?? "")
                UserTempData.saveData(.UpdatedworkSpace, storeProfileData.workplace ?? "")
                UserTempData.saveData(.UpdatedProfession, storeProfileData.proffession ?? "")
                UserTempData.saveData(.UpdatedCPR, storeProfileData.cprEductaion ?? "")
              
                updateUserDetailsApi(updateUserDetailsParams: storeProfileData)
            }
            
        }
       
       
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func changePhotoBtn(_ sender: UIButton) {
        let chooseImge = SetUpAppLanguage.shareInstance.AppLanguageData?.chooseImg ?? ""
        let Camera = SetUpAppLanguage.shareInstance.AppLanguageData?.camera ?? ""
        let gallery = SetUpAppLanguage.shareInstance.AppLanguageData?.gallery ?? ""
        let cancel = SetUpAppLanguage.shareInstance.AppLanguageData?.cancel ?? ""
        
        let alert = UIAlertController(title: "\(chooseImge)", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "\(Camera)", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "\(gallery)", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "\(cancel)", style: .cancel, handler: nil))
        
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
      {
          let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch (status)
            {
            case .authorized:
                self.popCamera()

            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (granted) in
                    if (granted)
                    {
                        self.popCamera()
                    }
                    else
                    {
                        self.camDenied()
                    }
                }

            case .denied:
                self.camDenied()
            case .restricted:
                let restricted = SetUpAppLanguage.shareInstance.AppLanguageData?.restricted ?? ""
                
                let cameraRestriction = SetUpAppLanguage.shareInstance.AppLanguageData?.cameraRestriction ?? ""
                let ok = SetUpAppLanguage.shareInstance.AppLanguageData?.ok ?? ""
                let alert = UIAlertController(title: "\(restricted)",
                                              message: "\(cameraRestriction)",
                                              preferredStyle: .alert)

                let okAction = UIAlertAction(title: "\(ok)", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            @unknown default:
                fatalError()
            }
      }
      
      func popCamera(){
          DispatchQueue.main.async {
              if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
              {
                  self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                  self.imagePicker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(.rear) ? .rear : .front
                  self.imagePicker.allowsEditing = true
                  self.present(self.imagePicker, animated: true, completion: nil)
              }
              else
              {
                  let warning = SetUpAppLanguage.shareInstance.AppLanguageData?.warning ?? ""
                  let dontHavecamera = SetUpAppLanguage.shareInstance.AppLanguageData?.dontHaveCamera ?? ""
                  let ok = SetUpAppLanguage.shareInstance.AppLanguageData?.ok ?? ""
                  
                  let alert = UIAlertController(title: "\(warning)", message: "\(dontHavecamera)", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "\(ok)", style: .default, handler: nil))
                  self.present(alert, animated: true, completion: nil)
              }
          }
          
         
      }
      
      
      
      
      func camDenied()
      {
          DispatchQueue.main.async
          {
              let cameraDenieAlart1Msg = SetUpAppLanguage.shareInstance.AppLanguageData?.deniecameraAlert1Msg ?? ""
              let cameraDenieAlart2Msg = SetUpAppLanguage.shareInstance.AppLanguageData?.deniecameraAlert2Msg ?? ""
              let ok = SetUpAppLanguage.shareInstance.AppLanguageData?.ok ?? ""
              let procced = SetUpAppLanguage.shareInstance.AppLanguageData?.procced ?? ""
              let followStep = SetUpAppLanguage.shareInstance.AppLanguageData?.followGivenStep ?? ""
              var alertText = "\(cameraDenieAlart1Msg)"
 
              var alertButton = "\(ok)"
              var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)

              if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!)
              {
                  alertText = "\(cameraDenieAlart2Msg)"

                  alertButton = "\(procced)"

                  goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                      UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                  })
              }

              let alert = UIAlertController(title: "\(followStep)", message: alertText, preferredStyle: .alert)
              alert.addAction(goAction)
              self.present(alert, animated: true, completion: nil)
          }
      }
    
    
       func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let orinalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        self.profileImage.contentMode = .scaleAspectFill
       // self.profileImage.image = orinalImage
        let imageStr = self.convertImageToBase64String(img: orinalImage)
        self.uploadUserProfilePhotoApi(userId: UserPersonalDetail.fetchUserDetail()?.userID ?? 0, image: imageStr ,changedImage : orinalImage)
        
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 4{
            let charsLimit = 11

            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace =  range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace

            return newLength <= charsLimit
        }
        return true
    }
    @IBAction func btnViewChange(_ sender: Any) {
        
        let vc = UpdateProfilePopUp(nibName: "UpdateProfilePopUp", bundle: nil)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.storeProfileData =  storeProfileData
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func deletePhotoBtn(_ sender: Any) {
        if profileImage.image != nil{
        removeProfilePhotoApi(userId: UserPersonalDetail.fetchUserDetail()?.userID ?? 0)
        }
    
    }

    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 1 {
            self.storeProfileData.fName = textField.text
        }else if textField.tag == 2 {
            self.storeProfileData.lName = textField.text
        }else if textField.tag == 3 {
            self.storeProfileData.email = textField.text
        }else if textField.tag == 4 {
            self.storeProfileData.Phone = textField.text
        }else if textField.tag == 5 {
            self.storeProfileData.proffession = textField.text
        }else if textField.tag == 6 {
            self.storeProfileData.workplace = textField.text
        }else if textField.tag == 7 {
            self.storeProfileData.cprEductaion = textField.text
        }else {
            print("fsds")
        }
    }
}
extension ProfileSettingVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = ProfileSettingTv.dequeueReusableCell(withIdentifier: "UserNameTvcell") as! UserNameTvcell
            cell.usernameTxtFld.delegate = self
            cell.userLastName.delegate = self
            cell.userEmail.delegate = self
            cell.userMobile.delegate = self
           
            cell.usernameTxtFld.tag = 1
            cell.userLastName.tag = 2
            cell.userEmail.tag = 3
            cell.userMobile.tag = 4
            
           if userDataFromApi?.profileChangesStatus == 0 {
               pendingView.isHidden = false  // 0 pr show krna h
              
               
            }else{
                pendingView.isHidden = true
                
     
            }
            let Fname = userDataFromApi?.firstName ?? ""
            let Lname = userDataFromApi?.lastName ?? ""
            cell.usernameTxtFld.text = Fname.capitalized
            cell.userLastName.text = Lname.capitalized
            cell.userEmail.text = userDataFromApi?.emailID ?? ""
            cell.userMobile.text = userDataFromApi?.phone ?? ""
    
                self.storeProfileData.countryCode = "+46"
            
            cell.countryCodeDidTap = {[weak self] in
                guard let self = self else{ return}
                
                let vc = countryListVC(nibName: "countryListVC", bundle: nil)
                vc.selCountry = {[weak self] (country) in
                    guard let self = self else{return}
                    cell.phoneCode.text = "+\(country)"
                }
                self.present(vc, animated: true)
            }
            
            return cell
        }else if indexPath.row == 1 {
            let cell = ProfileSettingTv.dequeueReusableCell(withIdentifier: "ProffessionTvCell") as! ProffessionTvCell
            cell.proffessionTxtfld.delegate = self
            cell.workTxtFld.delegate = self
            cell.crrTypeTxtFld.delegate = self
            
            cell.proffessionTxtfld.tag = 5
            cell.workTxtFld.tag = 6
            cell.crrTypeTxtFld.tag = 7
            
            cell.proffessionTxtfld.text = userDataFromApi?.proffession ?? ""
            cell.workTxtFld.text = userDataFromApi?.workingPlace ?? ""
            cell.crrTypeTxtFld.text = userDataFromApi?.cprEducation ?? ""

            return cell
        }else{
            let cell = ProfileSettingTv.dequeueReusableCell(withIdentifier: "PasswordTxtFld") as! PasswordTxtFld
            cell.sendPassword = {[weak self] (password, confPassword) in
                guard let self = self else { return }
                self.storeProfileData.confPass = confPassword
                self.storeProfileData.password = password
            }
            
            return cell
        }
  
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
