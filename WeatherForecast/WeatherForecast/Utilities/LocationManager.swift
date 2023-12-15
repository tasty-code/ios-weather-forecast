import CoreLocation
import UIKit

typealias LocationCompletion = (Result<(CLLocationCoordinate2D, CLPlacemark), LocationError>) -> Void

final class LocationManager: NSObject {
    private let manager = CLLocationManager()
    private var locationCompletion: LocationCompletion?
    private var didFindLocation: Bool = false
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.distanceFilter = kCLDistanceFilterNone
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestWhenInUseAuthorization()
    }
    
    func request(completion: @escaping LocationCompletion){
        if !didFindLocation {
            manager.requestLocation()
            didFindLocation = true
        }
        
        locationCompletion = completion
    }
    
    private func fetchPlacemark(for location: CLLocation) {
        guard let completion = locationCompletion else {
            return
        }
        
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.last else {
                return completion(.failure(LocationError.noPlacemarkError))
            }
            
            completion(.success((location.coordinate, address)))
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else {
            locationCompletion?(.failure(LocationError.noLocationError))
            return
        }
        
        if didFindLocation {
            didFindLocation = false
            fetchPlacemark(for: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if didFindLocation {
            didFindLocation = false
            fetchPlacemark(for: CLLocation(latitude: DefaultLocation.latitude, longitude: DefaultLocation.longitude))
            locationCompletion?(.failure(LocationError.didFailFetchLocationError))
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case . authorizedAlways, .authorizedWhenInUse:
            break
        case . denied, .notDetermined, .restricted:
            locationCompletion?(.failure(LocationError.noLocationAuthorizationError))
        default:
            locationCompletion?(.failure(LocationError.unknownLocationAuthorizationError))
        }
    }
}
