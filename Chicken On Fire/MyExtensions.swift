//
//  MyExtensions.swift
//  Chicken On Fire
//
//  Created by user on 25/10/2021.
//

import Foundation
import GoogleMaps
import GooglePlaces

extension GMSMapView {
    func setPolylines(polylines: [GMSPolyline]) -> Void {
        for polyline in polylines {
            polyline.strokeWidth = 5
            polyline.strokeColor = UIColor.red.withAlphaComponent(0.5)
            polyline.geodesic = true
            polyline.map = self
        }
            
    }
    
    func setPolyline(polyline: GMSPolyline) -> Void {
        polyline.strokeWidth = 5
        polyline.strokeColor = UIColor.red.withAlphaComponent(0.5)
        polyline.geodesic = true
        polyline.map = self
        
    }
    
    func isInsideRegion(coordinates: CLLocationCoordinate2D, polyline: GMSPolyline) -> Bool {
        if polyline.path == nil {
            return true
        }
        let contains = GMSGeometryContainsLocation(coordinates, GMSPath(path: polyline.path!), polyline.geodesic)
        return contains
    }
    
    func isInsideAnyRegion(coordinates: CLLocationCoordinate2D, polylines: [GMSPolyline]) -> Bool {
        if polylines.count == 0 {
            return true
        }
        
        var contains = false
        for polyline in polylines {
            if GMSGeometryContainsLocation(coordinates, GMSPath(path: polyline.path!), polyline.geodesic) {
                contains = true
                break
            }
        }
        return contains
    }
}


extension GMSPlaceField {
    static var myFields: GMSPlaceField {
        let fields: GMSPlaceField = GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue) |
            GMSPlaceField.addressComponents.rawValue |
            GMSPlaceField.formattedAddress.rawValue)
        return fields
    }
}

extension GMSAutocompleteFilter {
    static var myFilter: GMSAutocompleteFilter {
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.countries = ["KW"]
        return filter
    }
}

extension UITableViewCell {
    func removeSectionSeparators() {
        for subview in subviews {
            if subview != contentView && subview.frame.width == frame.width {
                subview.removeFromSuperview()
            }
        }
    }
}

extension UIApplication {
    static var topSafeAreaHeight: CGFloat {
        let window = UIApplication.shared.windows.first
        return window?.safeAreaInsets.top ?? 0
    }
    
    static var bottomSafeAreaHeight: CGFloat {
        let window = UIApplication.shared.windows.first
        return window?.safeAreaInsets.bottom ?? 0
    }
    
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 3848245

            let keyWindow = UIApplication.shared.connectedScenes
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows.first

            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
                let statusBarView = UIView(frame: height)
                statusBarView.tag = tag
                statusBarView.layer.zPosition = 999999

                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }

        } else {

            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
      }
    

}

extension Array where Iterator.Element == UIViewController {
    var previous: UIViewController? {
        if self.count > 1 {
            return self[self.count - 2]
        }
        return nil
    }

}

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                if #available(iOS 10.0, *) {
                    application.open(URL(string: url)!, options: [:], completionHandler: nil)
                }
                else {
                    application.openURL(URL(string: url)!)
                }
                return
            }
        }
    }
}
