//
//  CustomButton.swift
//  Chicken On Fire
//
//  Created by user on 13/11/2021.
//

import UIKit

enum CustomButtonStyle {
    case filled
    case outlined
}

@IBDesignable class CustomButton: UIButton {
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    
    @IBInspectable var isOutlined: Bool = false {
        didSet{
            updateUI()
        }
    }
    
    @IBInspectable var leftTitle: String? {
        didSet {
            leftLabel.text = leftTitle
        }
    }
    @IBInspectable var rightTitle: String? {
        didSet {
            rightLabel.text = rightTitle
        }
    }
    @IBInspectable var middleTitle: String? {
        didSet {
            middleLabel.text = middleTitle
        }
    }
    
    @IBInspectable var twoTexts: Bool = false {
        didSet {
            if twoTexts {
                leftLabel.isHidden = false
                rightLabel.isHidden = false
                middleLabel.isHidden = true
            } else {
                leftLabel.isHidden = true
                rightLabel.isHidden = true
                middleLabel.isHidden = false
            }
        }
    }
    
    @IBInspectable var active: Bool = true {
        didSet {
            setActive(active: active)
        }
    }
    
    var contentView: UIView!
    
    override var isHighlighted: Bool {
        didSet {
            if isOutlined {
                contentView.backgroundColor = isHighlighted ? UIColor(named: "accentColor") : .white
                leftLabel.textColor = !isHighlighted ? UIColor(named: "accentColor") : .white
                rightLabel.textColor = !isHighlighted ? UIColor(named: "accentColor") : .white
                middleLabel.textColor = !isHighlighted ? UIColor(named: "accentColor") : .white
            } else {
                contentView.backgroundColor = UIColor(named: isHighlighted ? "accentColorDark" : "accentColor")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
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
        layer.borderColor = UIColor(named: "accentColor")?.cgColor
        if isOutlined {
            contentView.backgroundColor = .white
            leftLabel.textColor = UIColor(named: "accentColor")
            rightLabel.textColor = UIColor(named: "accentColor")
            middleLabel.textColor = UIColor(named: "accentColor")
        } else {
            contentView.backgroundColor = UIColor(named: "accentColor")
            leftLabel.textColor = .white
            rightLabel.textColor = .white
            middleLabel.textColor = .white
        }
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: CustomButton.self)
        let nib = UINib(nibName: "CustomButton", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setActive(active: Bool) {
        layer.opacity = active ? 1 : 0.5
    }
    
    
    
}
