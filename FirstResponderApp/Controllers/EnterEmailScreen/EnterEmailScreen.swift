

import UIKit

class EnterEmailScreen: UIViewController {

    @IBOutlet weak var emailIDTxtField: UITextField!
    @IBOutlet weak var fotterNoteLbl: UILabel!
    @IBOutlet var langIcon: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var viewBG: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }

    func setUpUI(){
        setUpLanguage()
        fotterNoteLbl.font = MyTheme.myFontRegular(fotterNoteLbl.font.pointSize)
        viewBG.backgroundColor = MyTheme.backGroundDarkRedColor
        nextBtn.titleLabel?.font = MyTheme.myFontMedium(18)
        nextBtn.backgroundColor = MyTheme.buttonBlackBackGroundColor
        //print(MyTheme.myStrings.ok)
    }
    func setUpLanguage(){
        let currentLanguage = UserTempData.returnValue(.appCurrentLanguage) as? String
        if currentLanguage == "English"{
            langIcon.image = UIImage(named: "HeaderEnglish")
        }else{
            langIcon.image = UIImage(named: "HeaderIcon")
        }
        
        nextBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.next, for: .normal)
        emailIDTxtField.placeholder =  SetUpAppLanguage.shareInstance.AppLanguageData?.dummyEmail
        fotterNoteLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
    }
    
    @IBAction func backBtnDidClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtnClick(_ sender: Any) {
        self.view.endEditing(true)
        if emailIDTxtField.text == ""{
            self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.enterValidEmail ?? "")
        } else if !self.isValidEmail(email: emailIDTxtField.text ?? ""){
           
            self.showToast(message: SetUpAppLanguage.shareInstance.AppLanguageData?.pleaseEnterValidEmail ?? "")
        }else{
            requestForgotPassApi()
            
        }
     
    }
    
}
