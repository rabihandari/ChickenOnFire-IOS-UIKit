//
//  AddAddressViewController.swift
//  Chicken On Fire
//
//  Created by user on 16/11/2021.
//

import UIKit
import GoogleMaps
import MapKit
import FlagPhoneNumber

class AddAddressViewController: UIViewController {
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var phoneValidImage: UIImageView!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var areaText: UITextField!
    @IBOutlet weak var addressTypeSegment: UISegmentedControl!
    @IBOutlet weak var blockText: UITextField!
    @IBOutlet weak var streetText: UITextField!
    @IBOutlet weak var avenueText: UITextField!
    @IBOutlet weak var houseText: UITextField!
    @IBOutlet weak var buildingText: UITextField!
    @IBOutlet weak var floorText: UITextField!
    @IBOutlet weak var apartmentText: UITextField!
    @IBOutlet weak var officeText: UITextField!
    @IBOutlet weak var phoneNumberFPN: FPNTextField!
    @IBOutlet weak var additionalDirectionsText: UITextField!
    @IBOutlet weak var confirmText: UIButton!
    @IBOutlet weak var confirmButton: CustomButton!
    
    var addressType: AddressType = .house
    var phoneNumberValid = false
    var phoneNumber = ""
    var phoneCode = ""
    
    var selectedCoordinates = CLLocationCoordinate2D()
    
    var address: Address?
    var onAddAddress: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting Google Map...
        setupMap()
        
        // Initializing texts...
        setupUI()
        
        
    }
    
    private func setupUI() {
        // Phone Number Picker...
        phoneNumberFPN.delegate = self
        phoneNumberFPN.setFlag(key: .KW)
        phoneNumberFPN.flagButtonSize = CGSize(width: 60, height: 45)
        phoneNumberFPN.layer.borderWidth = 0.25
        phoneNumberFPN.layer.cornerRadius = 5
        phoneNumberFPN.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberFPN.setCountries(including: [.KW, .LB])
        
        // Setting default address...
        areaText.text = GeneralAreaManager.getSavedArea().name
        if let address = address {
            firstNameText.text = address.firstName
            lastNameText.text = address.lastName
            areaText.text = address.area
            blockText.text = address.block
            streetText.text = address.street
            avenueText.text = address.avenue
            houseText.text = address.house
            buildingText.text = address.building
            floorText.text = String(address.floor)
            apartmentText.text = String(address.apartmentNo)
            officeText.text = address.office
            additionalDirectionsText.text = address.additionalDirections
            phoneNumberFPN.set(phoneNumber: address.phoneCode + address.phoneNumber)
            
            if address.addressType == .house {
                addressTypeSegment.selectedSegmentIndex = 0
            } else if address.addressType == .aparatment {
                addressTypeSegment.selectedSegmentIndex = 1
            } else {
                addressTypeSegment.selectedSegmentIndex = 2
            }
        }
        
        
        updateUIFromSegment()
        formUpdated()
    }
    
    
    private func setupMap() -> Void {
        let camera = GMSCameraPosition(latitude: selectedCoordinates.latitude, longitude: selectedCoordinates.longitude, zoom: 15)
        mapView.camera = camera
        
        mapView.layer.cornerRadius = 10
        mapView.layer.masksToBounds = true
        
    }
    
    private func hideTextField(textField: UITextField) -> Void {
        if !textField.isHidden {
            textField.isHidden = true
        }
    }
    
    private func showTextField(textField: UITextField) -> Void {
        if textField.isHidden {
            textField.isHidden = false
        }
    }
    
    private func setValidImageStatus(valid: Bool) {
        if valid {
            phoneValidImage.image = UIImage(systemName: "checkmark.circle")
            phoneValidImage.tintColor = .green
        } else {
            phoneValidImage.image = UIImage(systemName: "exclamationmark.triangle")
            phoneValidImage.tintColor = .red
        }
    }
    
    private func updateUIFromSegment() {
        switch addressTypeSegment.selectedSegmentIndex {
        case 0:
            hideTextField(textField: buildingText)
            hideTextField(textField: floorText)
            hideTextField(textField: apartmentText)
            hideTextField(textField: officeText)
            showTextField(textField: houseText)
            addressType = .house
        case 1:
            showTextField(textField: buildingText)
            showTextField(textField: floorText)
            showTextField(textField: apartmentText)
            hideTextField(textField: officeText)
            hideTextField(textField: houseText)
            addressType = .aparatment
            break
        case 2:
            showTextField(textField: buildingText)
            showTextField(textField: floorText)
            hideTextField(textField: apartmentText)
            showTextField(textField: officeText)
            hideTextField(textField: houseText)
            addressType = .office
            default:
                break
        }
        self.stackView.layoutIfNeeded()
        
    }
    
    private func isValid() -> Bool {
        if firstNameText.text!.isEmpty || lastNameText.text!.isEmpty || areaText.text!.isEmpty || blockText.text!.isEmpty || streetText.text!.isEmpty || phoneNumber.isEmpty {
            return false
        }
        
        if addressType == .house {
            if houseText.text!.isEmpty {
                return false
            }
        }else if addressType == .aparatment {
            if buildingText.text!.isEmpty || apartmentText.text!.isEmpty || floorText.text!.isEmpty {
                return false
            }
        }else if addressType == .office {
            if buildingText.text!.isEmpty || officeText.text!.isEmpty || floorText.text!.isEmpty {
                return false
            }
        }
        return true
    }
    
    
    
    func formUpdated() -> Void {
        confirmButton.isEnabled = isValid()
        confirmButton.active = isValid()
        confirmText.isEnabled = isValid()
        confirmText.alpha = isValid() ? 1 : 0.5
    }
    
    
    private func getAddress() -> Address {
        let address = Address(branchId: GeneralAreaManager.getSavedArea().branchID, firstName: firstNameText.text!, lastName: lastNameText.text!, area: areaText.text!, addressType: addressType, block: blockText.text!, street: streetText.text!, avenue: avenueText.text!, house: houseText.text!, building: buildingText.text!, floor: Int(floorText.text!) ?? -1, apartmentNo: Int(apartmentText.text!) ?? -1, office: officeText.text!, phoneCode: phoneCode, phoneNumber: phoneNumber, additionalDirections: additionalDirectionsText.text!, locationLat: String(selectedCoordinates.latitude), locationLong: String(selectedCoordinates.longitude))
        return address
    }
    
    
    @IBAction func changedText(_ sender: UITextField) {
        formUpdated()
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: [], animations: {
            self.updateUIFromSegment()
        })
        self.formUpdated()
    }
      
    
    @IBAction func exitButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func confirmAddress(sender: Any) {
        if address == nil {
            UserAddressManager.userAddresses.append(getAddress())
            
            if let onAddAddress = onAddAddress {
                onAddAddress()
            } else {
                let storybaord = UIStoryboard(name: "Main", bundle: .main)
                let viewController = storybaord.instantiateViewController(identifier: "Checkout") as! CheckoutViewController
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        } else {
            guard let index = UserAddressManager.userAddresses.firstIndex(where: { _address in
                _address.id == address?.id
            }) else {
                print("Failed to fetch address")
                return
            }
            UserAddressManager.userAddresses[index] = getAddress()
            onAddAddress?()
        }
    }

}


extension AddAddressViewController: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        phoneCode = dialCode
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        setValidImageStatus(valid: isValid)
        phoneNumberValid = isValid
        
        if isValid {
            phoneNumber = textField.getRawPhoneNumber() ?? ""
        } else {
            phoneNumber = ""
        }
        formUpdated()
    }
    
    func fpnDisplayCountryList() {
        
    }
    
    
}
