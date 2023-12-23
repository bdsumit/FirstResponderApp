//
//  FAQVC.swift
//  Alecom
//
//  Created by bd01 on 09/09/22.
//

import UIKit

import Foundation
class FAQVC: UIViewController {
    
    
    @IBOutlet weak var mainBGView: UIView!
    @IBOutlet weak var goBackLbl: UILabel!
    @IBOutlet weak var footerLbl: UILabel!
    @IBOutlet weak var faqTital: UILabel!
    @IBOutlet weak var faqTable: UITableView!
    var FaqData : [QuestionAnswerList]?

    override func viewDidLoad() {
        super.viewDidLoad()
      
       setUpUI()
        FetchFaqListApi()
        faqTable.delegate = self
        faqTable.dataSource = self
        faqTable.register(UINib(nibName: "FaqTVC", bundle: nil), forCellReuseIdentifier: "FaqTVC")
     
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(faqApiCall(_:)),
                         name: NSNotification.Name ("faqApiCall"),                                           object: nil)
    }
    @objc func faqApiCall(_ notification: Notification) {
        FetchFaqListApi()
    }
    func setUpUI(){
        setUpLanguage()
        //Font colour
        goBackLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        footerLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        faqTital.textColor = MyTheme.buttonwhiteBackGroundColor
        //Font SIze
        goBackLbl.font = MyTheme.myFontMedium(18)
        footerLbl.font = MyTheme.myFontRegular(15)
        faqTital.font = MyTheme.myFontBold(28)
        // back ground colour
        mainBGView.backgroundColor = MyTheme.backGroundDarkGrayColor
    }
    func setUpLanguage(){
        faqTital.text = SetUpAppLanguage.shareInstance.AppLanguageData?.faq
        footerLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
        // About Screen
        goBackLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.returnSettings
    }
  
    @IBAction func btnback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
}

extension FAQVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if FaqData?.count == 0 {
            tableView.setEmptyMessage("No Record Found")
            return 0
           } else {
               tableView.restore()
               return FaqData?.count ?? 0
           }
        //return FaqData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = faqTable.dequeueReusableCell(withIdentifier: "FaqTVC") as! FaqTVC
        
        
        let answerStr = (FaqData?[indexPath.row].answer ?? "").stripOutHtml() ?? ""
        
        let content = "<html><body style = background-color:#3B3B3B><p><font size=15 color = #FFFFFF> \(FaqData?[indexPath.row].question ?? "")<br>\(answerStr)</br> </font></p><hr style= width:100%;text-align:left;margin-left:0;color:white></body></html>"
        cell.QuestionWebKit.loadHTMLString(content, baseURL: nil)
        
//        cell.QuestionWebKit.isOpaque = false
//        cell.QuestionWebKit.backgroundColor = UIColor.clear
//        cell.QuestionWebKit.scrollView.backgroundColor = UIColor.clear
        cell.webViewCallBack = {[weak self] in
            guard let self = self else{return}
            
            self.faqTable.beginUpdates()
            self.faqTable.endUpdates()
    
        }
       
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
extension String {

    func stripOutHtml() -> String? {
        do {
            guard let data = self.data(using: .unicode) else {
                return nil
            }
            let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributed.string
        } catch {
            return nil
        }
    }
}
