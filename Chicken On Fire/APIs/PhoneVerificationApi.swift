//
//  PhoneVerificationApi.swift
//  Chicken On Fire
//
//  Created by user on 28/09/2021.
//

import Foundation

class PhoneVerificationApi {
    static func startPhoneVerification(verificationRequest: VerificationRequest, onSuccess: (() -> Void)?, onFailure: ((String) -> Void)?){
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/phone/start-verification/") else {
            onFailure?("Invalid Url")
            return
        }
        guard let encoded = try? JSONEncoder().encode(verificationRequest) else {
            onFailure?("Failed to encode verification request")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(RestaurantInfoManager.apiKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                onFailure?("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    let statusCode: Int = jsonResponse["statusCode"] as! Int
                    switch statusCode {
                    case 201:
                        onSuccess?()
                    case 405:
                        onFailure?("* Please wait at least 1 minute before sending another code")
                    case 403:
                        onFailure?("* You were forbidden to do the following request")
                    default:
                        onFailure?("* Something went wrong. Please contact us to resolve the problem")
                    }
                }
            } catch _ {
                onFailure?("* Something went wrong")
            }
        }.resume()
    }
    
    static func verifyCode(tokenVerificationRequest: TokenVericationRequest, onSuccess: (() -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/phone/token-verification/") else {
            onFailure?("Invalid Url")
            return
        }
        
        guard let encoded = try? JSONEncoder().encode(tokenVerificationRequest) else {
            onFailure?("Failed to encode")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(RestaurantInfoManager.apiKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                onFailure?("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    let statusCode: Int = jsonResponse["statusCode"] as! Int
                    switch statusCode {
                    case 201:
                        onSuccess?()
                    case 400:
                        onFailure?("* Sorry, the verification code you have entered is incorrect")
                    default:
                        onFailure?("* Something went wrong. Please contact us to resolve the problem")
                    }
                    }
            } catch _ {
                onFailure?("* Something went wrong")
            }
        }.resume()
    }
    
    static func restartPhoneVerification(verificationRequest: VerificationRequest, onSuccess: (() -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/phone/start-verification/") else {
            onFailure?("Invalid Url")
            return
        }
        guard let encoded = try? JSONEncoder().encode(verificationRequest) else {
            onFailure?("Failed to encode verification request")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(RestaurantInfoManager.apiKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                onFailure?("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    let statusCode: Int = jsonResponse["statusCode"] as! Int
                    switch statusCode {
                    case 201:
                        onSuccess?()
                    case 405:
                        onFailure?("* Please wait at least 1 minute before sending another code")
                    case 403:
                        onFailure?("* You were forbidden to do the following request")
                    default:
                        onFailure?("* Something went wrong. Please contact us to resolve the problem")
                    }
                    }
            } catch _ {
                onFailure?("* Something went wrong")
            }
        }.resume()
    }
}
