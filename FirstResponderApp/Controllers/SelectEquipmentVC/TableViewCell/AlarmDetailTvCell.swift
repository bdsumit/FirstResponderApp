//
//  AlarmDetailTvCell.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/22/22.
//

import UIKit

class AlarmDetailTvCell: UITableViewCell {

    @IBOutlet weak var mainBG: UIView!
    @IBOutlet weak var doorLbl: UILabel!
    @IBOutlet weak var streetLbl: UILabel!
    @IBOutlet weak var postCode: UILabel!
    @IBOutlet weak var gateCode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    func setUpUI(){
        //Font colour
        streetLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        doorLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        postCode.textColor = MyTheme.buttonwhiteBackGroundColor
        gateCode.textColor = MyTheme.buttonwhiteBackGroundColor
        
        doorLbl.font =  MyTheme.myFontMedium(18)
        streetLbl.font = MyTheme.myFontMedium(18)
        postCode.font = MyTheme.myFontMedium(18)
        gateCode.font = MyTheme.myFontMedium(18)

        // back ground colour
        mainBG.backgroundColor = .clear
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
