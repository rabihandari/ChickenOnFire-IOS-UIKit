//
//  AllowedLocations.swift
//  Chicken On Fire
//
//  Created by user on 11/09/2021.
//

import Foundation
import GoogleMaps

class MenuApi {
    static func getMenu(branchID: Int, onSuccess: (([CategoryItem]) -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/getMenu?brID=\(branchID)") else {
            print("Invalide URL")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(Array<MenuResponse>.self, from: data)
                    
                    var categoryItems = Array<CategoryItem>()
                    for categoryItem in decoded {
                        var menuItems = [MenuItem]()
                        for menuItem in categoryItem.sci {
                            var flavours = [Flavour]()
                            for flavour in menuItem.fl {
                                flavours.append(Flavour(name: flavour.nm, nameAr: flavour.nmL, image: flavour.img ?? ""))
                            }
                            menuItems.append(MenuItem(id: menuItem.pk, name: menuItem.nm, nameAr: menuItem.nmL, desicription: menuItem.ds, desicriptionAr: menuItem.dsL, price: menuItem.pr, discount: menuItem.dis, image: menuItem.img ?? "", contains: flavours))
                        }
                        categoryItems.append(CategoryItem(title: categoryItem.nm, titleAr: categoryItem.nmL, menuItems: menuItems))
                        onSuccess?(categoryItems)
                    }
                    
                } catch {
                    onFailure?(error.localizedDescription)
                }
            } else {
                onFailure?(error?.localizedDescription ?? "Unknown Error")
            }
        }.resume()
    }
    
    
    static func getAddon(ofID id: Int, branchID: Int, onSuccess: (([AddonCategory]) -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/getAddonOfID?brID=\(branchID)&id=\(id)") else {
            print("Invalide URL")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(Array<AddonsCategoryResponse>.self, from: data)
                    
                    var categories = [AddonCategory]()
                    for category in decoded {
                        var addons = [Addon]()
                        for addon in category.ao {
                            addons.append(Addon(aid: addon.aid, name: addon.nm, nameAr: addon.nmL, price: addon.pr, overrideFree: addon.ovf))
                        }
                        categories.append(AddonCategory(header: category.hd, headerAr: category.hdL, free: category.fr, optional: category.opt, chooseMax: category.cMx, chooseMin: category.cMn, items: addons))
                        
                    }
                    onSuccess?(categories)
                    
                } catch {
                    onFailure?(error.localizedDescription)
                    return
                }
            }
            onFailure?("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}


