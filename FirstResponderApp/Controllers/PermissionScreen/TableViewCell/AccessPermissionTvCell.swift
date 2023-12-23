//
//  AccessPermissionTvCell.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/15/22.
//

import UIKit

class AccessPermissionTvCell: UITableViewCell {

    @IBOutlet weak var permsnBtn: UIButton!
    @IBOutlet weak var permissionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    func setUpUI() {
        permissionLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        permissionLbl.font = MyTheme.myFontRegular(18)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
