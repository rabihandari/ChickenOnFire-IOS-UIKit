//
//  SocialMediaButton.swift
//  Chicken On Fire
//
//  Created by user on 22/11/2021.
//

import UIKit

@IBDesignable class SocialMediaButton: UIButton {
    
    @IBOutlet var middleLabel: UILabel!
    @IBOutlet var leftIcon: UIImageView!
    
    @IBInspectable var middleTitle: String? {
        didSet {
            middleLabel.text = middleTitle
        }
    }
    
    
    @IBInspectable var leftIconImage: UIImage? {
        didSet {
            leftIcon.image = leftIconImage
        }
    }
    
    var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? UIColor(named: "lighterGrey") : .white
            layer.borderColor = isHighlighted ? UIColor(named: "lighterGrey")?.cgColor : UIColor.gray.cgColor
        }
    }
    
    
    func setup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(contentView)
        
        updateUI()
    }
    
    
    func updateUI() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
    }
    
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: SocialMediaButton.self)
        let nib = UINib(nibName: "SocialMediaButton", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
