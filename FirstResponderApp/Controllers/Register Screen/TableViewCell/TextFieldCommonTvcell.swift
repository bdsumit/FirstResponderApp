//
//  TextFieldCommonTvcell.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/10/22.
//

import UIKit

class TextFieldCommonTvcell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var textFld: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
