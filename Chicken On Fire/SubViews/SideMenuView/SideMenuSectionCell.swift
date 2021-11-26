//
//  SideMenuSection.swift
//  Chicken On Fire
//
//  Created by user on 08/11/2021.
//

import UIKit

class SideMenuSectionCell: UIView {
    
    @IBOutlet weak var title: UILabel!

    class func createMyClassView() -> SideMenuSectionCell {
        let myClassNib = UINib(nibName: "SideMenuSectionCell", bundle: nil)
        return myClassNib.instantiate(withOwner: nil, options: nil)[0] as! SideMenuSectionCell
    }

}
