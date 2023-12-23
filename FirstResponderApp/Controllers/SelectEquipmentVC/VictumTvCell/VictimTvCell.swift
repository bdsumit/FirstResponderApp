//
//  VictimTvCell.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/22/22.
//

import UIKit

class VictimTvCell: UITableViewCell {

    @IBOutlet weak var victimView: UIView!
    @IBOutlet weak var victimLbl: UILabel!
    @IBOutlet weak var heartIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    func setUpUI(){
        //Font colour
        victimLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        victimLbl.font =  MyTheme.myFontMedium(18)
        // back ground colour
        victimView.backgroundColor = MyTheme.backGroundDarkRedColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
