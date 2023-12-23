//
//  PhoneNumberTvcell.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/14/22.
//

import UIKit

class PhoneNumberTvcell: UITableViewCell {

    @IBOutlet weak var phoneCode: UILabel!
    @IBOutlet weak var txtFldPhone: UITextField!
    @IBOutlet weak var bgView: UIView!
    var selectedCountry : [CountryListPhoneCode]?
    var getDataBack :(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

//    //MARK: - Custome Metthods
//    func setupCountry(){
//        if selectedCountry != nil{
//            self.phoneCode.text = "+\(self.selectedCountry?.phoneCode ?? "")"
//           // self.lblCountryIcon.text = self.selectedCountry?.flag ?? ""
//        }else{
//            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//                self.selectedCountry = getCountryByCode(countryCode)
//                self.phoneCode.text = "+\(self.selectedCountry?.phoneCode ?? "")"
//              //  self.lblCountryIcon.text = self.selectedCountry?.flag ?? ""
//            }
//        }
//    }
    
    @IBAction func selectPhoneBookClicked(_ sender: Any) {
        getDataBack?()
     
    }
}
