//
//  EmailTVC.swift
//  Alecom
//
//  Created by bd01 on 06/09/22.
//

import UIKit

class EmailTVC: UITableViewCell {
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        let email =  SetUpAppLanguage.shareInstance.AppLanguageData?.email ?? ""
        let password =  SetUpAppLanguage.shareInstance.AppLanguageData?.password ?? ""
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "\(email)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "\(password)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
