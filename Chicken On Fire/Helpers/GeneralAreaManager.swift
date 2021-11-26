//
//  GeneralAreaManager.swift
//  Chicken On Fire
//
//  Created by user on 25/10/2021.
//

import Foundation
import MapKit
import GoogleMaps

protocol GeneralAreaDelegate {
    func didConfirmLocation(area: Area)
}

class GeneralAreaManager {
    static func getSavedArea() -> Area {
        if let area = UserDefaults.standard.data(forKey: "General Area") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Area.self, from: area) {
                return decoded
            }
        }
        return Area()
    }
    
    static func setArea(area: Area) -> Void {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(area) {
            UserDefaults.standard.set(encoded, forKey: "General Area")
        }
    }
    
    static func getAreaName(location: CLLocationCoordinate2D, onComplete: ((String) -> Void)?) -> Void {
        let geoCoder = GMSGeocoder()
        geoCoder.reverseGeocodeCoordinate(location, completionHandler: { placemarks, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let placeMark = placemarks?.firstResult() else { return }

            var selectedArea = [String]()
            if let locality = placeMark.locality{
                selectedArea.append(locality)
            }
            
            if let sublocality = placeMark.subLocality{
                selectedArea.append(sublocality)
            }
            
            if let area = placeMark.administrativeArea{
                selectedArea.append(area)
            }
            
            onComplete?(selectedArea.joined(separator: ", "))
        })
    }
}

struct Area: Codable {
    var branchID: Int = -1
    var name: String = RestaurantInfoManager.restaurantArea
    var latitude: Double = RestaurantInfoManager.restaurantLatitude
    var longitude: Double = RestaurantInfoManager.restaurantLongitude
    
    func getCoordinates() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
