
import Foundation

class BasketManager {
    static var basketItems: [BasketItem] {
        get{
            if let items = UserDefaults.standard.data(forKey: "Basket Items") {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode([BasketItem].self, from: items) {
                    return decoded
                }
            }
            return []
        }
        set(basketItemss) {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(basketItemss) {
                UserDefaults.standard.set(encoded, forKey: "Basket Items")
            }
        }
    }
    
    static func clearBasket() -> Void {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode([BasketItem]()) {
            UserDefaults.standard.set(encoded, forKey: "Basket Items")
        }
    }
    
    static func removeItem(basketItem: BasketItem) -> Void {
        guard let index = basketItems.firstIndex(where: { $0.id == basketItem.id }) else {
            return
        }
        basketItems.remove(at: index)
    }
    
    static func incrementQuantity(for basketItem: BasketItem) {
        guard let index = basketItems.firstIndex(where: { $0.id == basketItem.id }) else {
            return
        }
        let singleItemPrice = basketItem.totalPrice / Double(basketItem.quantity)
        basketItems[index].quantity += 1
        basketItems[index].totalPrice = singleItemPrice * Double((basketItem.quantity + 1))
    }
    
    static func decrementQuantity(for basketItem: BasketItem) {
        guard let index = basketItems.firstIndex(where: { $0.id == basketItem.id }) else {
            return
        }
        if basketItems[index].quantity == 1 { return }
        let singleItemPrice = basketItem.totalPrice / Double(basketItem.quantity)
        basketItems[index].quantity -= 1
        basketItems[index].totalPrice = singleItemPrice * Double((basketItem.quantity - 1))
    }
}

struct BasketItem: Identifiable, Codable {
    var id = UUID()
    var itemID: Int
    var itemName: String
    var itemNameAr: String
    var imageUrl: String
    var addons: [Addon]
    var quantity: Int
    var specialRequest: String
    var totalPrice: Double
}
