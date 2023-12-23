//
//  statusAndDaysTVC.swift
//  FirstResponderApp
//
//  Created by bd10 on 16/11/22.
//

import UIKit
import WebKit
class FaqTVC: UITableViewCell, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var QuestionLbl: UILabel!
    
    @IBOutlet weak var QuestionWebKit: WKWebView!
    @IBOutlet weak var AnswerLbl: UILabel!
   @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    var webViewCallBack: (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        QuestionWebKit.uiDelegate = self
        QuestionWebKit.navigationDelegate = self
   }
    
 override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
//    func webView(_ webView: WKWebView, didFinish  navigation: WKNavigation!){
//
//        //webview height
//        webView.frame.size.height = 1
//        webView.frame.size = webView.sizeThatFits(.zero)
//        webView.scrollView.isScrollEnabled = false
//        let height = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")
//        if let height = height {
//            if let heightInt = Int(height) {
//                let heightFloat = Float(heightInt)
//
//                webViewHeightConstraint.constant = CGFloat(heightFloat)
//            }
//        }
//        QuestionWebKit.scalesPageToFit = true
//    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        
//        webView.evaluateJavaScript("document.documentElement.scrollHeight") { (height, error) in
//            self.webViewHeightConstraint.constant = height as! CGFloat
//            self.webViewCallBack?()
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.webViewHeightConstraint.constant = self.QuestionWebKit.scrollView.contentSize.height
            self.webViewCallBack?()
        }
        
//        self.QuestionWebKit.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
//            if complete != nil {
//                self.QuestionWebKit.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
//                    self.webViewHeightConstraint.constant = height as! CGFloat
//                })
//            }
//
//        })
    }
}
