//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 2023/11/24.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    
    var locationManger : CLLocationManager?
    
    override init() {
        super.init()
        locationManger = CLLocationManager()
        locationManger?.delegate = self
        locationManger?.requestWhenInUseAuthorization()
        locationManger?.startUpdatingLocation()
        locationManger?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }

    private(set) var lat : Double = 0
    private(set) var lon : Double = 0
    private(set) var address: String?

    private func getAddress(){
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "ko-kR")
        geocoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: lon), preferredLocale: locale, completionHandler: { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                return
            }
            var address = ""
            if let country = placemark.country { address += "\(country) " }
            if let subAdministrativeArea = placemark.subAdministrativeArea { address += "\(subAdministrativeArea) " }
            if let administrativeArea = placemark.administrativeArea { address += "\(administrativeArea) " }
            if let subThoroughfare = placemark.name { address += "\(subThoroughfare) " }
            
            self.address = address
        })
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            debugPrint("위도: \(lat), 경도: \(lon)")
            getAddress()
            locationManger?.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("위치 업데이트 실패: ", error.localizedDescription)
    }
}
