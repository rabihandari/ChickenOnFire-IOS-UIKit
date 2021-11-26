//
//  PaymentManager.swift
//  Chicken On Fire
//
//  Created by user on 04/10/2021.
//
import CryptoKit
import Foundation

class PaymentApi {
    static func getPayUrl(paymentMethod: PaymentMethod, total: Double, onSuccess: ((String) -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: "https://pg.bookeey.com/internalapi/api/payment/requestLink") else {
            onFailure?("Invalid Url")
            return
        }
        
        let merchantID = GeneralInfoManager.getGeneralInfo()?.BOOKEY_MERCHANT_ID ?? ""
        let subMerchantID = GeneralInfoManager.getGeneralInfo()?.BOOKEY_SUB_MERCHANT_ID ?? ""
        let secretKey = GeneralInfoManager.getGeneralInfo()?.BOOKEY_SECRET_KEY ?? ""
        let FURL = "https://www.bookeey.com/portal/paymentfailure"
        let SURL = "https://www.bookeey.com/portal/paymentSuccess?k=\(secretKey)"
        
//        let merchantID = "mer2000011"
//        let subMerchantID = "mer2000011"
//        let secretKey = "9343336"
//        let FURL = "https://demo.bookeey.com/portal/paymentfailure"
//        let SURL = "https://demo.bookeey.com/portal/paymentSuccess"
        
        let Txn_HDR = Int(generateRandomNumber(digits: 16))!
        let Merch_Txn_UID = Int(generateRandomNumber(digits: 10))!
        
        let inputString = "\(merchantID) | \(Merch_Txn_UID) | \(SURL) | \(SURL) | \(total) | GEN | \(secretKey) | \(Int(generateRandomNumber(digits: 10))!)"
        let inputData = Data(inputString.utf8)
        let hashed = SHA512.hash(data: inputData)
        
        
        let parameters: [String: Any] = [
            "DBRqst": "PY_ECom",
            "Do_Appinfo": [
                "APIVer": "1.6",
                "APPID": "",
                "APPTyp": "MOB",
                "AppVer": "1.0",
                "Country": "",
                "DevcType": "5",
                "HsCode": "",
                "IPAddrs": "",
                "MdlID": "",
                "OS": "IOS",
                "UsrSessID": ""
            ],
            "Do_MerchDtl": [
                "BKY_PRDENUM": "ECom",
                "FURL": FURL,
                "MerchUID": String(merchantID),
                "SURL": SURL
            ],
            "Do_MoreDtl": [
                "Cust_Data1": "",
                "Cust_Data2": "",
                "Cust_Data3": ""
            ],
            "Do_PyrDtl": [
                "Pyr_MPhone": "",
                "Pyr_Name": ""
            ],
            "Do_TxnDtl": [
                [
                   "SubMerchUID": String(subMerchantID),
                   "Txn_AMT": String(total)
               ]
            ],
            "Do_TxnHdr": [
                "BKY_Txn_UID": "",
                "Merch_Txn_UID": String(Merch_Txn_UID),
                "PayFor": "ECom",
                "PayMethod": paymentMethod == .knet ? "KNET" : "credit",
                "Txn_HDR": String(Txn_HDR),
                "hashMac": String(describing: hashed)
            ]
        ]
        
        guard let encoded = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            onFailure?("Failed to encode")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        let payUrl: String = jsonResponse["PayUrl"] as! String
                        
                        if payUrl.isEmpty {
                            onFailure?("Pay url is empty")
                        } else {
                            onSuccess?(payUrl)
                        }
                        return
                        
                    }
                } catch {
                    onFailure?(error.localizedDescription)
                    return
                }
            } else {
                onFailure?("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
        
        
    }
    
    static func generateRandomNumber(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }
    
    
}
