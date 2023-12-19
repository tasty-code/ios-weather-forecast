//
//  ImageCacheable.swift
//  WeatherForecast
//
//  Created by 김진웅 on 12/19/23.
//

import UIKit

protocol ImageCacheable {
    func fetch(by id: String) -> UIImage?
    func store(with id: String, image: UIImage)
}
