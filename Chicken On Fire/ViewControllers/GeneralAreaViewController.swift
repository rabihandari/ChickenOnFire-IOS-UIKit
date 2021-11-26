//
//  GeneralAreaViewController.swift
//  Chicken On Fire
//
//  Created by user on 25/10/2021.
//

import UIKit

class GeneralAreaViewController: UIViewController, GeneralAreaDelegate {

    @IBOutlet weak var showMapView: UIView!
    @IBOutlet weak var areaName: UILabel!
    @IBOutlet weak var showMenuButton: UIButton!
    @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting Show Menu button style
        showMenuButton.layer.cornerRadius = 10
        showMenuButton.layer.masksToBounds = true
        
        // Initialize Selected Area
        let savedArea = GeneralAreaManager.getSavedArea()
        if savedArea.branchID == -1 {
            showMapView.alpha = 0.5
            setShowMenuDisabled()
        } else {
            areaName.text = savedArea.name
            setShowMenuEnabled()
        }
        
        // Initialize tap gesture
        let tapGestureRecognized = UITapGestureRecognizer(target: self, action: #selector(goToMapView(_:)))
        showMapView.addGestureRecognizer(tapGestureRecognized)
    }
    
    func setShowMenuEnabled() -> Void {
        showMenuButton.isEnabled = true
        showMenuButton.alpha = 1
    }
    
    func setShowMenuDisabled() -> Void {
        showMenuButton.isEnabled = false
        showMenuButton.alpha = 0.5
    }
    
    func setIsLoading(loading: Bool) -> Void {
        if loading {
            downArrow.isHidden = true
            loadingIndicator.isHidden = false
            setShowMenuDisabled()
        } else {
            downArrow.isHidden = false
            loadingIndicator.isHidden = true
            setShowMenuEnabled()
        }
    }
    
    @objc func goToMapView(_ sender: UITapGestureRecognizer){
        DispatchQueue.main.async {
            let storybaord = UIStoryboard(name: "Main", bundle: .main)
            let viewController = storybaord.instantiateViewController(identifier: "GeneralAreaMap") as! GeneralAreaMapViewController
            viewController.delegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    
    func didConfirmLocation(area: Area) {
        setIsLoading(loading: true)
        areaName.text = area.name
        
        GeneralInfoApi.getBranchInfo(coordinates: area.getCoordinates(), onSuccess: { branchInfo in
            DispatchQueue.main.async {
                
                // Setting Area to User defaults...
                var selectedArea = area
                selectedArea.branchID = branchInfo.brID
                GeneralAreaManager.setArea(area: selectedArea)
                
                // Setting General Info branch settings...
                GeneralInfoManager.setBranchInfo(branchInfo: branchInfo)
                
                self.setShowMenuEnabled()
                self.showMapView.alpha = 1
                self.setIsLoading(loading: false)
            }
            
        }, onFailure: { error in
            print(error)
        })
    }
    
}
