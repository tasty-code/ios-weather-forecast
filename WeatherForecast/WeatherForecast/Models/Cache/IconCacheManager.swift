//
//  IconCacheManager.swift
//  WeatherForecast
//
//  Created by 김경록 on 12/14/23.
//

import UIKit

final class IconCacheManager {
    private static let shared = NSCache<NSString, UIImage>()
    
    func getIcon(with iconID: String) -> UIImage? {
        let id = NSString(string: iconID)
        if let image = IconCacheManager.shared.object(forKey: id) {
            return image
        }
        
        return nil
    }
    
    func store(with iconID: String, icon: UIImage) {
        let id = NSString(string: iconID)
        IconCacheManager.shared.setObject(icon, forKey: id)
    }
}
