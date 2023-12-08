//
//  WeatherDataManagerDelegate.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation
import UIKit

protocol WeatherDataManagerDelegate: AnyObject {
    func completedLoadData(_ manager: WeatherDataManager)
    func viewRequestLocationSettingAlert()
}
