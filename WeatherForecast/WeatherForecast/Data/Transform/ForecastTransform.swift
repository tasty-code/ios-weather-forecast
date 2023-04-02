//
//  ForecastTransform.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

extension ForecastResponseDTO {
    func toDomain() -> ForecastEntity {
        return .init(list: list.map { $0.toDomain() }, city: city.toDomain())
    }
}

extension ForecastResponseDTO.List {
    func toDomain() -> ListEntity {
        return .init(dtTxt: dtTxt,
                     main: main.toDomain(), weather: weather.map { $0.toDomain() })
    }
}

extension ForecastResponseDTO.City {
    func toDomain() -> CityEntity {
        return .init(name: name, country: country)
    }
}

extension ForecastResponseDTO.Main {
    func toDomain() -> MainForecastEntity {
        return .init(temp: temp)
    }
}

extension ForecastResponseDTO.WeatherElement {
    func toDomain() -> FiveDaysWeatherElementEntity {
        return .init(id: id, main: main, description: description, icon: icon)
    }
}
