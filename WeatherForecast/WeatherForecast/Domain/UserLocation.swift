//
//  UserLocation.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/23.
//

import CoreLocation

final class UserLocation: NSObject, CLLocationManagerDelegate {
    
    //MARK: - Property
    static let shard = UserLocation()
    
    var location: CLLocation? {
        sharedLocationManager.location
    }
    
    lazy var sharedLocationManager: CLLocationManager = {
        let newLocationmanager = CLLocationManager()
        newLocationmanager.delegate = self
        return newLocationmanager
    }()
    
    //MARK: - Authorization
    func authorize() {
        sharedLocationManager.requestWhenInUseAuthorization()
    }
    
    func address() {
        guard let newLocation = location else {
            return
        }
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(newLocation) { placemark, error in
            guard error == nil else { return }
            
            if let placemark = placemark?.first {
                print(placemark)
            }
        }
    }
}
