//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/03/24.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: - Private property
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    private var address = ""
    private var coordinate: CLLocationCoordinate2D?

    weak var delegate: LocationManagerDelegate?

    // MARK: - Public
    func startUpdatingLocation() {
        setUp()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            manager.requestWhenInUseAuthorization()
        }
    }

    func getAddress() -> String {
        return address
    }

    func getCoordinate() -> CLLocationCoordinate2D? {
        guard let coordinateData = coordinate else { return nil }
        return coordinateData
    }
    
    // MARK: - Lifecycle
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print(LocationError.emptyLocation.localizedDescription)
            return
        }
        print("[LocationManager](updated)location")
        coordinate = location.coordinate
        delegate?.fetchData()
        reverseGeocodeLocation(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // MARK: - Private
    private func setUp() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }

    private func reverseGeocodeLocation(_ location: CLLocation) {
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            self.address = ""

            guard let placemark = placemarks?.first else { return }

            if let administrativeArea = placemark.administrativeArea { self.address += administrativeArea }

            if let locality = placemark.locality { self.address += " \(locality)" }
            
        }
    }
}
