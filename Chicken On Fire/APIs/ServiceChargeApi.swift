//
//  ServiceFeeApi.swift
//  Chicken On Fire
//
//  Created by user on 28/09/2021.
//

import Foundation

class ServiceChargeApi {
    static func getServiceFee(branchId: Int, latitude: Double, longitude: Double, onSuccess: ((Double) -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/get-service-fee?brID=\(branchId)&latitude=\(latitude)&longitude=\(longitude)") else {
            onFailure?("Invalid Url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(RestaurantInfoManager.apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                onFailure?("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                
                    if let serviceFee: Double = jsonResponse["newServiceFee"] as? Double {
                        onSuccess?(serviceFee)
                    }else {
                        onFailure?("* Something went wrong")
                    }
                    
                }
            } catch _ {
                onFailure?("* Something went wrong")
            }
        }.resume()
    }
}
