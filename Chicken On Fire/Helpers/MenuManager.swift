//
//  MenuManager.swift
//  Chicken On Fire
//
//  Created by Rabih Andari on 11/29/20.
//  Copyright © 2020 Rabih Andari. All rights reserved.
//

import Foundation


class MenuManager {
    static let dummyMenuItem = MenuItem(id: 1, name: "", nameAr: "", desicription: "", desicriptionAr: "", price: 0, discount: 0, image: "", contains: [])
}

struct CategoryItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var titleAr: String
    var menuItems: [MenuItem]
    
}

struct MenuItem: Identifiable, Codable {
    var id: Int
    var name: String
    var nameAr: String
    var desicription: String
    var desicriptionAr: String
    var price: Double
    var discount: Double
    var image: String
    var contains: [Flavour]
    
}

struct Flavour: Codable {
    var name: String
    var nameAr: String
    var image: String
}

struct AddonCategory: Codable, Hashable{
    var header: String
    var headerAr: String
    var free: Bool
    var optional: Bool
    var chooseMax: Int
    var chooseMin: Int
    var items: [Addon]
    
    static func == (lhs: AddonCategory, rhs: AddonCategory) -> Bool {
        return lhs.header == rhs.header
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(header)
    }
    
}

enum AddonType {
    case single
    case multiple
}

struct Addon: Codable, Hashable{
    var aid: Int
    var name: String
    var nameAr: String
    var price: Double
    var overrideFree: Bool
    
}


struct MenuResponse: Codable {
    var id: Int
    var nm: String
    var nmL: String
    var sci: [MenuItemResponse]

}


struct MenuItemResponse: Codable {
    var pk: Int
    var nm: String
    var nmL: String
    var ds: String
    var dsL: String
    var pr: Double
    var dis: Double
    var img: String?
    var fl: [FlavourResponse]
}

struct FlavourResponse: Codable {
    var nm: String
    var nmL: String
    var img: String?
}

struct AddonsCategoryResponse: Codable {
    var cid: Int
    var hd: String
    var hdL: String
    var fr: Bool
    var cMx: Int
    var cMn: Int
    var opt: Bool
    var ao: [AddonItemResponse]
}

struct AddonItemResponse: Codable {
    var aid: Int
    var nm: String
    var nmL: String
    var pr: Double
    var ovf: Bool
}
