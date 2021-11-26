//
//  ReviewsApi.swift
//  Chicken On Fire
//
//  Created by user on 15/09/2021.
//

import Foundation

class ReviewsApi {
    static func getAverageRating(onSuccess: ((RestaurantRating) -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/get-avg-rating/") else {
            print("Failed to get URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(RestaurantInfoManager.apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(RestaurantRating.self, from: data)
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
    
    static func getReviews(onSuccess: (([Review]) -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/get-reviews/") else {
            onFailure?("Failed to get URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(RestaurantInfoManager.apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(Array<Review>.self, from: data)

                    DispatchQueue.main.async {
                        onSuccess?(decoded)
                    }
                    
                    return
                } catch {
                    onFailure?(error.localizedDescription)
                    return
                }
            }
            onFailure?("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    static func addReview(email: String, rating: Rating, comment: String, onSuccess: (() -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/mobile-add-review/") else {
            onFailure?("Failed to get URL")
            return
        }
        
        let parameters: [String: Any] = [
            "email": email,
            "orderPackaginRating": rating.orderPackaginRating,
            "valueForMoneyRating": rating.valueForMoneyRating,
            "deliveryTimeRating": rating.deliveryTimeRating,
            "qualityOfFoodRating": rating.qualityOfFoodRating,
            "comment": comment
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
                        let statusCode: Int = jsonResponse["statusCode"] as! Int
                        switch statusCode {
                        case 201:
                            onSuccess?()
                        case 404:
                            onFailure?("* Account not found")
                        default:
                            onFailure?("* Something went wrong. Please contact us to resolve the problem")
                        }
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
