//
//  CustomizationSection.swift
//  Chicken On Fire
//
//  Created by user on 09/11/2021.
//

import UIKit

class CustomizationSection: UITableViewCell {
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerInstruction: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var requiredLabel: UILabel!
    
    static let identifier = "CustomizationSection"
    static func nib() -> UINib {
        return UINib(nibName: "CustomizationSection", bundle: nil)
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(addonCategory: AddonCategory, isOpened: Bool) {
        headerTitle.text = addonCategory.header
        
        if addonCategory.chooseMin == -1 && addonCategory.chooseMax == -1 {
            headerInstruction.text = "Choose items from the list"
        } else if addonCategory.chooseMin == 1 && addonCategory.chooseMax == 1 {
            headerInstruction.text = "Choose 1 item from the list"
        } else if addonCategory.chooseMin == 0 && addonCategory.chooseMax > 1 {
            headerInstruction.text = "Choose up to \(addonCategory.chooseMax) items from the list"
        } else {
            headerInstruction.text = "Choose between \(addonCategory.chooseMin) and \(addonCategory.chooseMax) items from the list"
        }
        
        let angle: CGFloat = isOpened ? 0 : 180
        UIView.animate(withDuration: 0.3, animations: {
            self.arrow.transform = CGAffineTransform(rotationAngle: (angle * .pi) / 180.0)
        })
        
    }
    
    
    func showRequired() {
        requiredLabel.isHidden = false
    }
    
    func hideRequired() {
        requiredLabel.isHidden = true
    }
    
}
