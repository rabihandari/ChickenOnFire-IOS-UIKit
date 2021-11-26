//
//  GeneralInfoManager.swift
//  Chicken On Fire
//
//  Created by user on 15/09/2021.
//

import Foundation

class GeneralInfoManager {
    static func getGeneralInfo() -> GeneralInfo? {
        if let area = UserDefaults.standard.data(forKey: "General Info") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(GeneralInfo.self, from: area) {
                return decoded
            }
        }
        return nil
    }
    
    static func setGeneralInfo(generalInfo: GeneralInfo) -> Void {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(generalInfo) {
            UserDefaults.standard.set(encoded, forKey: "General Info")
        }
    }
    
    static func setBranchInfo(branchInfo: BranchInfo) -> Void {
        if let generalInfo = GeneralInfoManager.getGeneralInfo() {
            generalInfo.openingTimes = branchInfo.openingTimes
            generalInfo.latitude = Double(branchInfo.latitude)
            generalInfo.longitude = Double(branchInfo.longitude)
            generalInfo.status = branchInfo.status
            generalInfo.phoneNumber = branchInfo.phoneNumber
            GeneralInfoManager.setGeneralInfo(generalInfo: generalInfo)
        }
        
    }
}

class GeneralInfo: Codable {
    var Cuisine: String
    var Cuisine_Second_Language: String
    var About_Vendor: String
    var About_Vendor_Second_Language: String
    var Minimum_Order: Double
    var AVG_Service_Fee: Double
    var Pre_Order: Bool
    var Payment_Methods: [String]
    var Social_Media: SocialMediaAccounts
    var Vendor_Email: String
    var Vendor_Password: String
    var TWILIO_SECURITY_API_KEY: String
    var Delivery_Time: Int
    var BOOKEY_MERCHANT_ID: String
    var BOOKEY_SUB_MERCHANT_ID: String
    var BOOKEY_SECRET_KEY: String
    var Website_Url: String
    var Digital_Experts: String
    var Privacy_Policy: String
    var featuredItems: [String]
    var authenticated: Bool
    var Enable_CodAndSchedule: Bool
    var Enable_Phone_Verification: Bool
    
    // Branch Info
    var openingTimes: OpeningTimes?
    var latitude: Double?
    var longitude: Double?
    var status: String?
    var phoneNumber: String?
    
    
    internal init(Cuisine: String, Cuisine_Second_Language: String, About_Vendor: String, About_Vendor_Second_Language: String, Minimum_Order: Double, AVG_Service_Fee: Double, Pre_Order: Bool, Payment_Methods: [String], Social_Media: SocialMediaAccounts, Vendor_Email: String, Vendor_Password: String, TWILIO_SECURITY_API_KEY: String, Delivery_Time: Int, BOOKEY_MERCHANT_ID: String, BOOKEY_SUB_MERCHANT_ID: String, BOOKEY_SECRET_KEY: String, Website_Url: String, Digital_Experts: String, Privacy_Policy: String, featuredItems: [String], authenticated: Bool, openingTimes: OpeningTimes? = nil, latitude: Double? = nil, longitude: Double? = nil, status: String? = nil, phoneNumber: String? = nil, Enable_CodAndSchedule: Bool, Enable_Phone_Verification: Bool) {
        self.Cuisine = Cuisine
        self.Cuisine_Second_Language = Cuisine_Second_Language
        self.About_Vendor = About_Vendor
        self.About_Vendor_Second_Language = About_Vendor_Second_Language
        self.Minimum_Order = Minimum_Order
        self.AVG_Service_Fee = AVG_Service_Fee
        self.Pre_Order = Pre_Order
        self.Payment_Methods = Payment_Methods
        self.Social_Media = Social_Media
        self.Vendor_Email = Vendor_Email
        self.Vendor_Password = Vendor_Password
        self.TWILIO_SECURITY_API_KEY = TWILIO_SECURITY_API_KEY
        self.Delivery_Time = Delivery_Time
        self.BOOKEY_MERCHANT_ID = BOOKEY_MERCHANT_ID
        self.BOOKEY_SUB_MERCHANT_ID = BOOKEY_SUB_MERCHANT_ID
        self.BOOKEY_SECRET_KEY = BOOKEY_SECRET_KEY
        self.Website_Url = Website_Url
        self.Digital_Experts = Digital_Experts
        self.Privacy_Policy = Privacy_Policy
        self.featuredItems = featuredItems
        self.authenticated = authenticated
        self.openingTimes = openingTimes
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
        self.phoneNumber = phoneNumber
        self.Enable_CodAndSchedule = Enable_CodAndSchedule
        self.Enable_Phone_Verification = Enable_Phone_Verification
    }
}



struct SocialMediaAccounts: Codable {
    var Vendor_Accounts: [VendorAccount]
}

struct VendorAccount: Codable {
    var Link: String
    var name: String
}


struct BranchInfo: Codable {
    var brID: Int
    var openingTimes: OpeningTimes
    var latitude: String
    var longitude: String
    var status: String
    var phoneNumber: String
}

struct OpeningTimes: Codable {
    var Monday: WorkingDay
    var Tuesday: WorkingDay
    var Wednesday: WorkingDay
    var Thursday: WorkingDay
    var Friday: WorkingDay
    var Saturday: WorkingDay
    var Sunday: WorkingDay
}

struct WorkingDay: Codable {
    var opiningHour: Int
    var closingHour: Int
    var opiningMin: Int
    var closingMin: Int
}
