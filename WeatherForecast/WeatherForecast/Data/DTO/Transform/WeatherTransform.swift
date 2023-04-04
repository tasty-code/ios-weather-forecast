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

extension WeatherInformationDTO {
    func toDomain() -> WeatherInformationEntity {
        return .init(id: id, main: main, description: description, icon: icon)
    }
}

extension TemperatureInformationDTO {
    func toDomain() -> TempEntity {
        return .init(temp: temp)
    }
}
