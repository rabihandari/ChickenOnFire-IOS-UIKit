//
//  ScheduleValidity.swift
//  Chicken On Fire
//
//  Created by user on 01/10/2021.
//

import Foundation

class ScheduleOrder {
    static func checkIfValid(branchId: Int, date: String, onSuccess: ((Bool) -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/schedule-validity") else {
            onFailure?("Failed to get URL")
            return
        }
        
        
        let parameters: [String: Any] = [
            "brID": branchId,
            "schedule": date
        ]
        guard let encoded = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            onFailure?("Failed to encode")
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(RestaurantInfoManager.apiKey, forHTTPHeaderField: "Authorization")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        let available: Bool = jsonResponse["available"] as! Bool
                        onSuccess?(available)
                        
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
}
