//
//  ScheduleViewController.swift
//  Chicken On Fire
//
//  Created by user on 19/11/2021.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var backgroudButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    
    var selectedDate: Date?
    var onSchedulePicked: ((String) -> Void)?
    var onScheduleRemoved: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if selectedDate != nil {
            cancelButton.setTitle("Remove".localized(), for: .normal)
        }
        
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 2, to: today)
        datePicker.minimumDate = today
        datePicker.maximumDate = tomorrow
    }
    
    @IBAction func dismiss(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: Any){
        if selectedDate != nil {
            onScheduleRemoved?()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func schedule(_ sender: Any) {
        guard let onSchedulePicked = onSchedulePicked else {
            return
        }
        
        
        let formater = DateFormatter()
        formater.locale = Locale(identifier: "en_US")
        formater.dateFormat = "Y-MM-dd HH:MM:SS"
        let englishDate = formater.string(from: datePicker.date)
        
        onSchedulePicked(englishDate)
        dismiss(animated: true, completion: nil)
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
