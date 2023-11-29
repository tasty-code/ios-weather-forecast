import CoreLocation
import UIKit

final class LocationManager: NSObject {
    let locationManager: CLLocationManager = {
       let locationManager = CLLocationManager()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return locationManager
    }()
    weak var delegate: UILocationDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func fetchCoordinate() -> CLLocationCoordinate2D? {
        if let coordinate = locationManager.location?.coordinate {
            delegate?.updateUI(coordinate: coordinate)
            return coordinate
        } else {
            return nil
        }
    }
    
    func fetchPlacemark() {
        guard let coordinate = locationManager.location?.coordinate else {
            return
        }
            
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.last else {
                return
            }
            self?.delegate?.updatePlacemark(placemark: address)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else {
            return
        }
        
        manager.stopUpdatingLocation()
        delegate?.updateUI(coordinate: coordinate)
        fetchPlacemark()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager - locationManager")
        print(error)
    }
}
