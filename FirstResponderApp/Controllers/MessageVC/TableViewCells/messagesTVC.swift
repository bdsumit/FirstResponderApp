//
//  messagesTVC.swift
//  FirstResponderApp
//
//  Created by bd10 on 18/11/22.
//

import UIKit

class messagesTVC: UITableViewCell {

    @IBOutlet weak var readMoreLbl: UILabel!
    @IBOutlet weak var detaildLbl: UILabel!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var sideBarView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLbl.font = MyTheme.myFontRegular(12)
        headerLbl.font = MyTheme.myFontBold(15)
        detaildLbl.font = MyTheme.myFontRegular(20)
        readMoreLbl.font = MyTheme.myFontRegular(12)
        
        detaildLbl.textColor = MyTheme.blueColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
