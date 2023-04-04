//
//  WeatherTransform.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

extension WeatherResponseDTO {
    func toDomain() -> WeatherEntity {
        return .init(weather: weather.map { $0.toDomain() }, main: main?.toDomain())
    }
}

extension WeatherElementDTO {
    func toDomain() -> WeatherElementEntity {
        return .init(id: id, main: main, description: description, icon: icon)
    }
}

extension MainDTO {
    func toDomain() -> MainWeatherEntity {
        return .init(temp: temp)
    }
}
