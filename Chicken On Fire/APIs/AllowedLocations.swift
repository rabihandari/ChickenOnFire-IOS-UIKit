//
//  AllowedLocations.swift
//  Chicken On Fire
//
//  Created by user on 11/09/2021.
//

import Foundation
import GoogleMaps

class AllowedLocations {
    static func getAllowedLocations(onSuccess: (([GMSPolyline]) -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/getAllowedLocations/") else {
            onFailure?("Invalid Url")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(Array<AreaPolygon>.self, from: data)
                    
                    var polylines = [GMSPolyline]()
                    DispatchQueue.main.async {
                        for polyline in decoded {
                            let path = GMSMutablePath()
                            for coordinate in polyline.polygon {
                                let latitude  = coordinate[0]
                                let longitude = coordinate[1]
                                path.add(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                                    
                            }
                            polylines.append(GMSPolyline(path: path))
                        }
                        onSuccess?(polylines)
                    }
                    
                } catch {
                    onFailure?(error.localizedDescription)
                }
            } else {
                onFailure?(error?.localizedDescription ?? "Unknown Error")
            }
        }.resume()
    }
    
    static func getAllowedLocation(branchId: Int ,onSuccess: ((GMSPolyline) -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/getAllowedLocations/?brID=\(branchId)") else {
            onFailure?("Invalid Url")
            return
        }
        
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(AreaPolygon.self, from: data)
                    
                    DispatchQueue.main.async {
                        let path = GMSMutablePath()
                        for coordinate in decoded.polygon {
                            let latitude  = coordinate[0]
                            let longitude = coordinate[1]
                            path.add(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                                
                        }
                        onSuccess?(GMSPolyline(path: path))
                    }
                    
                } catch {
                    onFailure?(error.localizedDescription)
                }
            } else {
                onFailure?(error?.localizedDescription ?? "Unknown Error")
            }
        }.resume()
    }
}

struct AreaPolygon: Codable {
    var polygon: [[Double]]
}
