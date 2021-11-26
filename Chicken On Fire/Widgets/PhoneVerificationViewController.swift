//
//  PhoneVerificationViewController.swift
//  Chicken On Fire
//
//  Created by user on 21/11/2021.
//

import UIKit
import NicoProgress

class PhoneVerificationViewController: UIViewController {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var phoneNumberLabel1: UILabel!
    @IBOutlet weak var phoneNumberLabel2: UILabel!
    @IBOutlet weak var field1: UITextField!
    @IBOutlet weak var field2: UITextField!
    @IBOutlet weak var field3: UITextField!
    @IBOutlet weak var field4: UITextField!
    @IBOutlet weak var verifyButton: CustomButton!
    @IBOutlet weak var resendCodeNumberLabel: UILabel!
    @IBOutlet weak var resendCodeView: UIStackView!
    @IBOutlet weak var progressView1: NicoProgressBar!
    @IBOutlet weak var progressView2: NicoProgressBar!
    @IBOutlet weak var errorLabel1: UILabel!
    @IBOutlet weak var errorLabel2: UILabel!
    
    var phoneCode: String?
    var phoneNumber: String?
    var onSuccess: (() -> Void)?
    
    var timer: Timer!
    var resendSeconds = 60 {
        didSet {
            resendCodeNumberLabel.isHidden = resendSeconds == 0
            resendCodeView.alpha = resendSeconds == 0 ? 1 : 0.5
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let phoneNumber = phoneNumber, let phonecode = phoneCode else {
            return
        }
        
        phoneNumberLabel1.text = "\(phonecode) \(phoneNumber)"
        phoneNumberLabel2.text = "\(phonecode) \(phoneNumber)"
        
        field1.delegate = self
        field2.delegate = self
        field3.delegate = self
        field4.delegate = self
        
        // Resend code view...
        resendCodeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendCode(_:))))
        runTimer()
        
        

    }
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
    }
   
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func getCode(_ sender: Any) {
        errorLabel1.isHidden = true
        guard let code = Int(phoneCode!.replacingOccurrences(of: "+", with: "")) else { return }
        guard let number = Int(phoneNumber!) else { return }
        let verificationRequest = VerificationRequest(phone_number: number, country_code: code, via: "sms")
        
        progressView1.isHidden = false
        PhoneVerificationApi.startPhoneVerification(verificationRequest: verificationRequest, onSuccess: {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view1.isHidden = true
                    self.view2.isHidden = false
                })
                self.progressView1.isHidden = true
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                print(error)
                self.progressView1.isHidden = true
                self.errorLabel1.isHidden = false
                self.errorLabel1.text = error
            }
        })
    }
    
    @IBAction func verifyCode(_ sender: Any) {
        errorLabel2.isHidden = true
        guard let code = Int(phoneCode!.replacingOccurrences(of: "+", with: "")) else { return }
        guard let number = Int(phoneNumber!) else { return }
        let token = "\(field1.text!)\(field2.text!)\(field3.text!)\(field4.text!)"
        let tokenVerificationRequest = TokenVericationRequest(phone_number: number, country_code: code, token: token)
        
        progressView2.isHidden = false
        PhoneVerificationApi.verifyCode(tokenVerificationRequest: tokenVerificationRequest, onSuccess: {
            DispatchQueue.main.async {
                self.progressView2.isHidden = true
                PhoneVerificationManager.phoneNumbers.append(VerifiedPhoneNumber(phoneNumber: self.phoneNumber!, phoneCode: self.phoneCode!))
                self.dismiss(animated: true, completion: nil)
                self.onSuccess?()
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                print(error)
                self.progressView2.isHidden = true
                self.errorLabel2.isHidden = false
                self.errorLabel2.text = error
            }
        })
        
    }
    
    @objc func resendCode(_ sender: Any) {
        if resendSeconds != 0 { return }
        
        guard let code = Int(phoneCode!.replacingOccurrences(of: "+", with: "")) else { return }
        guard let number = Int(phoneNumber!) else { return }
        let verificationRequest = VerificationRequest(phone_number: number, country_code: code, via: "sms")
        
        self.progressView2.isHidden = false
        PhoneVerificationApi.restartPhoneVerification(verificationRequest: verificationRequest, onSuccess: {
            self.resendSeconds = 60
            self.progressView2.isHidden = true
        }, onFailure: { error in
            DispatchQueue.main.async {
                self.progressView2.isHidden = true
                self.errorLabel2.isHidden = false
                self.errorLabel2.text = error
            }
        })
        
        
    }
    
    @objc func updateTimer(_ sender: Any) {
        if resendSeconds == 0 { return }
        
        resendSeconds -= 1
        resendCodeNumberLabel.text = "\(resendSeconds)"
        
    }

}


extension PhoneVerificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        field1.resignFirstResponder()
        field2.resignFirstResponder()
        field3.resignFirstResponder()
        field4.resignFirstResponder()
        
        if !field1.text!.isEmpty && !field2.text!.isEmpty && !field3.text!.isEmpty && !field4.text!.isEmpty {
            verifyButton.active = true
            verifyButton.isEnabled = true
        } else {
            verifyButton.active = false
            verifyButton.isEnabled = false
        }
        
        if textField.text!.isEmpty {
            textField.becomeFirstResponder()
            return
        }
        
        if textField == field1 {
            field2.becomeFirstResponder()
        } else if textField == field2 {
            field3.becomeFirstResponder()
        } else if textField == field3 {
            field4.becomeFirstResponder()
        }  else if textField == field4 {
            field4.resignFirstResponder()
        }
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor(named: "accentColor")?.cgColor
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        return true
    }
}
