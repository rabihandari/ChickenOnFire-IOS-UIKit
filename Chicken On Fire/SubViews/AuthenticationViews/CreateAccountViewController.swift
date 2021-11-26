//
//  CreateAccountViewController.swift
//  Chicken On Fire
//
//  Created by user on 22/11/2021.
//

import UIKit
import NicoProgress

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password1Field: UITextField!
    @IBOutlet weak var password2Field: UITextField!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var progressView: NicoProgressBar!
    
    var isPasswordSecured = true
    var onAccountCreated: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toggleSecurePassword(_ sender: Any) {
        isPasswordSecured = !isPasswordSecured
        password1Field.isSecureTextEntry = isPasswordSecured
        passwordButton.setTitle(isPasswordSecured ? "Show" : "Hide", for: .normal)
    }
    
    
    @IBAction func createAccount(_ sender: Any) {
        if !isValid() { return }
        
        hideError()
        progressView.isHidden = false
        
        UserAccountApi.createAccount(method: "email", firstName: firstNameField.text!, lastName: lastNameField.text!, email: emailField.text!, password: password1Field.text!, onSuccess: {
            
            DispatchQueue.main.async {
                self.progressView.isHidden = true
                self.onAccountCreated?(self.emailField.text!)
                self.navigationController?.popViewController(animated: true)
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                self.showError(error: error)
                self.progressView.isHidden = true
            }
        })
        
    }
    
    private func isValid() -> Bool {
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        
        guard let firstName = firstNameField.text, let lastName = lastNameField.text, let email = emailField.text, let password1 = password1Field.text, let password2 = password2Field.text else {
            return false
        }
        
        if firstName.isEmpty {
            showError(error: "Please enter your first name")
            return false
        } else if lastName.isEmpty {
            showError(error: "Please enter your last name")
            return false
        } else if email.isEmpty {
            showError(error: "Please enter your email")
            return false
        } else if !emailPredicate.evaluate(with: email) {
            showError(error: "Please enter a valid email")
            return false
        } else if password1.isEmpty {
            showError(error: "Please enter a password")
            return false
        } else if password1.count < 6 {
            showError(error: "Your password must have at lease 6 characters")
            return false
        } else if password1 != password2 {
            showError(error: "Your passwords do not match")
            return false
        }
        
        return true
        
    }
    
    private func hideError() {
        if errorLabel.isHidden { return }
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLabel.isHidden = true
        })
    }
    
    private func showError(error: String) {
//        if !errorLabel.isHidden { return }
        self.errorLabel.text = error
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLabel.isHidden = false
        })
    }

}
