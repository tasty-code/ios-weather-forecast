//
//  LocationDataManager.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/03/20.
//

import Foundation
import OSLog
import CoreLocation

protocol LocationDataManagerDelegate: AnyObject {

    func locationDataManager(_ locationDataManager: LocationDataManager,
                             didUpdateLocation location: CLLocation)
    func locationDataManager(_ locationDataManager: LocationDataManager,
                             didAuthorized isAuthorized: Bool)

}

final class LocationDataManager: NSObject, CLLocationManagerDelegate {

    // MARK: - Properties

    private let locationManager = CLLocationManager()
    weak var delegate: LocationDataManagerDelegate?

    var isAuthorized: Bool {
        locationManager.authorizationStatus == .authorizedWhenInUse
    }

    // MARK: - Lifecycle

    override init() {
        super.init()
        locationManager.delegate = self
    }

    // MARK: - Public

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.locationDataManager(self, didUpdateLocation: location)
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        os_log(.error, log: .location, "%@", error.localizedDescription)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        delegate?.locationDataManager(self, didAuthorized: isAuthorized)
    }

}
