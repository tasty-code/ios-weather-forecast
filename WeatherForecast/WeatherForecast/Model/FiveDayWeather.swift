//
//  FiveDayWeather.swift
//  WeatherForecast
//
//  Created by 신동오 on 2023/03/15.
//

import Foundation

struct FiveDayWeather: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City

    // MARK: - City
    struct City: Codable {
        let id: Int
        let name: String
        let coord: Coord
        let country: String
        let population, timezone, sunrise, sunset: Int
    }

    // MARK: - Coord
    struct Coord: Codable {
        let lat, lon: Double
    }

    // MARK: - List
    struct List: Codable {
        let dt: Int
        let main: MainClass
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let visibility: Int
        let pop: Double
        let sys: Sys
        let dtTxt: String

        enum CodingKeys: String, CodingKey {
            case dt, main, weather, clouds, wind, visibility, pop, sys
            case dtTxt = "dt_txt"
        }
    }

    // MARK: - Clouds
    struct Clouds: Codable {
        let all: Int
    }

    // MARK: - MainClass
    struct MainClass: Codable {
        let temp, feelsLike, tempMin, tempMax: Double
        let pressure, seaLevel, grndLevel, humidity: Int
        let tempKf: Double

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
            case humidity
            case tempKf = "temp_kf"
        }
    }

    // MARK: - Sys
    struct Sys: Codable {
        let pod: Pod
    }

    enum Pod: String, Codable {
        case d = "d"
        case n = "n"
    }

    // MARK: - Weather
    struct Weather: Codable {
        let id: Int
        let main: MainEnum
        let description: Description
        let icon: Icon
    }

    enum Description: String, Codable {
        case brokenClouds = "broken clouds"
        case clearSky = "clear sky"
        case fewClouds = "few clouds"
        case overcastClouds = "overcast clouds"
        case scatteredClouds = "scattered clouds"
    }

    enum Icon: String, Codable {
        case the01D = "01d"
        case the01N = "01n"
        case the02N = "02n"
        case the03N = "03n"
        case the04D = "04d"
        case the04N = "04n"
    }

    enum MainEnum: String, Codable {
        case clear = "Clear"
        case clouds = "Clouds"
    }

    // MARK: - Wind
    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double
    }
}
