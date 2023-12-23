//
//  CarouselAPiCall.swift
//  FirstResponderApp
//
//  Created by bd10 on 21/11/22.
//

import Foundation
extension CarouselScreen{
    func getCarouselSettingApi(){
        Loader.showLoader(self.view)
        CarouselApiRequest.getCarouselApiCall({
            response in
            Loader.hideLoader(self.view)
            switch response {
            case .Success(let res) :
                if res.statusCode == 200 {
                    print("Api Success!")
                    self.CarouselData = res.carouselSetting
                    self.splashCollectionView.reloadData()
                }else{
                   
                    self.showToast(message: res.message ?? "")
                }
            case .CustomError(_) :
                self.showToast(message: serverIssueMsg)
            }
        })
    }
}
