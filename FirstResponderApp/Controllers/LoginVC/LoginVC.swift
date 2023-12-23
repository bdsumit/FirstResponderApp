//
//  LoginVC.swift
//  Alecom
//
//  Created by bd01 on 05/09/22.
//

import UIKit

class LoginVC: UIViewController, UIActionSheetDelegate {

    @IBOutlet var langIcon: UIImageView!
    @IBOutlet weak var loginTable: UITableView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var fotterNoteLbl: UILabel!
    var email = UITextField()
    var passwordText = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.hideKeyboardWhenTappedAround()
        loginTable.delegate = self
        loginTable.dataSource = self
        loginTable.register(UINib(nibName: "LoginBtnTVC", bundle: nil), forCellReuseIdentifier: "LoginBtnTVC")
        loginTable.register(UINib(nibName: "EmailTVC", bundle: nil), forCellReuseIdentifier: "EmailTVC")
    }


    func setUpUI(){
        setUpLanguage()
        fotterNoteLbl.font = MyTheme.myFontRegular(fotterNoteLbl.font.pointSize)
        viewBG.backgroundColor =  MyTheme.backGroundDarkRedColor
        //print(MyTheme.myStrings.ok)
    }
    func setUpLanguage(){
        let currentLanguage = UserTempData.returnValue(.appCurrentLanguage) as? String
        if currentLanguage == "English"{
            langIcon.image = UIImage(named: "HeaderEnglish")
        }else{
            langIcon.image = UIImage(named: "HeaderIcon")
        }
        
        fotterNoteLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
     
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension LoginVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = loginTable.dequeueReusableCell(withIdentifier: "EmailTVC") as! EmailTVC
             email = cell.emailTextField
             passwordText = cell.PasswordTextField
            return cell
        }else{
            let cell = loginTable.dequeueReusableCell(withIdentifier: "LoginBtnTVC" ) as! LoginBtnTVC
            cell.assesView = self
            cell.LoginBtn = { [weak self] in
                guard let self = self else{ return}
                self.view.endEditing(true)
                if self.email.text == "" {
                    
                    self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.enterValidEmail ?? "" )
                } else if !self.isValidEmail(email: self.email.text ?? ""){
                    self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.pleaseEnterValidEmail ?? "" )
                }
                else if self.passwordText.text == "" {
                    self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.passwordNotlessThen6 ?? "" )
                }else{
                        self.loginApi()

                    print("Login succesfull")
                }
            }
            cell.contactCallBack = {[weak self] in
                guard let self = self else{ return}
                
                let vc = RegisterScreen(nibName: "RegisterScreen", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.forgotPasswordClicked = { [weak self] in
                guard let self = self else{ return }
                let vc = EnterEmailScreen(nibName: "EnterEmailScreen", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
              //  print("forgot Password Clicked ")
                
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
