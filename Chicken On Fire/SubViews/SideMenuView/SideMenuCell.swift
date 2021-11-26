//
//  SideMenuCell.swift
//  Chicken On Fire
//
//  Created by user on 08/11/2021.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var divider: UIView!
    
    static let identifier = "SideMenuCell"
    static func nib() -> UINib {
        return UINib(nibName: "SideMenuCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(icon: UIImage, title: String, hasImage: Bool, hasDivider: Bool) -> Void {
        self.title.text = title
        self.divider.isHidden = !hasDivider
        if !hasImage {
            self.icon.isHidden = true
        } else {
            self.icon.image = icon
            self.icon.isHidden = false
        }
    }
    
}
