//
//  UserAddressManager.swift
//  Chicken On Fire
//
//  Created by user on 27/09/2021.
//

import Foundation
import MapKit
import GoogleMaps

class UserAddressManager {
    static var userAddresses: [Address] {
        get {
            if let items = UserDefaults.standard.data(forKey: "User Addresses") {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode([Address].self, from: items) {
                    return decoded
                }
            }
            return []
        } set (userAddresses) {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(userAddresses) {
                UserDefaults.standard.setValue(encoded, forKey: "User Addresses")
            }
        }
    }
    
}

struct Address: Identifiable, Codable {
    var id = UUID()
    var branchId: Int
    var firstName: String
    var lastName: String
    var area: String
    var addressType: AddressType
    var block: String
    var street: String
    var avenue: String
    var house: String
    var building: String
    var floor: Int
    var apartmentNo: Int
    var office: String
    var phoneCode: String
    var phoneNumber: String
    var additionalDirections: String
    var locationLat: String
    var locationLong: String
    
    func getCoordinates() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(locationLat) ?? 0, longitude: Double(locationLong) ?? 0)
    }
    
}

enum AddressType: String, Codable {
    case house
    case aparatment
    case office
}

enum PhoneNumberStatus {
    case valid
    case invalid
    case unkown
}
