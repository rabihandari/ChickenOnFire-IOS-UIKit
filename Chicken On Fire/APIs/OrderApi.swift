//
//  OrderApi.swift
//  Chicken On Fire
//
//  Created by user on 20/11/2021.
//

import Foundation


class OrderApi {
    static func sendOrder(order: Order, onSuccess: (() -> Void)?, onFailure: ((String) -> Void)?) {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/send-order/") else {
            onFailure?("Invalid Url")
            return
        }
        
        guard let encoded = try? JSONEncoder().encode(order) else {
            onFailure?("Failed to encode order")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(RestaurantInfoManager.apiKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 403 {
                    onFailure?("Bad Input")
                } else {
                    onSuccess?()
                }
            } else {
                onFailure?("Something went wrong")
            }
        }.resume()
    }
}
