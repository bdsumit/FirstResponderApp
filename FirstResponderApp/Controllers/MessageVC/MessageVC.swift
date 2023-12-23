//
//  MessageVC.swift
//  FirstResponderApp
//
//  Created by bd10 on 18/11/22.
//

import UIKit

class MessageVC: UIViewController {

    @IBOutlet weak var mainViewBg: UIView!
    @IBOutlet weak var copyRightNoteLbl: UILabel!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet weak var messageTable: UITableView!
    @IBOutlet weak var normalReadLbl: UILabel!
    @IBOutlet weak var normalUnreadLbl: UILabel!
    @IBOutlet weak var normalReadView: UIView!
    @IBOutlet weak var normalUnreadView: UIView!
    @IBOutlet weak var normalLbl: UILabel!
    @IBOutlet weak var emergencyLbl: UILabel!
    @IBOutlet weak var emergencyReadLbl: UILabel!
    @IBOutlet weak var emergencyUnreadLbl: UILabel!
    @IBOutlet weak var emergencyReadView: UIView!
    @IBOutlet weak var emergencyUnreadView: UIView!
    @IBOutlet weak var normalView: UIView!
    @IBOutlet weak var emergencyView: UIView!
    
    var buttunTag = 0
    var userNotificationData : [UserNotification]?
    var normalNotification : [UserNotification]?
    var emergencyNotification : [UserNotification]?
    
    var emergencyGreenCount = 0
    var emergencyOrangeCount = 0
    var normalGreenCount = 0
    var normalOrangeCount = 0
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setuUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        //MARK: - get user notification api call
        getUserNotificationApi()
    }

    func setuUI(){
        setUpLanguage()
        
        messageTable.delegate = self
        messageTable.dataSource = self
        mainViewBg.backgroundColor = MyTheme.backGroundDarkGrayColor
        messageTable.register(UINib(nibName: "messagesTVC", bundle: nil), forCellReuseIdentifier: "messagesTVC")
        copyRightNoteLbl.font = MyTheme.myFontRegular(copyRightNoteLbl.font.pointSize)
        
        emergencyView.backgroundColor = MyTheme.redColor
        normalView.backgroundColor = MyTheme.backGroundLightGrayColor
        emergencyLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        normalLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        emergencyLbl.font = MyTheme.myFontRegular(15)
        normalLbl.font = MyTheme.myFontRegular(15)
        emergencyReadLbl.font = MyTheme.myFontRegular(12)
        emergencyUnreadLbl.font = MyTheme.myFontRegular(12)
        normalReadLbl.font = MyTheme.myFontRegular(12)
        normalUnreadLbl.font = MyTheme.myFontRegular(12)
        
        emergencyReadLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        emergencyUnreadLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        normalReadLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        normalUnreadLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        
    }
    func setUpLanguage(){
        
        messageLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.myNotis
        emergencyLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.emergencyNotification
        self.normalLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.normalNotification
        copyRightNoteLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
    }
    
    
    @IBAction func emergencyBtnClicked(_ sender: UIButton) {
        buttunTag = sender.tag
        emergencyView.backgroundColor = MyTheme.redColor
        normalView.backgroundColor = MyTheme.backGroundLightGrayColor
        messageTable.reloadData()
    }
    @IBAction func normalBtnClicked(_ sender: UIButton) {
        buttunTag = sender.tag
        emergencyView.backgroundColor = MyTheme.backGroundDarkRedColor
        normalView.backgroundColor = MyTheme.segmentBgColor
        messageTable.reloadData()
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func settingBtnClicked(_ sender: Any) {
        let vc = SettingScreen(nibName: "SettingScreen", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
extension MessageVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if buttunTag == 0{
            return emergencyNotification?.count ?? 0
        }else{
            return normalNotification?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if buttunTag == 0{
            let cell = messageTable.dequeueReusableCell(withIdentifier: "messagesTVC", for: indexPath) as! messagesTVC
            if self.emergencyNotification?[indexPath.row].isRead == false &&   self.emergencyNotification?[indexPath.row].status == "New"{
                
                cell.sideBarView.backgroundColor = MyTheme.backGroundGreenColor
                
            } else if self.emergencyNotification?[indexPath.row].isRead == false &&   self.emergencyNotification?[indexPath.row].status == "Updated"{
                cell.sideBarView.backgroundColor = MyTheme.orangeBgColor
            }else{
                cell.sideBarView.backgroundColor = MyTheme.backGroundLightGrayColor
            }
            
            
            
            cell.dateLbl.text = "\(Date().changeDataFormate(dateInString : (emergencyNotification?[indexPath.row].createdDate ?? ""),formate : DateFormat.formateInApi))"
            cell.headerLbl.text = emergencyNotification?[indexPath.row].header ?? ""
            cell.detaildLbl.text = emergencyNotification?[indexPath.row].text ?? ""
            return cell
        }else{
            let cell = messageTable.dequeueReusableCell(withIdentifier: "messagesTVC", for: indexPath) as! messagesTVC
            
            if self.normalNotification?[indexPath.row].isRead == false &&   self.normalNotification?[indexPath.row].status == "New"{
                
                cell.sideBarView.backgroundColor = MyTheme.backGroundGreenColor
                
            } else if self.normalNotification?[indexPath.row].isRead == false &&   self.normalNotification?[indexPath.row].status == "Updated"{
                cell.sideBarView.backgroundColor = MyTheme.orangeBgColor
            }else{
                cell.sideBarView.backgroundColor = MyTheme.backGroundLightGrayColor
            }
            cell.dateLbl.text = "\(Date().changeDataFormate(dateInString : (normalNotification?[indexPath.row].createdDate ?? ""),formate : DateFormat.formateInApi))"
            cell.headerLbl.text = normalNotification?[indexPath.row].header ?? ""
            cell.detaildLbl.text = normalNotification?[indexPath.row].text ?? ""
            cell.readMoreLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.readMore
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let deleteTital = SetUpAppLanguage.shareInstance.AppLanguageData?.delete ?? ""
        let sureFordelete = SetUpAppLanguage.shareInstance.AppLanguageData?.sureFordelete ?? ""
        let ok = SetUpAppLanguage.shareInstance.AppLanguageData?.ok ?? ""
        let cancel = SetUpAppLanguage.shareInstance.AppLanguageData?.cancel ?? ""
        
        let deleteAction = UITableViewRowAction(style: .normal, title: deleteTital) { (rowAction, indexPath) in
            //TODO: Delete the row at indexPath here
            let alertController = UIAlertController(title: "", message: sureFordelete, preferredStyle: .alert)

             // Create the actions
            let okAction = UIAlertAction(title: ok, style: UIAlertAction.Style.default) {
                 UIAlertAction in
                if self.buttunTag == 0{
                    self.DeleteNotificationApi(notificationId : self.emergencyNotification?[indexPath.row].notificationID ?? 0, indexPath: indexPath.row)
                }else{
                    self.DeleteNotificationApi(notificationId : self.normalNotification?[indexPath.row].notificationID ?? 0, indexPath: indexPath.row)
                }
             }
            let cancelAction = UIAlertAction(title: "\(cancel)", style: UIAlertAction.Style.cancel) {
                 UIAlertAction in
                 NSLog("Cancel Pressed")
             }

             // Add the actions
             alertController.addAction(okAction)
             alertController.addAction(cancelAction)

             // Present the controller
            self.present(alertController, animated: true, completion: nil)
       
        }
        deleteAction.backgroundColor = .red

        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if buttunTag == 0{
            ReadNotificationApi(notificationId : emergencyNotification?[indexPath.row].notificationID ?? 0, indexPath: indexPath.row)
            //API Call read user notification
            
        }else{
            ReadNotificationApi(notificationId : normalNotification?[indexPath.row].notificationID ?? 0, indexPath: indexPath.row)
            //API Call read user notification
            
        }
      
    }
    
    
}
