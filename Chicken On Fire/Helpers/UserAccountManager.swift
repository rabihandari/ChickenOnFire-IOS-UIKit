//
//  UserAccountManager.swift
//  Chicken On Fire
//
//  Created by user on 15/09/2021.
//

import Foundation

class UserAccountManager {
    static func savedUserAccount () -> UserAccount {
        if let account = UserDefaults.standard.data(forKey: "User Account") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(UserAccount.self, from: account) {
                return decoded
            }
        }
        return UserAccount(email: "", password: "", authenticated: false)
    }
    
    static func setUserAccount(account: UserAccount) -> Void {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(account) {
            UserDefaults.standard.set(encoded, forKey: "User Account")
        }
    }
    
    static func resetUserAccount() -> Void {
        let userAccount = UserAccount(email: "", password: "", authenticated: false)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userAccount) {
            UserDefaults.standard.set(encoded, forKey: "User Account")
        }
    }
}


struct UserAccount: Codable {
    var email: String
    var password: String
    var authenticated: Bool
}
