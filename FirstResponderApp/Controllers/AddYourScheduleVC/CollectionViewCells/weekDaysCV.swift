//
//  weekDaysCV.swift
//  FirstResponderApp
//
//  Created by bd10 on 17/11/22.
//

import UIKit

class weekDaysCV: UICollectionViewCell {

    @IBOutlet weak var weekdayNameLbl: UILabel!
    @IBOutlet weak var weekDaysView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.weekDaysView.cornerRadius = 10
        self.weekDaysView.maskTobound = true
        weekDaysView.backgroundColor = MyTheme.segmentBgColor
        weekdayNameLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        weekdayNameLbl.font = MyTheme.myFontBold(15)
    }

}
