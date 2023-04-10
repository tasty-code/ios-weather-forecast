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

extension ForecastListDTO {
    func toDomain() -> ForecastListEntity {
        return .init(dtTxt: dtTxt,
                     main: main.toDomain(), weather: weather.map { $0.toDomain() })
    }
}

extension CityInformationDTO {
    func toDomain() -> CityEntity {
        return .init(name: name, country: country)
    }
}
