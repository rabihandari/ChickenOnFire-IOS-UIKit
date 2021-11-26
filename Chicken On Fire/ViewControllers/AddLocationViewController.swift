//
//  SelectLocationViewController.swift
//  Chicken On Fire
//
//  Created by user on 16/11/2021.
//

import UIKit
import GoogleMaps
import MapKit
import GooglePlaces

class AddLocationViewController: UIViewController {
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet weak var confirmButton: CustomButton!
    
    let zoom: Float = 15

    var polyline: GMSPolyline?
    var selectedCoordinates = GeneralAreaManager.getSavedArea().getCoordinates()
    
    var address: Address?
    var onAddAddress: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let address = address {
            selectedCoordinates = address.getCoordinates()
        }

        setMap()
    }
    
    
    private func setMap() -> Void {
        mapView.delegate = self
        
        // Setting default camera...
        let camera = GMSCameraPosition(latitude: selectedCoordinates.latitude, longitude: selectedCoordinates.longitude, zoom: zoom)
        mapView.camera = camera
        
        // Setting allowed locations polygons...
        AllowedLocations.getAllowedLocation(branchId: GeneralAreaManager.getSavedArea().branchID ,onSuccess: { polyline in
            self.polyline = polyline
            self.mapView.setPolyline(polyline: polyline)
        }, onFailure: { error in
            print(error)
        })
        
    }
    
    func setConfirmEnabled() -> Void {
        confirmButton.isEnabled = true
        confirmButton.active = true
        confirmButton.middleLabel.text = "Confirm"
    }
    
    func setConfirmDisabled() -> Void {
        confirmButton.isEnabled = false
        confirmButton.active = false
        confirmButton.middleLabel.text = "Sorry, we don't deliver here"
    }
    
    
    @IBAction func exitButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func showSearch(_ sender: Any){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        autocompleteController.placeFields = GMSPlaceField.myFields

        // Specify a filter.
        autocompleteController.autocompleteFilter = GMSAutocompleteFilter.myFilter
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAddressSegue" {
            let vc = segue.destination as! AddAddressViewController
            vc.selectedCoordinates = selectedCoordinates
            vc.address = self.address
            vc.onAddAddress = onAddAddress
        }
    }

}


extension AddLocationViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        selectedCoordinates = position.target
        
        guard let polyline = self.polyline else { return }
        
        let coordinates = position.target
        if mapView.isInsideRegion(coordinates: coordinates, polyline: polyline) {
            setConfirmEnabled()
        } else {
            setConfirmDisabled()
        }
    }
    
}

extension AddLocationViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        DispatchQueue.main.async {
            self.mapView.animate(to: GMSCameraPosition(target: place.coordinate, zoom: self.zoom))
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
