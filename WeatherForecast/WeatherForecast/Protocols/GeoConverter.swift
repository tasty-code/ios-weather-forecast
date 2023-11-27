import Foundation
import CoreLocation

protocol GeoConverter {
    func convertToAddressWith(coordinate: CLLocation)
}
extension GeoConverter {
    func convertToAddressWith(coordinate: CLLocation) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(coordinate) { (placemarks, error) -> Void in
            if error != nil {
                print("\(error)")
                return
            }
            
            
            guard let placemark = placemarks?.first else {
                return
            }
            print(placemark.subLocality)
        }
    }
}
