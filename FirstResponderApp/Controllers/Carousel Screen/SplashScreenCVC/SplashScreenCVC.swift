//
//  SplashScreenCVC.swift
//  Alecom
//
//  Created by bd01 on 05/09/22.
//

import UIKit

class SplashScreenCVC: UICollectionViewCell {

    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        // Initialization code
    }
    func setUpUI(){
      //  subHeadingLbl.font = MyTheme.myFontMedium(18)
      //  headingLbl.font = MyTheme.myFontBold(22)
        //print(MyTheme.myStrings.ok)
    }
}
