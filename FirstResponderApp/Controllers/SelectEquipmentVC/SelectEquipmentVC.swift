//
//  SelectEquipmentVC.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/22/22.
//

import UIKit

class SelectEquipmentVC: UIViewController {

    @IBOutlet weak var recieveAtLbl: UILabel!
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var footerLbl: UILabel!
    @IBOutlet weak var tableViewEquipment: UITableView!
    @IBOutlet weak var segmentControllEquipment: UISegmentedControl!
    var array = ["fdjkljhghjgfhg fgdggjg dfghgh fdjkljhghjgfhg fgdggjg dfghgh fdjkljhghjgfhg fgdggjg dfghgh","fdjkljhghjgfhg","fdjkljhghjgfhg fgdggjg dfghgh ","dfsfds gfgfd ","bdsghdswd hajfhydjf fdshjfhdsjf fdhkjs "]
    var IConArraySegFirst = ["info","emergency","mission"]
    var IConArraySegSecond = ["user","location","location","phone","info"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewEquipment.delegate = self
        tableViewEquipment.dataSource = self
        tableViewEquipment.register(UINib(nibName: "VictimTvCell", bundle: nil), forCellReuseIdentifier: "VictimTvCell")
        tableViewEquipment.register(UINib(nibName: "AlarmDetailTvCell", bundle: nil), forCellReuseIdentifier: "AlarmDetailTvCell")
        tableViewEquipment.register(UINib(nibName: "MissionDetailTvCell", bundle: nil), forCellReuseIdentifier: "MissionDetailTvCell")
        setUpUI()
    }
    
    func setUpUI(){
        //Font colour
        footerLbl.textColor = MyTheme.buttonwhiteBackGroundColor
        recieveAtLbl.textColor = MyTheme.buttonwhiteBackGroundColor
    
        recieveAtLbl.font =  MyTheme.myFontSemiBold(21)
        footerLbl.font = MyTheme.myFontRegular(15)
        // back ground colour
        bgView.backgroundColor = MyTheme.backGroundDarkGrayColor
        headerView.backgroundColor = MyTheme.backGroundDarkRedColor
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func segmentControlr(_ sender: Any) {
        tableViewEquipment.reloadData()
    }

}
extension SelectEquipmentVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControllEquipment.selectedSegmentIndex == 1 {
            return 6
        }else{
            return 5
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentControllEquipment.selectedSegmentIndex == 1 {
            if indexPath.row == 0 {
                let cell = tableViewEquipment.dequeueReusableCell(withIdentifier: "VictimTvCell") as! VictimTvCell
                cell.heartIcon.image = UIImage(named: "RoundDef")
                cell.victimLbl.text = "Download the defibrillator"
                return cell
            }else{
                let cell = tableViewEquipment.dequeueReusableCell(withIdentifier: "MissionDetailTvCell") as! MissionDetailTvCell
           // cell.settingTxt.text = SettingArray[indexPath.row]
                cell.textLbl.text = array[indexPath.row - 1]
                cell.icon.image = UIImage(named: IConArraySegSecond[indexPath.row - 1])
                return cell
            }

        }else{
            if indexPath.row == 0 {
                let cell = tableViewEquipment.dequeueReusableCell(withIdentifier: "VictimTvCell") as! VictimTvCell
                cell.heartIcon.image = UIImage(named: "RoundBrokenHeart")
                cell.victimLbl.text = "Get to the victim"
                
             
                return cell
            }else if  indexPath.row == 1 {
                let cell = tableViewEquipment.dequeueReusableCell(withIdentifier: "AlarmDetailTvCell") as! AlarmDetailTvCell
                
                return cell
            }else{
                let cell = tableViewEquipment.dequeueReusableCell(withIdentifier: "MissionDetailTvCell") as! MissionDetailTvCell
                cell.icon.image = UIImage(named: IConArraySegFirst[indexPath.row - 2])
       
            
                return cell
            }

        }

      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
