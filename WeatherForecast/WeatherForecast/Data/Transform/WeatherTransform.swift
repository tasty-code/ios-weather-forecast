//
//  WeatherTransform.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

extension WeatherResponseDTO {
    
    func toDomain() -> WeatherEntitiy {
        return .init(weather: weather.map { $0.toDomain() }, main: main?.toDomain())
    }
}

extension WeatherResponseDTO.WeatherElement {
    func toDomain() -> WeatherElementEntity {
        return .init(id: id, main: main, description: description, icon: icon)
    }
}

extension WeatherResponseDTO.Main {
    func toDomain() -> MainWeatherEntity {
        return .init(temp: temp)
    }
}
