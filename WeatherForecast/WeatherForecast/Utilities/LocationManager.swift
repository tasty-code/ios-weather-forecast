import CoreLocation
import UIKit

final class LocationManager: NSObject {
    
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    
    typealias LocationCompletion = (Result<(CLLocationCoordinate2D, CLPlacemark), LocationError>) -> Void
    private var locationCompletion: LocationCompletion?
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.distanceFilter = kCLDistanceFilterNone
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.requestWhenInUseAuthorization()
    }
    
    func fetchCoordinate() -> CLLocationCoordinate2D? {
        guard let coordinate = manager.location?.coordinate else {
            return nil
        }
        
        return coordinate
    }
    
    func request(completion: @escaping LocationCompletion){
        manager.startUpdatingLocation()
        locationCompletion = completion
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case . denied, .notDetermined:
            print("위치 권한이 없습니다.")
        case . authorizedAlways, .authorizedWhenInUse:
            print("위치 권한이 있습니다.")
        case .restricted:
            print("위치 권한이 제한되어 있습니다.")
        default:
            print("default from LocationManager")
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let completion = self.locationCompletion else {
            return
        } 
        
        if manager.location?.coordinate == nil {
            completion(.failure(LocationError.cooridnateError))
        }
        
        manager.stopUpdatingLocation()
        fetchPlacemark()
    }
    
    func fetchPlacemark() {
        guard let completion = self.locationCompletion else {
            return
        }
        
        guard let coordinate = manager.location?.coordinate else {
            return completion(.failure(LocationError.cooridnateError))
        }
            
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, _ in
            
            guard let placemarks = placemarks,
                  let address = placemarks.last else {
                return completion(.failure(LocationError.placemarkError))
            }
            
            completion(.success((coordinate, address)))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let completion = self.locationCompletion else {
            return
        }
        
        completion(.failure(LocationError.unknownError(error)))
    }
}
