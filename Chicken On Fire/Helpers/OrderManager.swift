//
//  OrderManager.swift
//  Chicken On Fire
//
//  Created by user on 28/09/2021.
//

import Foundation

struct Order: Codable {
    var userInfo: UserInfo
    var orderInfo: OrderInfo
    var paymentMethod: String
    var serviceFee: Double
    var voucherID: String
    var pickUp: Bool
    var brID: Int
}

struct UserInfo: Codable {
    var email: String
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
    
    init(address: Address, email: String) {
        self.email = email
        self.firstName = address.firstName
        self.lastName = address.lastName
        self.area = address.area
        self.addressType = address.addressType
        self.block = address.block
        self.street = address.street
        self.avenue = address.avenue
        self.house = address.house
        self.building = address.building
        self.floor = address.floor
        self.apartmentNo = address.apartmentNo
        self.office = address.office
        self.phoneCode = address.phoneCode
        self.phoneNumber = address.phoneNumber
        self.additionalDirections = address.additionalDirections
        self.locationLat = address.locationLat
        self.locationLong = address.locationLong
    }
}

struct OrderInfo: Codable {
    var orderedItems: [OrderItem]
    var schedule: String
    var cutlery: Bool
    var Leave_order_at_the_door: Bool
    var subtotal: Double
    var specialRequest: String
}

struct OrderItem: Codable {
    var menuItemID: Int
    var specialRequest: String
    var quantity: Int
    var customization: [Customization]
}

struct Customization: Codable {
    var nm: String
    var nmL: String
    var pr: Double
}

enum PaymentMethod {
    case cashOnDelivery
    case creditCard
    case knet
    case unkown
}

enum OrderMethod {
    case delivery
    case pickup
}
