//
//  RegisterScreen.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/10/22.
//

import UIKit

struct personalDetail : Encodable{
    var workplace : String
    var ProffesionalTital : String
    var firstName : String
    var lastname : String
    var email : String
    var phoneNumber : String
    var password : String
    var conPassword : String
}


class RegisterScreen: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var footerLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var registerTableView: UITableView!
    var userInfoDetail : personalDetail?
    var storeRegistrationData = (workplace: "",ProffesionalTital : "", firstName: "", lastname : "", email : "", phoneNumber : "", password : "",conPassword : "", cprTraining : "", countryPhoneCode : 46)
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.hideKeyboardWhenTappedAround()
        registerTableView.delegate = self
        registerTableView.dataSource = self
        registerTableView.register(UINib(nibName: "TextFieldCommonTvcell", bundle: nil), forCellReuseIdentifier: "TextFieldCommonTvcell")
        registerTableView.register(UINib(nibName: "EmailTVC", bundle: nil), forCellReuseIdentifier: "EmailTVC")
        registerTableView.register(UINib(nibName: "PhoneNumberTvcell", bundle: nil), forCellReuseIdentifier: "PhoneNumberTvcell")
        
        // Do any additional setup after loading the view.
    }
    func setUpUI() {
        setUpLanguage()
        footerLbl.font = MyTheme.myFontRegular(footerLbl.font.pointSize)
        bgView.backgroundColor = MyTheme.backGroundDarkRedColor
        
        nextBtn.backgroundColor = MyTheme.buttonBlackBackGroundColor
        //print(MyTheme.myStrings.ok)
    }
    func setUpLanguage(){
        
        nextBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.next, for: .normal)
        footerLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 5{
            let charsLimit = 11

            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace =  range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace

            return newLength <= charsLimit
        }
        return true
    }
    
    
    @IBAction func btnback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        self.view.endEditing(true)
        if storeRegistrationData.firstName == ""{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.enterFirstName ?? "")
           
        }else if storeRegistrationData.firstName.count < 2 {
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.firstNameShouldNotlessThen2 ?? "")
        }else if storeRegistrationData.lastname == ""{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.enterLastName ?? "")
        }else if storeRegistrationData.lastname.count < 2{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.lastNameShouldNotlessThen2 ?? "")
        }else if storeRegistrationData.email == ""{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.enterValidEmail ?? "")
        }else if !isValidEmail(email: storeRegistrationData.email){
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.pleaseEnterValidEmail ?? "")
            
        }else if storeRegistrationData.phoneNumber == ""{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.enterphonenumber ?? "")
        }else if storeRegistrationData.phoneNumber.count < 8{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.phoneNumberNotlessThen8 ?? "")
        }else if storeRegistrationData.password == ""{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.passwordNotlessThen6 ?? "")
        }else if storeRegistrationData.password.count < 6{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.passwordNotlessThen6 ?? "")
        }else if storeRegistrationData.conPassword == ""{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.passwordNotMatch ?? "")
        }else if storeRegistrationData.conPassword.count < 6{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.passwordNotlessThen6 ?? "")
        }else if storeRegistrationData.password != storeRegistrationData.conPassword{
            showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.passwordNotMatch ?? "")
        }else{
            CheckRegisterUserApi()
          
           
        }
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        switch textField.tag {
        case 0:
            storeRegistrationData.workplace = textField.text ?? ""
        case 1:
            storeRegistrationData.ProffesionalTital = textField.text ?? ""
        case 2:
            storeRegistrationData.firstName = textField.text ?? ""
        case 3:
            storeRegistrationData.lastname = textField.text ?? ""
        case 4:
            storeRegistrationData.email = textField.text ?? ""
        case 5:
            storeRegistrationData.phoneNumber = textField.text ?? ""
        case 6:
            storeRegistrationData.password = textField.text ?? ""
        case 7:
            storeRegistrationData.conPassword = textField.text ?? ""
        default:
            storeRegistrationData.cprTraining = textField.text ?? ""
        }

    }
}





extension RegisterScreen : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0{
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 20))
            
            // headerView.addSubview(label)
            
            return headerView
        }
       return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0{
            return 20
        }else{
            return 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 4
        case 2:
            return 2
        default:
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = registerTableView.dequeueReusableCell(withIdentifier: "TextFieldCommonTvcell") as! TextFieldCommonTvcell
        cell.textFld.delegate = self
        
        if indexPath.section == 0{
            cell.textFld.isSecureTextEntry = false
            if indexPath.row == 0 {
                cell.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.textFld.placeholder = SetUpAppLanguage.shareInstance.AppLanguageData?.workingPlace
                cell.textFld.tag = 0
                cell.textFld.text = userInfoDetail?.workplace
            }else {
                cell.textFld.tag = 1
                cell.textFld.placeholder = SetUpAppLanguage.shareInstance.AppLanguageData?.proffession
                cell.bgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }else if indexPath.section == 1 {
            cell.textFld.isSecureTextEntry = false
            if indexPath.row == 0 {
                cell.textFld.tag = 2
                cell.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.textFld.placeholder = SetUpAppLanguage.shareInstance.AppLanguageData?.firstName
            }else if indexPath.row == 1 {
                cell.textFld.tag = 3
                cell.bgView.layer.cornerRadius = 0
                cell.textFld.placeholder = SetUpAppLanguage.shareInstance.AppLanguageData?.lastName
            }else if indexPath.row == 2 {
                cell.textFld.tag = 4
                cell.bgView.layer.cornerRadius = 0
                cell.textFld.placeholder = SetUpAppLanguage.shareInstance.AppLanguageData?.email
            }else{
                let cell = registerTableView.dequeueReusableCell(withIdentifier: "PhoneNumberTvcell") as! PhoneNumberTvcell
                cell.txtFldPhone.delegate = self
                cell.txtFldPhone.isSecureTextEntry = false
                cell.txtFldPhone.tag = 5
                cell.bgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.getDataBack = {[weak self] in
                    guard let self = self else{ return}
                    
                    let vc = countryListVC(nibName: "countryListVC", bundle: nil)
                    vc.selCountry = {[weak self] (country) in
                        guard let self = self else{return}
                        cell.phoneCode.text = "+\(country)"
                        self.storeRegistrationData.countryPhoneCode = country
                    }
                    self.present(vc, animated: true)
                }
                cell.txtFldPhone.placeholder = SetUpAppLanguage.shareInstance.AppLanguageData?.phoneNumber
                return cell
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0 {
                cell.textFld.tag = 6
                cell.textFld.isSecureTextEntry = true
                cell.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.textFld.placeholder = SetUpAppLanguage.shareInstance.AppLanguageData?.password
            }else{
                cell.textFld.tag = 7
                cell.textFld.isSecureTextEntry = true
                cell.bgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.textFld.placeholder = SetUpAppLanguage.shareInstance.AppLanguageData?.confirmPassword
            }
            
        }else{
            cell.textFld.isSecureTextEntry = false
            cell.textFld.tag = 8
            cell.textFld.placeholder = SetUpAppLanguage.shareInstance.AppLanguageData?.cprEducation
            cell.bgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
