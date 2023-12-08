//
//  ImageCacheManager.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation
import UIKit

final class ImageCacheManager {
    static let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    static func setCache(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    static func getCache(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
