//
//  PermissionImageTvCell.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/15/22.
//

import UIKit

class PermissionImageTvCell: UITableViewCell {

    @IBOutlet weak var descriptionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
     
    }
    func setUpUI() {
        descriptionLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        descriptionLbl.font = MyTheme.myFontRegular(18)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
