//
//  BasketViewCell.swift
//  Chicken On Fire
//
//  Created by user on 15/11/2021.
//

import UIKit

class BasketViewCell: UITableViewCell {
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var divider: UIView!
    
    var basketItem: BasketItem?
    var onItemChange: (() -> Void)?
    var onItemRemoved: (() -> Void)?
    
    let language = LanguageManager.language
    
    static let identifier = "BasketViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "BasketViewCell", bundle: nil)
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        itemImage.layer.cornerRadius = 10
        itemImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(basketItem: BasketItem, hasDivider: Bool, available: Bool) {
        self.basketItem = basketItem
        itemTitle.text = language == "en" ? basketItem.itemName : basketItem.itemNameAr
        itemDesc.text = getAddonsString(basketItem: basketItem)
        itemImage.sd_setImage(with: URL(string: basketItem.imageUrl))
        itemPrice.text = "\(String(format: "%.3f",basketItem.totalPrice)) " + "K.D".localized()
        itemQuantity.text = "\(basketItem.quantity)"
        divider.isHidden = !hasDivider
        errorMessage.isHidden = available
    }
    
    func getAddonsString(basketItem: BasketItem) -> String {
        var addonsNames = [String]()
        for addon in basketItem.addons {
            addonsNames.append(language == "en" ? addon.name : addon.nameAr)
        }
        return addonsNames.joined(separator: ", ")
    }
    
    func setError() -> Void {
        errorMessage.isHidden = false
    }
    
    @IBAction func incrementQuantity(_ sender: Any) {
        guard let basketItem = basketItem else {
            return
        }
        
        BasketManager.incrementQuantity(for: basketItem)
        onItemChange?()
    }
    
    @IBAction func decrementQuantity(_ sender: Any) {
        guard let basketItem = basketItem else {
            return
        }
        
        BasketManager.decrementQuantity(for: basketItem)
        onItemChange?()
    }
    
    @IBAction func removeItem(_ sender: Any) {
        guard let basketItem = basketItem else {
            return
        }
        
        BasketManager.removeItem(basketItem: basketItem)
        onItemRemoved?()
    }
    
}
