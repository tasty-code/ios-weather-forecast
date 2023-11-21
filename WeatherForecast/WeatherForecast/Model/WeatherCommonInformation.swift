//
//  WeatherInformation.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/21/23.
//

import Foundation

struct WeatherCommonInformation {
}

// MARK: - Main

extension WeatherCommonInformation {
    struct Main: Decodable {
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let seaLevel: Int
        let grndLevel: Int
        let tempKf: Double?
        let temp: Double
        let pressure: Int
        let humidity: Int
        
        private enum CodingKeys: String, CodingKey {
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
            case tempKf = "temp_kf"
            case temp, pressure, humidity
        }
    }
}

// MARK: - Weather

extension WeatherCommonInformation {
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}

// MARK: - Clouds

extension WeatherCommonInformation {
    struct Clouds: Decodable {
        let all: Int
    }
}

// MARK: - Wind

extension WeatherCommonInformation {
    struct Wind: Decodable {
        let speed: Double
        let deg: Int
        let gust: Double
    }
}

// MARK: - Rain

extension WeatherCommonInformation {
    struct Rain: Decodable {
        let oneHour: Double?
        let threeHour: Double?
        
        private enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
            case threeHour = "3h"
        }
    }
}

// MARK: - Snow

extension WeatherCommonInformation {
    struct Snow: Decodable {
        let oneHour: Double?
        let threeHour: Double?
        
        private enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
            case threeHour = "3h"
        }
    }
}

// MARK: - Coord

extension WeatherCommonInformation {
    struct Coord: Decodable {
        let lon: Double
        let lat: Double
    }
}
