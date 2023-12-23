//
//  SupportVC.swift
//  Alecom
//
//  Created by bd01 on 15/09/22.
//

import UIKit
import Foundation
class SupportVC: UIViewController, UITextFieldDelegate , UITextViewDelegate{
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var supportTital: UILabel!
    
    @IBOutlet weak var footerLbl: UILabel!
    @IBOutlet weak var supportDescription: UILabel!
    @IBOutlet weak var goBackLbl: UILabel!
    
    @IBOutlet weak var SupportTable: UITableView!
    var titleLblArray = [SetUpAppLanguage.shareInstance.AppLanguageData?.supportUserEmail ,SetUpAppLanguage.shareInstance.AppLanguageData?.supportName, SetUpAppLanguage.shareInstance.AppLanguageData?.supportSubject ]
    var supportDetail = sentUpParam(Name: "", EmailId: "", Subject: "", Description: "", SupportEmailId: "")
    
    var subjectData : [CustomSubjectList]?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        GetSubjectApi()
        getDescription()
        
        let firstName = UserPersonalDetail.fetchUserDetail()?.firstName ?? ""
        let lastName = UserPersonalDetail.fetchUserDetail()?.lastName ?? ""
        supportDetail.Name = "\(firstName) \(lastName)"
        supportDetail.EmailId = UserPersonalDetail.fetchUserDetail()?.emailID ?? ""
        supportDetail.SupportEmailId = UserTempData.returnValue(.GlobelSettingValue) as! String
        SupportTable.delegate = self
        SupportTable.dataSource = self
        SupportTable.register(UINib(nibName: "SupportTVC", bundle: nil), forCellReuseIdentifier: "SupportTVC")
        SupportTable.register(UINib(nibName: "BtnTVC", bundle: nil), forCellReuseIdentifier: "BtnTVC")
        SupportTable.register(UINib(nibName: "DescriptionTVC", bundle: nil), forCellReuseIdentifier: "DescriptionTVC")
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(faqApiCall(_:)),
                         name: NSNotification.Name ("syncSetting"),                                           object: nil)
    }
    @objc func faqApiCall(_ notification: Notification) {
        GetSubjectApi()
        getDescription()
    }

    func getDescription(){
        BaseClassHelper.sharedInstance.GetGlobelSettingApi(self, {GlobleSettingData in
            
            for GlobelSettingDetail in GlobleSettingData ?? []{
                if GlobelSettingDetail.settingName == "Support"{
                    self.supportDescription.text = GlobelSettingDetail.settingValue
                }
                
            }})
    }
    func setUpUI(){
        setUpLanguage()
        //Font colour
        goBackLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        supportTital.textColor = MyTheme.buttonwhiteBackGroundColor
        supportDescription.textColor = MyTheme.buttonwhiteBackGroundColor
        footerLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        //Font SIze
        goBackLbl.font = MyTheme.myFontMedium(18)
        footerLbl.font = MyTheme.myFontRegular(15)
        supportTital.font = MyTheme.myFontBold(28)
        supportDescription.font = MyTheme.myFontSemiBold(22)
        // back ground colour
        viewBG.backgroundColor = MyTheme.backGroundLightGrayColor
        topView.backgroundColor = MyTheme.backGroundDarkGrayColor
    }
    func setUpLanguage(){
        
        footerLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
        supportTital.text = SetUpAppLanguage.shareInstance.AppLanguageData?.support
        
        goBackLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.returnSettings
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
    func textViewDidChangeSelection(_ textView: UITextView) {
        supportDetail.Description = textView.text
    }
   
}
// MARK: - TABLE VIEW
extension SupportVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 4 {
            let cell = SupportTable.dequeueReusableCell(withIdentifier: "BtnTVC") as! BtnTVC
            cell.LblTittle.text = SetUpAppLanguage.shareInstance.AppLanguageData?.send
            cell.LblTittle.font = MyTheme.myFontSemiBold(16)
            cell.LblTittle.textColor = MyTheme.buttonBlackBackGroundColor
            cell.viewBG.backgroundColor = MyTheme.buttonwhiteBackGroundColor
            return cell
        }
        else if indexPath.row == 3 {
        let cell = SupportTable.dequeueReusableCell(withIdentifier: "DescriptionTVC") as! DescriptionTVC
            cell.descriptionTextView.delegate = self
            cell.descriptionLbl.textColor = MyTheme.buttonwhiteBackGroundColor
            cell.descriptionTextView.font = MyTheme.myFontMedium(18)
            cell.descriptionLbl.font = MyTheme.myFontSemiBold(22)
            cell.descriptionLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.supportDescription
            cell.descriptionTextView.text = supportDetail.Description
            cell.descriptionTextView.isEditable = true
            cell.descriptionTextView.textColor = MyTheme.buttonBlackBackGroundColor
        return cell
        }
        else{
            let cell = SupportTable.dequeueReusableCell(withIdentifier: "SupportTVC") as! SupportTVC
            
            cell.headingLbl.text = titleLblArray[indexPath.row]
            cell.detailText.delegate = self
            if indexPath.row == 0 {
                cell.Bgview.backgroundColor = MyTheme.buttonwhiteBackGroundColor
                cell.Bgview.alpha = 0.8
                cell.detailText.text = supportDetail.EmailId
                cell.detailText.textColor = MyTheme.backGroundLightGrayColor
                cell.detailText.isEnabled = false
            }else if indexPath.row == 1 {
                cell.Bgview.backgroundColor = MyTheme.buttonwhiteBackGroundColor
                cell.Bgview.alpha = 0.8
                cell.detailText.text = supportDetail.Name
                cell.detailText.textColor = MyTheme.backGroundLightGrayColor
                cell.detailText.isEnabled = false
            }else if indexPath.row == 2{
                cell.Bgview.alpha = 1
                cell.Bgview.backgroundColor = MyTheme.buttonwhiteBackGroundColor
                cell.subjectData = subjectData
                cell.detailText.textColor = MyTheme.buttonBlackBackGroundColor
                cell.detailText.isEnabled = true
                cell.detailText.text = ""
                cell.PickerData = {[weak self] (value) in
                    guard let self = self else{ return}
                    cell.detailText.text = value
                    self.supportDetail.Subject = value
                }
                
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            if supportDetail.Subject == ""{
                showToast(message: "Please select subject")
            }else if  supportDetail.Description == ""{
               
                showToast(message: "Please enter description")
            }else{
                SentSupportApi()
            }
            
        }
    
    }
}

