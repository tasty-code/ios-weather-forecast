//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    private let repository = Repository()
    let location = CLLocationCoordinate2D(latitude: 44.34, longitude: 10.99)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserLocation.shard.authorize()
        //MARK: - 테스트용 출력
        UserLocation.shard.address { (result) in
            switch result {
            case .success(let address):
                print(address)
            case .failure(let error):
                print(error)
            }
        }

        //MARK: - API 호출을 잠시 감췄습니다
//        do {
//            try repository.loadData(location: location, path: .currentWeather)
//            try repository.loadData(location: location, path: .forecastWeather)
//        } catch {
//            print(error.localizedDescription)
//        }
    }
}
