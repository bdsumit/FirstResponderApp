//
//  FeedbackVC.swift
//  Alecom
//
//  Created by bd01 on 15/09/22.
//

import UIKit
import Kingfisher
class FeedbackVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var goBackLbl: UILabel!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var feedBackTital: UILabel!
    @IBOutlet weak var FeedbackTable: UITableView!
    @IBOutlet weak var feedbackDesciption: UILabel!
    @IBOutlet weak var feedBackTv: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var footerTital: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    var idAlarmFromAccRejComp = 0
    
    var AddFeedbackArray = [SendFeedbackParam]()
    var FeedBackData : [FeedBackList]?
    var fromFeedback = ""
    var questionId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getDescription()
        if fromFeedback == "ApplicationFeedback"{
            ApplicationFeedBackApi()
        }else if fromFeedback == "RejectFeedback"{
            goBackLbl.isHidden = true
            RejectFeedBackListApi()
        }else if fromFeedback == "CompleteAlarmFeedback"{
            goBackLbl.isHidden = true
            AlarmCompleteFeedBackApi()
        }
        
        FeedbackTable.delegate = self
        FeedbackTable.dataSource = self
        FeedbackTable.register(UINib(nibName: "BtnTVC", bundle: nil), forCellReuseIdentifier: "BtnTVC")
        FeedbackTable.register(UINib(nibName: "DescriptionTVC", bundle: nil), forCellReuseIdentifier: "DescriptionTVC")
        
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(faqApiCall(_:)),
                         name: NSNotification.Name ("syncSetting"),                                           object: nil)
    }
    func getDescription(){
        BaseClassHelper.sharedInstance.GetGlobelSettingApi(self, {GlobleSettingData in
            
            for GlobelSettingDetail in GlobleSettingData ?? []{
                if GlobelSettingDetail.settingName == "Feedback"{
                    self.feedbackDesciption.text = GlobelSettingDetail.settingValue
                }
                
            }})
    }
        
    
    @objc func faqApiCall(_ notification: Notification) {
        if fromFeedback == "ApplicationFeedback"{
            ApplicationFeedBackApi()
        }else if fromFeedback == "RejectFeedback"{
            goBackLbl.isHidden = true
            RejectFeedBackListApi()
        }else if fromFeedback == "CompleteAlarmFeedback"{
            goBackLbl.isHidden = true
            AlarmCompleteFeedBackApi()
        }
        
        getDescription()
    }

    func setUpUI(){
        setUpLanguage()
        //Font colour
        goBackLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        footerTital.textColor = MyTheme.buttonwhiteBackGroundColor
        feedBackTital.textColor = MyTheme.buttonwhiteBackGroundColor
        feedbackDesciption.textColor = MyTheme.buttonwhiteBackGroundColor

        //Font SIze
        goBackLbl.font = MyTheme.myFontMedium(18)
        footerTital.font = MyTheme.myFontRegular(15)
        feedBackTital.font = MyTheme.myFontBold(28)
        
        feedbackDesciption.font = MyTheme.myFontSemiBold(22)
        // back ground colour
        sendBtn.backgroundColor = MyTheme.buttonBlackBackGroundColor
        closeBtn.backgroundColor = MyTheme.buttonBlackBackGroundColor
        viewBG.backgroundColor = MyTheme.backGroundDarkGrayColor
    }
    func setUpLanguage(){
        
        footerTital.text = SetUpAppLanguage.shareInstance.AppLanguageData?.copyright
        feedBackTital.text = SetUpAppLanguage.shareInstance.AppLanguageData?.feedback
        
        goBackLbl.text = SetUpAppLanguage.shareInstance.AppLanguageData?.returnSettings
        sendBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.send, for: .normal)
        closeBtn.setTitle(SetUpAppLanguage.shareInstance.AppLanguageData?.close, for: .normal)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        if fromFeedback == "RejectFeedback"{
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: DashBoardVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }}else if fromFeedback == "CompleteAlarmFeedback"{
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: DashBoardVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }}else{
                self.navigationController?.popViewController(animated: true)
            }
                
        
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        if fromFeedback == "ApplicationFeedback"{
            self.navigationController?.popViewController(animated: true)
        }else{
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: DashBoardVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }}

        }
        
    }
    
    @IBAction func sendBtn(_ sender: Any) {
  
        if AddFeedbackArray.count > 0 {
            SendFeedBackApi()
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        let currObj = FeedBackData?[textView.tag]
     
        checkQuestionIdData(questionId: (currObj?.questionID ?? 0), sectionVal: textView.tag, indexVal: 0, textViewTextWritten: textView.text)
    }
    
    func checkQuestionIdData (questionId : Int , sectionVal : Int , indexVal : Int ,textViewTextWritten : String? = nil){
        if textViewTextWritten != nil {
            if AddFeedbackArray.contains(where: {$0.questionID == questionId}){
                
                if textViewTextWritten == ""{
                    
                    let indexCurrent = AddFeedbackArray.firstIndex(where: {$0.questionID == questionId}) ?? 0
                    
                    let getIndexOfAnsId = AddFeedbackArray[indexCurrent].answerID?.firstIndex(of: FeedBackData?[sectionVal].answers?[indexVal].answerID ?? 0) ?? 0
                    AddFeedbackArray[indexCurrent].answerID?.remove(at: getIndexOfAnsId)
                    
                    let getIndexOfAnsTxt = AddFeedbackArray[indexCurrent].answer?.firstIndex(of: FeedBackData?[sectionVal].answers?[indexVal].answerText ?? "") ?? 0
                    AddFeedbackArray[indexCurrent].answer?.remove(at: getIndexOfAnsTxt)
                    
                    if (AddFeedbackArray[indexCurrent].answer?.count ?? 0) <= 0{
                        AddFeedbackArray.remove(at: indexCurrent)
                    }
                    
                }else{
                    let indexCurrent = AddFeedbackArray.firstIndex(where: {$0.questionID == questionId}) ?? 0
                    
                    let getIndexOfAnsTxt = AddFeedbackArray[indexCurrent].answer?.firstIndex(of: FeedBackData?[sectionVal].answers?[indexVal].answerText ?? "") ?? 0
                    AddFeedbackArray[indexCurrent].answer?[getIndexOfAnsTxt] = textViewTextWritten ?? ""
                }
                
              
                
                
            }else{
                var feedBackReq = SendFeedbackParam(userID: 0, questionID: 0, feedbackTypeID: 0, questionType: "", answerID: [], answer: [], alarmID: 0)
                
                let userId = UserPersonalDetail.fetchUserDetail()?.userID
                feedBackReq.userID = userId
                
                if fromFeedback == "ApplicationFeedback"{
                    feedBackReq.feedbackTypeID = 1
                }else if fromFeedback == "RejectFeedback"{
                    feedBackReq.feedbackTypeID = 3
                    feedBackReq.alarmID = idAlarmFromAccRejComp
                }else {
                    feedBackReq.feedbackTypeID = 2
                    feedBackReq.alarmID = idAlarmFromAccRejComp
                }
                
                feedBackReq.questionID = questionId
                feedBackReq.questionType = FeedBackData?[sectionVal].questionType ?? ""
                
                feedBackReq.answerID?.append(FeedBackData?[sectionVal].answers?[indexVal].answerID ?? 0)
                feedBackReq.answer?.append(textViewTextWritten ?? "")
                
                AddFeedbackArray.append(feedBackReq)
            }
        }else{
            if AddFeedbackArray.contains(where: {$0.questionID == questionId }){
                let indexCurrent = AddFeedbackArray.firstIndex(where: {$0.questionID == questionId}) ?? 0
                
                if AddFeedbackArray[indexCurrent].answerID?.contains(FeedBackData?[sectionVal].answers?[indexVal].answerID ?? 0) == true {
                    let getIndexOfAnsId = AddFeedbackArray[indexCurrent].answerID?.firstIndex(of: FeedBackData?[sectionVal].answers?[indexVal].answerID ?? 0) ?? 0
                    AddFeedbackArray[indexCurrent].answerID?.remove(at: getIndexOfAnsId)
                }else{
                    AddFeedbackArray[indexCurrent].answerID?.append(FeedBackData?[sectionVal].answers?[indexVal].answerID ?? 0)
                   
                }
                
                if AddFeedbackArray[indexCurrent].answer?.contains(FeedBackData?[sectionVal].answers?[indexVal].answerText ?? "") == true {
                    let getIndexOfAnsTxt = AddFeedbackArray[indexCurrent].answer?.firstIndex(of: FeedBackData?[sectionVal].answers?[indexVal].answerText ?? "") ?? 0
                    AddFeedbackArray[indexCurrent].answer?.remove(at: getIndexOfAnsTxt)
                }else{
                    AddFeedbackArray[indexCurrent].answer?.append(FeedBackData?[sectionVal].answers?[indexVal].answerText ?? "")
                }
                
                if (AddFeedbackArray[indexCurrent].answer?.count ?? 0) <= 0{
                    AddFeedbackArray.remove(at: indexCurrent)
                }
                
                
            }else{
                var feedBackReq = SendFeedbackParam(userID: 0, questionID: 0, feedbackTypeID: 0, questionType: "", answerID: [], answer: [], alarmID: 0)
                
                let userId = UserPersonalDetail.fetchUserDetail()?.userID
                feedBackReq.userID = userId

                if fromFeedback == "ApplicationFeedback"{
                    feedBackReq.feedbackTypeID = 1
                }else if fromFeedback == "RejectFeedback"{
                    feedBackReq.feedbackTypeID = 3
                   feedBackReq.alarmID = idAlarmFromAccRejComp
                }else {
                    feedBackReq.feedbackTypeID = 2
                    feedBackReq.alarmID = idAlarmFromAccRejComp
                }
               
                feedBackReq.questionID = questionId
               feedBackReq.questionType = FeedBackData?[sectionVal].questionType ?? ""
    
                    feedBackReq.answerID?.append(FeedBackData?[sectionVal].answers?[indexVal].answerID ?? 0)
                    feedBackReq.answer?.append(FeedBackData?[sectionVal].answers?[indexVal].answerText ?? "")
                
               
                
                AddFeedbackArray.append(feedBackReq)
              }
        }
        
        
    }
    
    
}
// MARK: - TABLE VIEW

extension FeedbackVC : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
       return FeedBackData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return FeedBackData?[section].answers?.count ?? 0

    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
            let label = UILabel()
            label.frame = CGRect.init(x: 20 , y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
            
            label.font = MyTheme.myFontMedium(18)
            label.textColor = .white
            
            headerView.addSubview(label)
        label.text = FeedBackData?[section].questionText
      
            return headerView
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if FeedBackData?[indexPath.section].questionType == "Text"{
            let cell = FeedbackTable.dequeueReusableCell(withIdentifier: "DescriptionTVC") as! DescriptionTVC
            cell.descriptionLbl.isHidden = true
            cell.descriptionTextView.tag = indexPath.section
            cell.descriptionTextView.delegate = self
            cell.descriptionTextView.textColor = MyTheme.buttonBlackBackGroundColor
  
            
            let getMatchObj = AddFeedbackArray.filter({$0.questionID == FeedBackData?[indexPath.section].questionID})
            
            if getMatchObj.count > 0{
                cell.descriptionTextView.text = getMatchObj[0].answer?[0]
            }else{
                cell.descriptionTextView.text = ""
            }
            
           
            return cell
            
        }else{
            let cell = FeedbackTable.dequeueReusableCell(withIdentifier: "BtnTVC") as! BtnTVC
            cell.LblTittle.textColor = MyTheme.buttonBlackBackGroundColor
            cell.viewBG.backgroundColor = MyTheme.buttonwhiteBackGroundColor
            if AddFeedbackArray.contains(where: {$0.questionID == FeedBackData?[indexPath.section].questionID ?? 0 }){
                let indexCurrent = AddFeedbackArray.firstIndex(where: {$0.questionID == FeedBackData?[indexPath.section].questionID}) ?? 0
                if AddFeedbackArray[indexCurrent].answerID?.contains(FeedBackData?[indexPath.section].answers?[indexPath.row].answerID ?? 0) == true {

                    cell.viewBG.backgroundColor = MyTheme.greenColor
                }else{
                    cell.viewBG.backgroundColor = MyTheme.buttonwhiteBackGroundColor
                   
                }
            }
            
            
            if FeedBackData?[indexPath.section].questionType ?? "" == "Emoji" {
                cell.imageEmoji.isHidden = false
                cell.LblTittle.isHidden = true
                let emojiUrl = "\(SoundbaseUrl)\((FeedBackData?[indexPath.section].answers?[indexPath.row].emojiImage ?? ""))"
                
                let url = URL(string: emojiUrl)
                cell.imageEmoji.kf.setImage(with: url)
           
            }else{
                cell.imageEmoji.isHidden = true
                cell.LblTittle.isHidden = false
                cell.LblTittle.text = FeedBackData?[indexPath.section].answers?[indexPath.row].answerText
            }
            
           
           
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if FeedBackData?[indexPath.section].questionType == "Text"{
            return 150
        }else{
            return UITableView.automaticDimension
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        checkQuestionIdData(questionId : FeedBackData?[indexPath.section].questionID ?? 0 ,sectionVal :  indexPath.section, indexVal : indexPath.row , textViewTextWritten : nil)
        questionId = FeedBackData?[indexPath.section].questionID ?? 0
        self.FeedbackTable.reloadData()
        
    }
    
   
    
}
