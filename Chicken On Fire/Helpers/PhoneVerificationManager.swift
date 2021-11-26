//
//  PhoneVerificationManager.swift
//  Chicken On Fire
//
//  Created by user on 28/09/2021.
//

import Foundation

class PhoneVerificationManager {
    static var phoneNumbers: [VerifiedPhoneNumber] {
        get{
            if let items = UserDefaults.standard.data(forKey: "Verified Phone Numbers") {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode([VerifiedPhoneNumber].self, from: items) {
                    return decoded
                }
            }
            
            return []
        }
        set(numbers){
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(numbers){
                UserDefaults.standard.set(encoded, forKey: "Verified Phone Numbers")
            }
        }
    }
    
}

struct VerifiedPhoneNumber: Codable{
    var phoneNumber: String
    var phoneCode: String
}


struct VerificationRequest: Codable {
    var phone_number: Int
    var country_code: Int
    var via: String
}

struct TokenVericationRequest: Codable {
    var phone_number: Int
    var country_code: Int
    var token: String
}
