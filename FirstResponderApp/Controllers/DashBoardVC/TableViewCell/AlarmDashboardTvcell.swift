//
//  AlarmDashboardTvcell.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/16/22.
//

import UIKit

class AlarmDashboardTvcell: UITableViewCell {
    @IBOutlet weak var activeAlarmImg: UIImageView!
    
    @IBOutlet weak var noDataFoundLbl: UILabel!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var noAlarmLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpUI(){
        noAlarmLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        noDataFoundLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        noAlarmLbl.font = MyTheme.myFontMedium(22)
        noDataFoundLbl.font = MyTheme.myFontRegular(18)
        
        
    }
    
}
