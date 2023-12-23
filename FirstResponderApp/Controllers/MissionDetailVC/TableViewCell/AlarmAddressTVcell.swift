//
//  AlarmAddressTVcell.swift
//  FirstResponderApp
//
//  Created by bd05 on 1/4/23.
//

import UIKit

class AlarmAddressTVcell: UITableViewCell {
    @IBOutlet weak var lblPatientDetal: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblPatientDetal.textColor = MyTheme.buttonwhiteBackGroundColor
       
        
        lblPatientDetal.font = MyTheme.myFontSemiBold(20)
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
