//
//  MenuItemViewCell.swift
//  RestaurantMenu
//
//  Created by user on 21/10/2021.
//

import UIKit
import SDWebImage

class MenuItemViewCell: UITableViewCell {
    
    static let identifier = "MenuItemViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "MenuItemViewCell", bundle: nil)
    }
    
    @IBOutlet var title: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var discountLine: UIView!
    @IBOutlet var newPrice: UILabel!
    
    let language = LanguageManager.language
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemImage.layer.cornerRadius = 10
        itemImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configure(with menuItem: MenuItem) {
        title.text = language == "en" ? menuItem.name : menuItem.nameAr
        desc.text = language == "en" ? menuItem.desicription : menuItem.desicriptionAr
        price.text = "K.D \(String(format: "%.3f",menuItem.price))"
        let urlString = RestaurantInfoManager.backendURL + menuItem.image
        
        if !menuItem.image.isEmpty {
            itemImage.sd_setImage(with: URL(string: urlString))
        } else {
            itemImage.image = UIImage(named: "default-item-img")
        }
        
        if menuItem.discount > 0 {
            discountLine.isHidden = false
            newPrice.isHidden = false
            newPrice.text = "K.D".localized() + " \(String(format: "%.3f", (menuItem.price - (menuItem.price * menuItem.discount/100))))"
            price.textColor = .darkGray
        } else {
            discountLine.isHidden = true
            newPrice.isHidden = true
            price.textColor = .black
        }
    }
    
}
