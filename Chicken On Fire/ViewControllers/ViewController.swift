//
//  ViewController.swift
//  Chicken On Fire
//
//  Created by user on 25/10/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGeneralInfo()
    }
    
    override func viewDidLayoutSubviews() {
        // Hiding navigation bar
        navigationController?.navigationBar.isHidden = true
    }
    
    private func getGeneralInfo() -> Void {
        let account = UserAccountManager.savedUserAccount()
        let savedArea = GeneralAreaManager.getSavedArea()
        GeneralInfoApi.getGeneralInfo(email: account.email, password: account.password, branchID: savedArea.branchID == -1 ? nil : savedArea.branchID, onSuccess: { generalInfo in
            
            GeneralInfoManager.setGeneralInfo(generalInfo: generalInfo)
            self.goToGeneralArea()
            
        }, onFailure: { error in
            print(error)
        })
    }

    private func goToGeneralArea() -> Void {
        DispatchQueue.main.async {
            let storybaord = UIStoryboard(name: "Main", bundle: .main)
            let viewController = storybaord.instantiateViewController(identifier: "GeneralArea")
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

}

