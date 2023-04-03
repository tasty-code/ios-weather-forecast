//
//  ImageCacheManager.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/04/03.
//

import Foundation
import UIKit

final class ImageCacheManager {

    // MARK: - Properties
    static let shared = ImageCacheManager()
    private let cacheManager =  NSCache<NSString, UIImage>()

    // MARK: - LifeCycle

    private init() {}

    // MARK: - Public

    func get(for key: String) -> UIImage? {
        cacheManager.object(forKey: key as NSString)
    }

    func store(_ value: UIImage, for key: String) {
        cacheManager.setObject(value, forKey: key as NSString)
    }

}
