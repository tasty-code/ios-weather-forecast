//
//  CacheManager.swift
//  WeatherForecast
//
//  Created by 전성수 on 12/12/23.
//

import UIKit

final class CacheManager<KeyType: AnyObject, ObjectType: AnyObject>: CacheStorable, CacheFetchable {
    typealias KeyType = KeyType
    typealias ObjectType = ObjectType
    
    private let cache: NSCache<KeyType, ObjectType> = NSCache()
    
    func storeCache(key: KeyType, value: ObjectType) {
        cache.setObject(value, forKey: key)
    }
    
    func fetchCache(key: KeyType) -> ObjectType? {
        return cache.object(forKey: key)
    }
}
