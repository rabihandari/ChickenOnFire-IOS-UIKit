//
//  MenuTabBarCell.swift
//  RestaurantMenu
//
//  Created by user on 18/10/2021.
//

import UIKit

class MenuTabBarCell: UICollectionViewCell {
    
    static let identifier = "MenuTabBarCell"
    static func nib() -> UINib {
        return UINib(nibName: "MenuTabBarCell", bundle: nil)
    }
    
    @IBOutlet var title: UILabel!
    @IBOutlet var line: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        line.layer.cornerRadius = 5;
        line.layer.masksToBounds = true;
    }
    
    func configure(with title: String, selected: Bool) -> Void {
        self.title.text = title
        self.line.isHidden = !selected
        
        UIView.animate(withDuration: 0.7, animations: {
            self.line.alpha = selected ? 1 : 0
        }, completion: nil)
    }

}
