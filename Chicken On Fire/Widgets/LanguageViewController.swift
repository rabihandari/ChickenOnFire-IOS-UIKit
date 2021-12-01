//
//  LanguageViewController.swift
//  Chicken On Fire
//
//  Created by user on 27/11/2021.
//

import UIKit

class LanguageViewController: UIViewController {
    
    @IBOutlet weak var backgroudButton: UIButton!
    
    var onLanguageSelected: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func dismiss(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
     
    
    @IBAction func englishSelected(_ sender: Any) {
        LanguageManager.language = "en"
        dismiss(animated: true, completion: nil)
        onLanguageSelected?()
    }
    
    
    @IBAction func arabicSelected(_ sender: Any) {
        LanguageManager.language = "ar"
        dismiss(animated: true, completion: nil)
        onLanguageSelected?()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.backgroudButton.backgroundColor = .clear
        UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
            self.backgroudButton.backgroundColor = .darkGray
            self.backgroudButton.alpha = 0.5
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.backgroudButton.backgroundColor = .clear
        self.backgroudButton.alpha = 1
    }
}
