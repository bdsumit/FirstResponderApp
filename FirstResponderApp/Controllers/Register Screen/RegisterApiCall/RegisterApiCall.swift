//
//  RegisterApiCall.swift
//  FirstResponderApp
//
//  Created by bd10 on 21/11/22.
//

import Foundation
import UIKit

extension RegisterScreen{
    func registerUserApi(){
        
        Loader.showLoader(self.view)
        RegisterApiRequest.registerApiCall(param: registerParams(emailId: storeRegistrationData.email, firstName: storeRegistrationData.firstName, lastName: storeRegistrationData.lastname, alias: "abcd", password: storeRegistrationData.password, phone: storeRegistrationData.phoneNumber, isDeleted: false, isApproved: false, deviceId: "", certificateId: "", macId: "", workingPlace: storeRegistrationData.workplace, profession: storeRegistrationData.ProffesionalTital, CPREducation: storeRegistrationData.cprTraining, countryCode: storeRegistrationData.countryPhoneCode),{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    print("Api Success!")
                    let vc = SuccessfullRegisterVC (nibName: "SuccessfullRegisterVC", bundle: nil)
                    vc.email = self.storeRegistrationData.email
                    vc.SuccessMsg = res.message ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
    
    
    
    
// mark :- Check Registration

func CheckRegisterUserApi(){
    
    Loader.showLoader(self.view)
    CheckRegistrationRequest.CheckRegisterApiCall(param: registerParams(emailId: storeRegistrationData.email, firstName: storeRegistrationData.firstName, lastName: storeRegistrationData.lastname, alias: "abcd", password: storeRegistrationData.password, phone: storeRegistrationData.phoneNumber, isDeleted: false, isApproved: false, deviceId: "", certificateId: "", macId: "", workingPlace: storeRegistrationData.workplace, profession: storeRegistrationData.ProffesionalTital, CPREducation: storeRegistrationData.cprTraining, countryCode: storeRegistrationData.countryPhoneCode),{ response in
        Loader.hideLoader(self.view)
        switch response {
        case .Success(let res) :
            if res.statusCode == 200 && res.errorCode == 0{
                print("Check Registration Api Success!")
                let vc = TermsOfUsesVC(nibName: "TermsOfUsesVC", bundle: nil)
                vc.RegisterUserClicked = {[weak self] in
                    guard let self = self else{ return}
                    self.registerUserApi()
                }
               self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.showToast(message: res.message ?? "")
            }
        case .CustomError(let str) :
            self.showToast(message: serverIssueMsg)
        }
    })
}
}

    
    
