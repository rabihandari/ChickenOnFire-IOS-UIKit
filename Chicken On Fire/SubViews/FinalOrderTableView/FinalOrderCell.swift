//
//  FinalOrderCell.swift
//  Chicken On Fire
//
//  Created by user on 19/11/2021.
//

import UIKit

class FinalOrderCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    static let identifier = "FinalOrderCell"
    static func nib() -> UINib {
        return UINib(nibName: "FinalOrderCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(basketItem: BasketItem) {
        titleLabel.text = basketItem.itemName
        descLabel.text = getAddonsString(basketItem: basketItem)
        quantityLabel.text = "\(basketItem.quantity)"
        priceLabel.text = "\(String(format: "%.3f", basketItem.totalPrice)) K.D"
    }
    
    
    
    func getAddonsString(basketItem: BasketItem) -> String {
        var addonsNames = [String]()
        for addon in basketItem.addons {
            addonsNames.append(addon.name)
        }
        return addonsNames.joined(separator: ", ")
    }
}
