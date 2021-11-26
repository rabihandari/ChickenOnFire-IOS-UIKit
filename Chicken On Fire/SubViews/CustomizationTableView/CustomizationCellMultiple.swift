//
//  CustomizationCell.swift
//  Chicken On Fire
//
//  Created by user on 09/11/2021.
//

import UIKit

class CustomizationCellMultiple: UITableViewCell {
    
    @IBOutlet weak var addOnName: UILabel!
    @IBOutlet weak var addOnPrice: UILabel!
    @IBOutlet weak var checkbox: UIImageView!
    
    static let identifier = "CustomizationCellMultiple"
    static func nib() -> UINib {
        return UINib(nibName: "CustomizationCellMultiple", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(addon: Addon, selected: Bool) {
        addOnName.text = addon.name
        addOnPrice.text = "KD \(String(format: "%.3f", addon.price))"
        
        if !selected {
            checkbox.image = UIImage(systemName: "square")
            checkbox.tintColor = .darkGray
        } else {
            checkbox.image = UIImage(systemName: "checkmark.square")
            checkbox.tintColor = UIColor(named: "accentColor")
        }
        
    }
}
