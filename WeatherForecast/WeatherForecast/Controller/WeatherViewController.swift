//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation
final class WeatherViewController: UIViewController {
    private let weatherNetworkManager = WeatherNetworkManager()
    private let locationDataManager = LocationDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationDataManager.locationDelegate = self
        weatherNetworkManager.weatherDelegate = self
    }
}

// MARK: - LocationDataManagerDelegate

extension WeatherViewController: LocationDataManagerDelegate {
    
    func location(_ manager: LocationDataManager, didLoadCoordinate coordinate: CLLocationCoordinate2D) {
        weatherNetworkManager.loadWeatherData(type: WeatherType.forecast, coord: coordinate)
    }
    
    func loaction(_ manager: LocationDataManager, didCompletePlcamark placemark: CLPlacemark?) {
        guard let placemark else {
            print("can't look up current address")
            return
        }
        
        if
            let country = placemark.country,
            let administrativeArea = placemark.administrativeArea,
            let locality = placemark.locality,
            let subLocality = placemark.subLocality,
            let thoroughfare = placemark.thoroughfare,
            let subThoroughfare = placemark.subThoroughfare
        {
            let address = "\(country) \(administrativeArea) \(locality) \(subLocality) \(thoroughfare) \(subThoroughfare)"
            print(address)
        }
    }
    
    func viewRequestLocationSettingAlert() {
        let requestLocationServiceAlert = UIAlertController(
            title: "위치 정보 이용",
            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert
        )
        let openSettingAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let exitAction = UIAlertAction(title: "종료", style: .destructive) { _ in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        
        requestLocationServiceAlert.addAction(openSettingAction)
        requestLocationServiceAlert.addAction(exitAction)
        present(requestLocationServiceAlert, animated: true)
    }
}

// MARK: - WeatherNetworkManagerDelegate

extension WeatherViewController: WeatherNetworkManagerDelegate {
    func weather<T>(_ manager: WeatherNetworkManager, didLoad data: T) where T : Decodable {
        print(data)
    }
}
