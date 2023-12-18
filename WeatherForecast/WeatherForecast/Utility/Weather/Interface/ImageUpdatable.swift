//
//  ImageUpdatable.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/12/18.
//

import UIKit

protocol ImageUpdatable: AnyObject {
    func requestImage(name: String, completion: @escaping (UIImage?) -> ())
}
