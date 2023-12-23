//
//  CarouselScreen.swift
//  Alecom
//
//  Created by bd01 on 05/09/22.
//

import UIKit
import Kingfisher

class CarouselScreen: UIViewController {

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet var langIcon: UIImageView!
    @IBOutlet weak var fotterNoteLbl: UILabel!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var splashCollectionView: UICollectionView!
    
    var CarouselData : [CarouselSettingData]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguage()
        setUpUI()
        getCarouselSettingApi()
        viewBG.backgroundColor =  MyTheme.backGroundDarkRedColor
        splashCollectionView.delegate = self
        splashCollectionView.dataSource = self
        splashCollectionView.register(UINib(nibName: "SplashScreenCVC", bundle: nil), forCellWithReuseIdentifier: "SplashScreenCVC")
        //carosuelSetting Api call
    }
    func setUpUI(){
        fotterNoteLbl.font = MyTheme.myFontRegular(fotterNoteLbl.font.pointSize)
        viewBG.backgroundColor = MyTheme.backGroundDarkRedColor
       
        loginBtn.backgroundColor = MyTheme.buttonwhiteBackGroundColor
        registerBtn.backgroundColor = MyTheme.buttonBlackBackGroundColor
        
        
    }
    func setUpLanguage(){
        let currentLanguage = UserTempData.returnValue(.appCurrentLanguage) as? String
        if currentLanguage == "English"{
            langIcon.image = UIImage(named: "HeaderEnglish")
        }else{
            langIcon.image = UIImage(named: "HeaderIcon")
        }
        registerBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.register, for: .normal)
        loginBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.login, for: .normal)
        fotterNoteLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
    }
    @IBAction func logiBtnClick(_ sender: Any) {
        let vc  = LoginVC(nibName: "LoginVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        
        let vc  = RegisterScreen(nibName: "RegisterScreen", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CarouselScreen : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return CarouselData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = splashCollectionView.dequeueReusableCell(withReuseIdentifier: "SplashScreenCVC", for: indexPath) as! SplashScreenCVC
        self.pageControl.numberOfPages = CarouselData?.count ?? 0

        let imgUrl = CarouselData?[indexPath.row].pageLogo ?? ""
        var urlString = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        
        let url = URL(string: urlString)
        cell.imgView.kf.setImage(with: url)
        
        cell.headingLbl.text = CarouselData?[indexPath.row].headerText ?? ""
        cell.subHeadingLbl.text = CarouselData?[indexPath.row].descriptionText ?? ""
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         //  startTimer()
           let visibleRect = CGRect(origin: self.splashCollectionView.contentOffset, size: splashCollectionView.bounds.size)
           let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
           if let visibleIndexPath = self.splashCollectionView.indexPathForItem(at: visiblePoint) {
               self.pageControl.currentPage = visibleIndexPath.row
               self.splashCollectionView.reloadData()
           }
       }
   
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        self.pageControl.currentPage = indexPath.row
//
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let   collectionViewWidth = CGFloat(self.splashCollectionView.frame.width - 10)
        return CGSize(width: collectionViewWidth, height: self.splashCollectionView.frame.height)
    }
}
