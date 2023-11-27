import Foundation
import CoreLocation

protocol GeoConverter {
    func convertToAddresswith(coordinate: CLLocation)
}
extension GeoConverter {
    func convertToAddressWith(coordinate: CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(coordinate) { (placemarks, error) -> Void in
            if error != nil {
                print("\(error)")
                return
            }
            
            guard let placemark = placemarks?.first,
                  let addressList = placemark.addressDictionary?["FormattedAddressLines"] as? [String] else {
                return
            }
            
            let address = addressList.joined(separator: " ")
            
            print(address)
        }
    }
}
