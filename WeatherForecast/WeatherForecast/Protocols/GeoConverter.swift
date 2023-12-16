import Foundation
import CoreLocation

protocol GeoConverter {
    
    func convertToAddressWith(location: CLLocation, completionHandler: @escaping (Result<String,GeoConverterError>) -> Void)
}

extension GeoConverter {
    
    func convertToAddressWith(location: CLLocation, completionHandler: @escaping (Result<String,GeoConverterError>) -> Void) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                completionHandler(.failure(.failCovertToAdress))
            }
            
            guard let placemark = placemarks?.last, let name = placemark.subLocality else {
                return completionHandler(.failure(.failCovertToAdress))
            }
            
            completionHandler(.success(name))
        }
    }
}

