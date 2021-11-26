//
//  FavouritesApi.swift
//  Chicken On Fire
//
//  Created by user on 28/09/2021.
//

import Foundation


class FavouritesApi {
    static func toggleFavourite(email: String, menuItemId: Int, onSuccess: (() -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/mobile-add-to-favourites/") else {
            onFailure?("Invalid Url")
            return
        }
        
        let parameters: [String: Any] = ["email": email, "id": menuItemId]
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
            if let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                switch statusCode {
                case 200:
                    onSuccess?()
                default:
                    onFailure?("Failed with status code: \(response.statusCode)")
                }
                
            } else {
                onFailure?("Something went wrong")
            }
        }.resume()
    }
    
    static func checkIsFavoured(email: String, menuItemId: Int, onSuccess: ((Bool) -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/mobile-is-favoured/") else {
            onFailure?("Invalid Url")
            return
        }
        
        let parameters: [String: Any] = ["email": email, "id": menuItemId]
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
            guard let data = data else {
                onFailure?("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    let favoured: Int = jsonResponse["favoured"] as! Int
                    switch favoured {
                    case 0:
                        onSuccess?(false)
                    case 1:
                        onSuccess?(true)
                    default:
                        onFailure?("Something went wrong. Please contact us to resolve the problem")
                    }
                }
            } catch _ {
                onFailure?("Something went wrong")
            }
        }.resume()
    }
    
    static func getFavourites(email: String, branchID: Int, onSuccess: (([MenuItem]) -> Void)?, onFailure: ((String) -> Void)?) -> Void {
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/mobile-get-favourites/") else {
            onFailure?("Invalid URL")
            return
        }
        
        let parameters: [String: Any] = ["email": email, "brID": branchID]
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
                    let decoded = try JSONDecoder().decode(Array<MenuItemResponse>.self, from: data)
                    
                    DispatchQueue.main.async {
                        var menuItems = [MenuItem]()
                        for menuItem in decoded {
                            var flavours = [Flavour]()
                            for flavour in menuItem.fl {
                                flavours.append(Flavour(name: flavour.nm, nameAr: flavour.nmL, image: flavour.img ?? ""))
                            }
                            menuItems.append(MenuItem(id: menuItem.pk, name: menuItem.nm, nameAr: menuItem.nmL, desicription: menuItem.ds, desicriptionAr: menuItem.dsL, price: menuItem.pr, discount: menuItem.dis, image: menuItem.img ?? "", contains: flavours))
                        }
                        onSuccess?(menuItems)
                    }
                } catch {
                    onFailure?(error.localizedDescription)
                    return
                }
            }else{
                onFailure?("Failed to get data")
            }
        }.resume()
    }
}
