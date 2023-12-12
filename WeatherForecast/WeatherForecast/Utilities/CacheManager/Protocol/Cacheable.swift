//
//  Cacheable.swift
//  WeatherForecast
//
//  Created by 전성수 on 12/12/23.
//

import Foundation

protocol CacheStorable {
    associatedtype KeyType: AnyObject
    associatedtype ObjectType: AnyObject
    
    func storeCache(key: KeyType, value: ObjectType)
}

protocol CacheFetchable {
    associatedtype KeyType: AnyObject
    associatedtype ObjectType: AnyObject
    
    func fetchCache(key: KeyType) -> ObjectType?
}

