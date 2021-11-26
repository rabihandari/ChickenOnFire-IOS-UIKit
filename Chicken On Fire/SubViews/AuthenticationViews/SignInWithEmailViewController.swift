//
//  SignInWithEmailViewController.swift
//  Chicken On Fire
//
//  Created by user on 22/11/2021.
//

import UIKit
import NicoProgress

class SignInWithEmailViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var progressView: NicoProgressBar!
    @IBOutlet weak var errorLabel: UILabel!
    
    var isPasswordSecured = true
    
    var onSuccess: ((UserAccount) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateAccountSegue" {
            let vc = segue.destination as! CreateAccountViewController
            vc.onAccountCreated = { email in
                self.emailField.text = email
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toggleSecurePassword(_ sender: Any) {
        isPasswordSecured = !isPasswordSecured
        passwordField.isSecureTextEntry = isPasswordSecured
        passwordButton.setTitle(isPasswordSecured ? "Show" : "Hide", for: .normal)
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        self.hideError()
        self.progressView.isHidden = false
        
        guard let email = emailField.text, let password = passwordField.text else {
            self.showError(error: "Something went wrong!")
            self.progressView.isHidden = true
            return
        }
        
        UserAccountApi.signIn(email: email, password: password, onSuccess: {
            DispatchQueue.main.async {
                self.progressView.isHidden = true
                self.onSuccess?(UserAccount(email: email, password: password, authenticated: true))
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                self.showError(error: error)
                self.progressView.isHidden = true
            }
        })
    }
    
    
    private func hideError() {
        if errorLabel.isHidden { return }
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLabel.isHidden = true
        })
    }
    
    private func showError(error: String) {
        if !errorLabel.isHidden { return }
        self.errorLabel.text = error
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLabel.isHidden = false
        })
    }
}
