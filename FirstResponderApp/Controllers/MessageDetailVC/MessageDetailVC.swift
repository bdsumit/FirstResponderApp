//
//  MessageDetailVC.swift
//  FirstResponderApp
//
//  Created by bd10 on 18/11/22.
//

import UIKit
import Kingfisher

class MessageDetailVC: UIViewController {

    @IBOutlet weak var messageDetailsTable: UITableView!
    @IBOutlet weak var copyRightNoteLbl: UILabel!
    @IBOutlet weak var vcHeadingLbl: UILabel!
    var FromPushNotification = false
    var messageDetailsData : UserNotification?
    var notificationData : NotificationDetail?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setUpLanguage(){
        
        vcHeadingLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.myNotis
        copyRightNoteLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
    }
    
    func setupUI(){
        setUpLanguage()
        messageDetailsTable.delegate = self
        messageDetailsTable.dataSource = self
        messageDetailsTable.register(UINib(nibName: "messageDetailsTVC", bundle: nil), forCellReuseIdentifier: "messageDetailsTVC")
        copyRightNoteLbl.font = MyTheme.myFontRegular(copyRightNoteLbl.font.pointSize)
    }
    
    @IBAction func settingBtn(_ sender: Any) {
        let vc = SettingScreen(nibName: "SettingScreen", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension MessageDetailVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageDetailsTable.dequeueReusableCell(withIdentifier: "messageDetailsTVC", for: indexPath) as! messageDetailsTVC
        if FromPushNotification == true{
            cell.dateLbl.text = "\(Date().changeDataFormate(dateInString : (notificationData?.createdDate ?? ""),formate : DateFormat.formateInApi))"
            cell.headingLbl.text = notificationData?.header
            cell.descriptionLbl.text = notificationData?.text
            
            let imgBaseURL = "https://alitisdev.alitis.se/AlecomFirstResponderAPI/"
            if notificationData?.picture != ""{
                cell.imgView.isHidden = false
                let newStr = notificationData?.picture?.replacingOccurrences(of: " ", with: "") ?? ""
                let url = URL(string: "\(imgBaseURL)\(newStr)")
                
                if notificationData?.picture != ""{
                    cell.imgView.kf.setImage(with: url)
                }else{
                    cell.imgView.image = UIImage(named: "noimage")
                }
             

            }else{
                cell.imgView.isHidden = true
            }
        }else{
            cell.dateLbl.text = "\(Date().changeDataFormate(dateInString : (messageDetailsData?.createdDate ?? ""),formate : DateFormat.formateInApi))"
            cell.headingLbl.text = messageDetailsData?.header
            cell.descriptionLbl.text = messageDetailsData?.text
            
            let imgBaseURL = "https://alitisdev.alitis.se/AlecomFirstResponderAPI/"
            
            if messageDetailsData?.picture != ""{
                cell.imgView.isHidden = false
                let newStr = messageDetailsData?.picture?.replacingOccurrences(of: " ", with: "") ?? ""
                let url = URL(string: "\(imgBaseURL)\(newStr)")
                
                if messageDetailsData?.picture != ""{
                    cell.imgView.kf.setImage(with: url)
                }else{
                    cell.imgView.image = UIImage(named: "noimage")
                }
             

            }else{
                cell.imgView.isHidden = true
            }
            
          
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if messageDetailsData?.picture != ""{
            let vc = ImagePreviewVC(nibName: "ImagePreviewVC", bundle: nil)
            vc.imgUrl = messageDetailsData?.picture?.replacingOccurrences(of: " ", with: "") ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
        }
        
    }
    
    
}
