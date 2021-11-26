//
//  VoucherViewController.swift
//  Chicken On Fire
//
//  Created by user on 19/11/2021.
//

import UIKit
import NicoProgress

class VoucherViewController: UIViewController {
    
    @IBOutlet weak var backgroudButton: UIButton!
    @IBOutlet weak var voucherField: UITextField!
    @IBOutlet weak var progressView: NicoProgressBar!
    
    var onVoucherAdded: ((String, Double) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func dismiss(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func useVoucher(_ sender: Any) {
        let voucherID = voucherField.text
        progressView.isHidden = false
        VoucherApi.useVoucher(voucherID: voucherID ?? "", onSuccess: { status, discount in
            if status == .valid {
                guard let onVoucherAdded = self.onVoucherAdded else {
                    return
                }
                self.progressView.isHidden = true
                onVoucherAdded(voucherID ?? "", discount)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.progressView.isHidden = true
                self.voucherField.layer.borderColor = UIColor.red.cgColor
                self.voucherField.layer.borderWidth = 1.0
                self.voucherField.layer.cornerRadius = 5
            }
        }, onFailure: { error in
            print(error)
            self.progressView.isHidden = true
        })
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.backgroudButton.backgroundColor = .clear
        UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
            self.backgroudButton.backgroundColor = .gray
            self.backgroudButton.alpha = 0.5
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.backgroudButton.backgroundColor = .clear
        self.backgroudButton.alpha = 1
    }

}
