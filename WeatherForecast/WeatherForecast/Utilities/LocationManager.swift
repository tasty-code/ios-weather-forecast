import CoreLocation
import UIKit

typealias LocationCompletion = (Result<(CLLocationCoordinate2D, CLPlacemark), LocationError>) -> Void

final class LocationManager: NSObject {
    private let manager = CLLocationManager()
    private var locationCompletion: LocationCompletion?
    
    override init() {
        super.init()

        setupLocationManager()
    }
    
    private func setupLocationManager() {
            manager.delegate = self
            manager.distanceFilter = kCLDistanceFilterNone
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
        }
    
    func request(coordinate: CLLocationCoordinate2D?, completion: @escaping LocationCompletion) {
        locationCompletion = completion
        
        coordinate == nil ? manager.requestLocation() : fetchPlacemark(for: coordinate)
    }
    
    private func fetchPlacemark(for coordinate: CLLocationCoordinate2D?) {
        guard let completion = locationCompletion else { return }
        
        guard let coordinate = coordinate else { return }
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, _ in
            guard let address = placemarks?.last else {
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
        
        manager.stopUpdatingLocation()
        fetchPlacemark(for: coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fetchPlacemark(for: CLLocationCoordinate2D(latitude: .defaultLatitude, longitude: .defaultLongitude))
        
        locationCompletion?(.failure(LocationError.didFailFetchLocationError))
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
