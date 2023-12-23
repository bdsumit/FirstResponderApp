//
//  messageDetailsTVC.swift
//  FirstResponderApp
//
//  Created by bd10 on 23/11/22.
//

import UIKit

class messageDetailsTVC: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLbl.font = MyTheme.myFontRegular(12)
        headingLbl.font = MyTheme.myFontBold(15)
        descriptionLbl.font = MyTheme.myFontRegular(20)
        descriptionLbl.textColor = MyTheme.blueColor
        headingLbl.textColor = MyTheme.blueColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
