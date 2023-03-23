//
//  UserLocation.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/23.
//

import CoreLocation

final class UserLocation: NSObject, CLLocationManagerDelegate {
    
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
}
