//
//  GeneralInfoApi.swift
//  Chicken On Fire
//
//  Created by user on 15/09/2021.
//

import Foundation
import MapKit

class GeneralInfoApi {
    static func getGeneralInfo(email: String, password: String, branchID: Int? = nil, onSuccess: ((GeneralInfo) -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/general-info") else {
            print("Invalide URL")
            return
        }
        
        var parameters: [String: Any] = ["email": email, "password": password]
        if branchID != nil {
            parameters["brID"] = branchID!
        }
        guard let encoded = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            onFailure?("Failed to encode data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(RestaurantInfoManager.apiKey, forHTTPHeaderField: "Authorization")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(GeneralInfo.self, from: data)
                    onSuccess?(decoded)
                    
                } catch {
                    onFailure?(error.localizedDescription)
                }
            } else {
                onFailure?(error?.localizedDescription ?? "Unknown Error")
            }
        }.resume()
    }
    
    
    static func getBranchInfo(coordinates: CLLocationCoordinate2D, onSuccess: ((BranchInfo) -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/setBranch/") else {
            print("Invalide URL")
            return
        }
        
        let parameters = ["latitude": coordinates.latitude, "longitude": coordinates.longitude]
        guard let encoded = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            onFailure?("Failed to encode data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(RestaurantInfoManager.apiKey, forHTTPHeaderField: "Authorization")
        request.httpBody = encoded
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(BranchInfo.self, from: data)
                    onSuccess?(decoded)
                    
                } catch {
                    onFailure?(error.localizedDescription)
                    print(error)
                }
            } else {
                onFailure?(error?.localizedDescription ?? "Unknown Error")
            }
        }.resume()
    }
}

