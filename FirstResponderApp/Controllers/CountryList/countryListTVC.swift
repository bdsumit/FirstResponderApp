//
//  countryListTVC.swift
//  Kweeke
//
//  Created by bd01 on 2/8/21.
//  Copyright © 2021 saurabh. All rights reserved.
//

import UIKit

class countryListTVC: UITableViewCell {

    @IBOutlet var lblCountryName: UILabel!

    @IBOutlet weak var lblFlage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
