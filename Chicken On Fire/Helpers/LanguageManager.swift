//
//  LanguageManager.swift
//  Chicken On Fire
//
//  Created by user on 27/11/2021.
//

import Foundation

class LanguageManager {
    static var language: String {
        get {
            if let lang = UserDefaults.standard.string(forKey: "Language") {
                return lang
            }
            return "en"
        } set(lang) {
            UserDefaults.standard.setValue(lang, forKey: "Language")
            UserDefaults.standard.set([lang], forKey: "AppleLanguages")
        }
    }
}
