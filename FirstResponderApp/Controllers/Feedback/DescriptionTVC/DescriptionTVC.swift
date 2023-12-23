//
//  DescriptionTVC.swift
//  Alecom
//
//  Created by bd01 on 15/09/22.
//

import UIKit

class DescriptionTVC: UITableViewCell {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var trallingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
