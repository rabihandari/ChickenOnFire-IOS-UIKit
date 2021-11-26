//
//  CustomizationCellSingle.swift
//  Chicken On Fire
//
//  Created by user on 12/11/2021.
//

import UIKit

class CustomizationCellSingle: UITableViewCell {

    @IBOutlet weak var addOnName: UILabel!
    @IBOutlet weak var addOnPrice: UILabel!
    @IBOutlet weak var radioButton: UIImageView!
    
    static let identifier = "CustomizationCellSingle"
    static func nib() -> UINib {
        return UINib(nibName: "CustomizationCellSingle", bundle: nil)
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
        
        if selected {
            radioButton.image = UIImage(systemName: "smallcircle.fill.circle")
            radioButton.tintColor = UIColor(named: "accentColor")
        } else {
            radioButton.image = UIImage(systemName: "circle")
            radioButton.tintColor = .darkGray
        }
    }
    
}
