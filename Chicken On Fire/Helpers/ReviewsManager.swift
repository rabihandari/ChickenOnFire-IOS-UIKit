//
//  ReviewsManager.swift
//  Chicken On Fire
//
//  Created by Rabih Andari on 6/5/21.
//  Copyright © 2021 Rabih Andari. All rights reserved.
//

import Foundation


class ReviewsManager {
    var rating: Rating
    
    init(rating: Rating) {
        self.rating = rating
    }
    
    func getAverage() -> Int {
        var avgRating = (self.rating.orderPackaginRating + self.rating.valueForMoneyRating + self.rating.deliveryTimeRating + self.rating.qualityOfFoodRating)/4
        avgRating.round()
        return Int(avgRating)
    }
    
    func getFace() -> String {
        switch self.getAverage() {
        case 1:
            return "very_bad_face_icon"
        case 2:
            return "bad_face_icon"
        case 3:
            return "normal_face_icon"
        case 4:
            return "good_face_icon"
        case 5:
            return "excellent_face_icon"
        default:
            return "good_face_icon"
        }
    }
    
    
    func getStatus() -> String {
        switch self.getAverage() {
        case 1:
            return "Very Bad".localized()
        case 2:
            return "Bad".localized()
        case 3:
            return "Good".localized()
        case 4:
            return "Very Good".localized()
        case 5:
            return "Amazing".localized()
        default:
            return "Very Good".localized()
        }
    }
    
    func getRating() -> Rating {
        return self.rating
    }
}

struct RestaurantRating: Codable {
    var orderPackaginRating: Double = 5
    var valueForMoneyRating: Double = 5
    var deliveryTimeRating: Double = 5
    var qualityOfFoodRating: Double = 5
    var total: Int = 0
    
    func getRating() -> Rating {
        return Rating(orderPackaginRating: orderPackaginRating, valueForMoneyRating: valueForMoneyRating, deliveryTimeRating: deliveryTimeRating, qualityOfFoodRating: qualityOfFoodRating)
    }
}

struct Review: Codable {
    var userName: String
    var date: String
    var orderPackaginRating: Double
    var valueForMoneyRating: Double
    var deliveryTimeRating: Double
    var qualityOfFoodRating: Double
    var comment: String
}


struct Rating: Codable {
    var orderPackaginRating: Double
    var valueForMoneyRating: Double
    var deliveryTimeRating: Double
    var qualityOfFoodRating: Double
}
