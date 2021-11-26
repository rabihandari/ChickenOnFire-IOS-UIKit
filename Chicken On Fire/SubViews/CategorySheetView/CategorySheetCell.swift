//
//  CategorySheetCell.swift
//  Chicken On Fire
//
//  Created by user on 06/11/2021.
//

import UIKit

class CategorySheetCell: UITableViewCell {
    
    static let identifier = "CategorySheetCell"
    static func nib() -> UINib {
        return UINib(nibName: "CategorySheetCell", bundle: nil)
    }
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var itemsNumber: UILabel!
    @IBOutlet weak var divider: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(title: String, number: Int, hasDivider: Bool) -> Void {
        self.title.text = title
        self.itemsNumber.text = String(number)
        self.divider.isHidden = !hasDivider
    }
    
}
