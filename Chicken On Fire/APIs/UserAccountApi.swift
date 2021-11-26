//
//  UserAccountApi.swift
//  Chicken On Fire
//
//  Created by user on 15/09/2021.
//

import Foundation


class UserAccountApi {
    static func signIn(email: String, password: String, onSuccess: (() -> Void)? = nil, onFailure: ((String) -> Void)? = nil) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/users/mobile-signin/") else {
            onFailure?("Invalid Url")
            return
        }
        
        let parameters = ["email": email, "password": password]
        guard let encoded = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            onFailure?("Failed to encode data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(RestaurantInfoManager.apiKey, forHTTPHeaderField: "Authorization")
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
                        print("Login Success")
                        onSuccess?()
                    case 200:
                        onFailure?("* You are already logged in with this account")
                    case 404:
                        onFailure?("* The email or password you entered is incorrect")
                    default:
                        onFailure?("* Something went wrong. Please contact us to resolve the problem")
                    }
                }
            } catch _ {
                onFailure?(error?.localizedDescription ?? "Something went wrong")
            }
        }.resume()
        
    }
    
    
    static func createAccount(method: String, firstName: String, lastName: String, email: String, password: String, onSuccess: (() -> Void)? = nil, onFailure: ((String) -> Void)? = nil) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/users/mobile-register/") else {
            onFailure?("Invalid Url")
            return
        }
        
        let parameters = ["method": method, "fname": firstName, "lname": lastName, "email": email, "password": password]
        guard let encoded = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            onFailure?("Failed to encode data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(RestaurantInfoManager.apiKey, forHTTPHeaderField: "Authorization")
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
                        print("Create Account Successfull")
                        onSuccess?()
                    case 400:
                        onFailure?("* Account already exists")
                    default:
                        onFailure?("* Something went wrong. Please contact us to resolve the problem")
                    }
                }
            } catch _ {
                onFailure?("* Something went wrong")
            }
        }.resume()
    }
    
    static func resetPassword(email: String, onSuccess: (() -> Void)? = nil, onFailure: ((String) -> Void)? = nil) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/users/mobile-password-reset/") else {
            onFailure?("Invalid Url")
            return
        }
        
        let parameters = ["email": email]
        guard let encoded = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            onFailure?("Failed to encode data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(RestaurantInfoManager.apiKey, forHTTPHeaderField: "Authorization")
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
                        print("Create Account Successfull")
                        onSuccess?()
                    case 403:
                        onFailure?("* You've requested for a password reset too many time. Please wait at least 1 minute")
                    case 404:
                        onFailure?("* The email address you entered is not found")
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

