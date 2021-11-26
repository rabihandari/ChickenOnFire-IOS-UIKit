//
//  MenuSectioHeader.swift
//  RestaurantMenu
//
//  Created by user on 21/10/2021.
//

import UIKit

class MenuSectionHeader: UIView {
    
    @IBOutlet weak var title: UILabel!

    class func createMyClassView() -> MenuSectionHeader {
        let myClassNib = UINib(nibName: "MenuSectionHeader", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! MenuSectionHeader
    }
}
