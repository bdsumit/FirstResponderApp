//
//  updateProfileApi.swift
//  FirstResponderApp
//
//  Created by bd10 on 25/11/22.
//

import Foundation
import UIKit
extension ProfileSettingVC{
    //MARK: - updateUserDetailsAPI
    func updateUserDetailsApi(updateUserDetailsParams : updateUserDetailsParams){
        Loader.showLoader(self.view)
        updateUserReq.updateUserDetailsApiCall(param:updateUserDetailsParams ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                   
                    if  self.storeProfileData.password != nil{
                        // forceFullyLogout
                        BaseClassHelper.sharedInstance.logoutApi(self)
                    }else{
                        self.showToast(message: res.message ?? "")
                        BaseClassHelper.sharedInstance.getUserDetailsApi(self , {userDetails,globelSettingData,alarmVisibilityListData in
                                              self.userDataFromApi = userDetails
                                              self.checkImg()
                                              self.ProfileSettingTv.reloadData()
                        })
                    }
                    
                 
                     
                }else{
                    self.showToast(message: res.userDetail?.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
               
            }
        })
    }
    
    //MARK: - uploadUserProfilePhotoAPI : -
    func uploadUserProfilePhotoApi(userId : Int,image: String ,changedImage : UIImage){
        Loader.showLoader(self.view)
        uploadUserProfilePhotoReq.uploadUserProfilePhotoApiCall(param:uploadUserProfilePhotoParams(userId: userId, Image: image) ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    self.showToast(message: res.message ?? "")
                   
                    self.initials.isHidden = false
                    self.profileImage.isHidden = false
                    self.profileImage.image = changedImage
            
                    BaseClassHelper.sharedInstance.getUserDetailsApi(self , {userDetails,globelSettingData,alarmVisibilityListData in
                                          self.userDataFromApi = userDetails
                                          self.checkImg()
                                          self.ProfileSettingTv.reloadData()
                    })
                }else{
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
    
    
    //MARK: - removeProfilePhotoApi : -
    func removeProfilePhotoApi(userId : Int){
        Loader.showLoader(self.view)
        removeProfileImageReq.removeProfilePhotoApiCall(param:removeProfilePhotoParams(userId: userId) ,{ response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 && res.errorCode == 0{
                    
                    self.showToast(message:  res.message ?? "")
                    self.profileImage.isHidden = true
                    self.initials.isHidden = false
                    let fNameFirst = self.userDataFromApi?.firstName?.first?.description ?? ""
                    let lNameFirst = self.userDataFromApi?.lastName?.first?.description ?? ""
                    let nameString = "\(fNameFirst.uppercased())\(lNameFirst.uppercased())"
                    self.initials.text = nameString
                    self.profileImage.image = nil
                   // self.ProfileSettingTv.reloadData()
                }else{
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(let str) :
                self.showToast(message: serverIssueMsg)
            }
           
        })
    }
    
}
