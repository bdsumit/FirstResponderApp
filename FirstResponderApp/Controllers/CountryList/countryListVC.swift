//
//  countryListVC.swift
//  Kweeke
//
//  Created by bd01 on 2/8/21.
//  Copyright © 2021 saurabh. All rights reserved.
//

import UIKit
import Kingfisher


class countryListVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var countryTableView : UITableView!
    @IBOutlet var lblHeading: UILabel!
    @IBOutlet var searchBar : UITextField!
    
    var countryData = [CountryListPhoneCode]()
    var searchCountryData = [CountryListPhoneCode]()
    var selCountry : ((Int)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguage()
        BaseClassHelper.sharedInstance.getCountryListApi(self,{ countryList in
            self.countryData = countryList ?? []
            self.searchCountryData = countryList ?? []
            self.countryTableView.reloadData()
        })
        
        
        searchBar.delegate = self
        countryTableView.register(UINib(nibName : "countryListTVC",bundle: nil), forCellReuseIdentifier: "countryListTVC")
    }
    func setUpLanguage(){
        
        lblHeading.text = SetUpAppLanguage.shareInstance.AppLanguageData?.selectedCountry
        searchBar.placeholder = SetUpAppLanguage.shareInstance.AppLanguageData?.searchCountry
    }
    
    //MARK: - Custom methods

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if searchBar.text?.count ?? 0 > 2{
            let filteredStrings = countryData.filter({(item) -> Bool in
                let string = item.countryName ?? ""
                let stringMatch = string.lowercased().range(of: searchBar.text!.lowercased() ) //rangeOfString()
                return stringMatch != nil ? true : false
            })
            searchCountryData = filteredStrings
        }else if searchBar.text?.count == 0{
            searchCountryData = countryData
            
        }
        countryTableView.reloadData()
    }
    
}


//MARK: - Table View Set Up
extension countryListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCountryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countryTableView.dequeueReusableCell(withIdentifier: "countryListTVC") as! countryListTVC
        
        cell.lblFlage.text = "+\(self.searchCountryData[indexPath.row].countryCode ?? 0)"
        cell.lblCountryName.text = String(self.searchCountryData[indexPath.row].countryName ?? "")
     

        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selCountry?(self.searchCountryData[indexPath.row].countryCode ?? 0)
        self.dismiss(animated: true, completion: nil)
    }
}


