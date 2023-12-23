//
//  BtnTVC.swift
//  Alecom
//
//  Created by bd01 on 15/09/22.
//

import UIKit

class BtnTVC: UITableViewCell {
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageEmoji: UIImageView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var traillingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var LblTittle: UILabel!
    @IBOutlet weak var viewBG: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    func setUpUI(){
        LblTittle.font = MyTheme.myFontRegular(18)
        viewBG.backgroundColor = MyTheme.buttonwhiteBackGroundColor
        
        LblTittle.textColor = MyTheme.buttonBlackBackGroundColor
        leadingConstraint.constant = 20
        traillingConstraint.constant = 20
        bottomViewConstraint.constant = 10
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
