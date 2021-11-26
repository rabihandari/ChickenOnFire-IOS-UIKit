//
//  AddressTableCell.swift
//  Chicken On Fire
//
//  Created by user on 18/11/2021.
//

import UIKit

class AddressTableCell: UITableViewCell {
    
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var myBackgroundView: UIView!
    @IBOutlet weak var divider: UIView!
    
    static let identifier = "AddressTableCell"
    static func nib() -> UINib {
        return UINib(nibName: "AddressTableCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(address: Address, hasDivider: Bool, enabled: Bool) -> Void {
        areaLabel.text = address.area
        var addressText = "Block \(address.block), Street \(address.street)"
        if address.addressType == .house {
            addressText += ", House \(address.house)"
        } else if address.addressType == .aparatment {
            addressText += ", Building \(address.building)"
        } else {
            addressText += ", Office \(address.office)"
        }
        addressLabel.text = addressText
        mobileLabel.text = "Mobile: \(address.phoneCode) \(address.phoneNumber)"
        divider.isHidden = !hasDivider
        myBackgroundView.alpha = enabled ? 1 : 0.5
        self.isUserInteractionEnabled = enabled
    }
    
}
