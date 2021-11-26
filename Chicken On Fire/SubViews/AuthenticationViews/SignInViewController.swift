//
//  SignInViewController.swift
//  Chicken On Fire
//
//  Created by user on 22/11/2021.
//

import UIKit
import FBSDKLoginKit
import NicoProgress

class SignInViewController: UIViewController {
    
    @IBOutlet weak var guestButton: CustomButton!
    @IBOutlet weak var orView: UIStackView!
    @IBOutlet weak var progressView: NicoProgressBar!
    
    var guestEnabled: Bool!
    var onSuccess: ((UserAccount) -> Void)?
    var onGuestLogin: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guestButton.isHidden = !guestEnabled
        orView.isHidden = !guestEnabled
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInWithEmailSegue" {
            let vc = segue.destination as! SignInWithEmailViewController
            vc.onSuccess = onSuccess
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func guestLogin(_ sender: Any) {
        onGuestLogin?()
    }

    
    @IBAction func signInWithFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: nil, handler: {(result, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            if !result!.isCancelled {
                self.progressView.isHidden = false
                
                let request = GraphRequest(graphPath: "me", parameters: ["fields": "first_name,last_name,email"])
                request.start { (_, res, _) in
                    guard let profileData = res as? [String: Any] else {
                        self.progressView.isHidden = true
                        return
                        
                    }
                    
                    let password = UUID().uuidString
                    
                    UserAccountApi.createAccount(method: "facebook", firstName: profileData["first_name"] as! String, lastName: profileData["last_name"] as! String, email: profileData["email"] as! String, password: password, onSuccess: {
                        
                        DispatchQueue.main.async {
                            self.progressView.isHidden = true
                            self.onSuccess?(UserAccount(email: profileData["email"] as! String, password: password, authenticated: true))
                        }
                        
                    }, onFailure: { error in
                        print(error)
                        self.progressView.isHidden = true
                    })
                    
                }
                
            }
            
            
        })
    }
    
}
