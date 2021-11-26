//
//  ForgetPasswordViewController.swift
//  Chicken On Fire
//
//  Created by user on 22/11/2021.
//

import UIKit
import NicoProgress

enum MessageType {
    case success
    case error
}

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailFeild: UITextField!
    @IBOutlet weak var progressView: NicoProgressBar!
    @IBOutlet weak var messageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func resetPassword(_ sender: Any) {
        progressView.isHidden = false
        hideMessage()
        
        guard let email = emailFeild.text else {
            showMessage(message: "Something went wrong", messageType: .error)
            progressView.isHidden = true
            return
        }
        
        UserAccountApi.resetPassword(email: email, onSuccess: {
            DispatchQueue.main.async {
                self.showMessage(message: "We've sent you an email to reset your password", messageType: .success)
                self.progressView.isHidden = true
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                self.showMessage(message: error, messageType: .error)
                self.progressView.isHidden = true
            }
        })
    }
    
    
    private func hideMessage() {
        if messageLabel.isHidden { return }
        UIView.animate(withDuration: 0.3, animations: {
            self.messageLabel.isHidden = true
        })
    }
    
    private func showMessage(message: String, messageType: MessageType) {
        if !messageLabel.isHidden { return }
        self.messageLabel.text = message
        self.messageLabel.textColor = messageType == MessageType.error ? .red : .green
        UIView.animate(withDuration: 0.3, animations: {
            self.messageLabel.isHidden = false
        })
    }
}
