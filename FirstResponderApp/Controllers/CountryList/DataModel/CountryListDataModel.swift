//
//  CountryListDataModel.swift
//  FirstResponderApp
//
//  Created by bd05 on 11/26/22.
//

import Foundation
// MARK: - Welcome
struct CountryListDataModel: Codable {
    let message: String?
    let errorCode, statusCode: Int?
    let countryList: [CountryListPhoneCode]?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case errorCode, statusCode, countryList
    }
    
    static func getCountryListApiCall(_ completion : ((Result<CountryListDataModel>)->Void)?) {

    APICall.webRequest(apiType: .GET,endPoint: .countryList, param: nil, forceDecoding: true, decodableObj: CountryListDataModel.self, complection: {
            (res) in
            switch res {
            case .Success(let res, _):
                DispatchQueue.main.async {
                    completion?(.Success(res!))
                }
            case .CustomError(let str):
                DispatchQueue.main.async {
                    completion?(.CustomError(str))
                }
            }
        })
    }
}

// MARK: - CountryList
struct CountryListPhoneCode: Codable {
    let id: Int?
    let countryName, iso: String?
    let countryCode: Int?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case countryName = "CountryName"
        case iso = "ISO"
        case countryCode = "CountryCode"
    }
}
