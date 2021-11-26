//
//  GeneralAreaMapViewController.swift
//  Chicken On Fire
//
//  Created by user on 25/10/2021.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GeneralAreaMapViewController: UIViewController {
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var locationSheet: UIView!
    @IBOutlet weak var areaName: UILabel!
    @IBOutlet weak var sheetHeightConstraint: NSLayoutConstraint!

    var delegate: GeneralAreaDelegate?
    
    var polylines = [GMSPolyline]()
    var selectedCoordinates = GeneralAreaManager.getSavedArea().getCoordinates()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init search bar
        searchBar.backgroundImage = UIImage()
        
        // Setting map
        setMap()
        
        // Init settings
        areaName.text = GeneralAreaManager.getSavedArea().name
        searchBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        sheetHeightConstraint.constant = 100 + UIApplication.bottomSafeAreaHeight
    }
    
    private func setMap() -> Void {
        
        mapView.delegate = self
        
        // Setting default camera...
        let savedArea = GeneralAreaManager.getSavedArea()
        let camera = GMSCameraPosition(latitude: savedArea.latitude, longitude: savedArea.longitude, zoom: 11)
        mapView.camera = camera
        
        // Setting allowed locations polygons...
        AllowedLocations.getAllowedLocations(onSuccess: { polylines in
            self.polylines = polylines
            self.mapView.setPolylines(polylines: polylines)
        }, onFailure: { error in
            print(error)
        })
        
        // Setting Confirm button style
        confirmButton.layer.cornerRadius = 10
        confirmButton.layer.masksToBounds = true
        confirmButton.setTitle("Sorry, we don't deliver here", for: .disabled)
        confirmButton.setTitle("Confirm", for: .normal)
        
        
    }
    
    func setConfirmEnabled() -> Void {
        confirmButton.isEnabled = true
        confirmButton.alpha = 1
    }
    
    func setConfirmDisabled() -> Void {
        confirmButton.isEnabled = false
        confirmButton.alpha = 0.5
    }
    
    func hideLocationSheet() -> Void {
        UIView.animate(withDuration: 0.3, animations: {
            self.locationSheet.frame.origin.y += 200
        })
    }
    
    func showLocationSheet() -> Void {
        GeneralAreaManager.getAreaName(location: self.selectedCoordinates, onComplete: { name in
            self.areaName.text = name
            
            UIView.animate(withDuration: 0.3, animations: {
                self.locationSheet.frame.origin.y -= 200
            })
        })
       
    }
    
    @IBAction func confirmLocation(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
        delegate?.didConfirmLocation(area: Area(branchID: -1, name: areaName.text ?? "", latitude: selectedCoordinates.latitude, longitude: selectedCoordinates.longitude))
    }
    
    @IBAction func exitButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


extension GeneralAreaMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        DispatchQueue.main.async {
            self.hideLocationSheet()
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        selectedCoordinates = position.target
        
        if polylines.count == 0 { return }
        
        let coordinates = position.target
        if mapView.isInsideAnyRegion(coordinates: coordinates, polylines: polylines) {
            setConfirmEnabled()
        } else {
            setConfirmDisabled()
        }
        
        showLocationSheet()
    }
}


extension GeneralAreaMapViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        DispatchQueue.main.async {
            self.mapView.animate(to: GMSCameraPosition(target: place.coordinate, zoom: 11))
            self.selectedCoordinates = place.coordinate
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension GeneralAreaMapViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print ("Opening")
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        autocompleteController.placeFields = GMSPlaceField.myFields

        // Specify a filter.
        autocompleteController.autocompleteFilter = GMSAutocompleteFilter.myFilter
        
        present(autocompleteController, animated: true, completion: nil)
    }
}
