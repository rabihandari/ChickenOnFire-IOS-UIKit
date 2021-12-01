//
//  RestaurantInfoViewController.swift
//  Chicken On Fire
//
//  Created by user on 23/11/2021.
//

import UIKit
import MapKit
import GoogleMaps

class RestaurantInfoViewController: UIViewController {
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantDesc: UILabel!
    @IBOutlet weak var restaurantCover: UIImageView!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var minimumOrder: UILabel!
    @IBOutlet weak var serviceCharge: UILabel!
    @IBOutlet weak var preOrder: UILabel!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var monday: UILabel!
    @IBOutlet weak var tuesday: UILabel!
    @IBOutlet weak var wednesday: UILabel!
    @IBOutlet weak var thursday: UILabel!
    @IBOutlet weak var friday: UILabel!
    @IBOutlet weak var saturday: UILabel!
    @IBOutlet weak var sunday: UILabel!
    @IBOutlet weak var creditCardView: UIStackView!
    @IBOutlet weak var cashOnDeliveryView: UIStackView!
    @IBOutlet weak var knetView: UIStackView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    let language = LanguageManager.language

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let generalInfo = GeneralInfoManager.getGeneralInfo() else {
            return
        }
        
        // Setting Design...
        restaurantCover.layer.cornerRadius = 10
        restaurantCover.layer.masksToBounds = true
        
        restaurantName.text = RestaurantInfoManager.name
        restaurantDesc.text = language == "en" ? generalInfo.Cuisine : generalInfo.Cuisine_Second_Language
        deliveryTime.text = "\(generalInfo.Delivery_Time) " +  "min".localized()
        minimumOrder.text = "\(String(format: "%.3f", generalInfo.Minimum_Order)) KD"
        serviceCharge.text = "\(String(format: "%.3f", generalInfo.AVG_Service_Fee)) KD"
        preOrder.text = generalInfo.Pre_Order ? "YES".localized() : "NO".localized()
        area.text = RestaurantInfoManager.restaurantArea
        monday.text = getWorkingDayTime(openingTime: generalInfo.openingTimes!.Monday)
        tuesday.text = getWorkingDayTime(openingTime: generalInfo.openingTimes!.Tuesday)
        wednesday.text = getWorkingDayTime(openingTime: generalInfo.openingTimes!.Wednesday)
        thursday.text = getWorkingDayTime(openingTime: generalInfo.openingTimes!.Thursday)
        friday.text = getWorkingDayTime(openingTime: generalInfo.openingTimes!.Friday)
        saturday.text = getWorkingDayTime(openingTime: generalInfo.openingTimes!.Saturday)
        sunday.text = getWorkingDayTime(openingTime: generalInfo.openingTimes!.Sunday)
        if !generalInfo.Payment_Methods.contains("visa") && !generalInfo.Payment_Methods.contains("master-card")  {
            creditCardView.isHidden = true
        }
        if !generalInfo.Payment_Methods.contains("cash") {
            cashOnDeliveryView.isHidden = true
        }
        if !generalInfo.Payment_Methods.contains("knet") {
            knetView.isHidden = true
        }
        location.text = RestaurantInfoManager.restaurantArea
        setupMap()
        
    }
    
    private func setupMap() -> Void {
        let camera = GMSCameraPosition(latitude: RestaurantInfoManager.restaurantLatitude, longitude: RestaurantInfoManager.restaurantLongitude, zoom: 12)
        mapView.camera = camera
    }
    
    
    private func getWorkingDayTime(openingTime: WorkingDay) -> String {
        return "\(self.getWorkingHours(hour: openingTime.opiningHour, minute: openingTime.opiningMin)) - \(self.getWorkingHours(hour: openingTime.closingHour, minute: openingTime.closingMin))"
    }
    
    
    private func getWorkingHours(hour: Int, minute: Int) -> String {
        if hour > 12 {
            return "\(String(format: "%02d", hour - 12)):\(String(format: "%02d", minute)) " + "PM".localized()
        } else if hour == 0 {
            return "12:\(String(format: "%02d", minute)) " + "AM".localized()
        } else {
            return "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)) " + "AM".localized()
        }
    }

    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func getDirections(_ sender: Any) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: RestaurantInfoManager.restaurantLatitude, longitude: RestaurantInfoManager.restaurantLongitude)))
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }

}
