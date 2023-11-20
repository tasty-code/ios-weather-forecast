import Foundation

struct ForecastModel: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [List]?
    let city: City?
}

extension ForecastModel {
    struct City: Codable {
        let id: Int?
        let name: String?
        let coord: Coord?
        let country: String?
        let population, timezone, sunrise, sunset: Int?
    }
}

extension ForecastModel {
    struct Coord: Codable {
        let lat, lon: Double?
    }
}

extension ForecastModel {
    struct List: Codable {
        let dt: Int?
        let main: MainClass?
        let weather: [Weather]?
        let clouds: Clouds?
        let wind: Wind?
        let visibility: Int?
        let pop: Double?
        let rain: Rain?
        let sys: Sys?
        let dtTxt: String?
        
        enum CodingKeys: String, CodingKey {
            case dt, main, weather, clouds, wind, visibility, pop, rain, sys
            case dtTxt = "dt_txt"
        }
    }
}

extension ForecastModel {
    struct Clouds: Codable {
        let all: Int?
    }
}

extension ForecastModel {
    struct MainClass: Codable {
        let temp, feelsLike, tempMin, tempMax: Double?
        let pressure, seaLevel, grndLevel, humidity: Int?
        let tempKf: Double?
        
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
}

extension ForecastModel {
    struct Rain: Codable {
        let the3H: Double?
        
        enum CodingKeys: String, CodingKey {
            case the3H = "3h"
        }
    }
}

extension ForecastModel {
    struct Sys: Codable {
        let pod: Pod?
    }
}

extension ForecastModel {
    enum Pod: String, Codable {
        case d = "d"
        case n = "n"
    }
}

extension ForecastModel {
    struct Weather: Codable {
        let id: Int?
        let main: MainEnum?
        let description: Description?
        let icon: String?
    }
}

extension ForecastModel {
    enum Description: String, Codable {
        case brokenClouds = "broken clouds"
        case clearSky = "clear sky"
        case fewClouds = "few clouds"
        case lightRain = "light rain"
        case overcastClouds = "overcast clouds"
        case scatteredClouds = "scattered clouds"
    }
}

extension ForecastModel {
    enum MainEnum: String, Codable {
        case clear = "Clear"
        case clouds = "Clouds"
        case rain = "Rain"
    }
}

extension ForecastModel {
    struct Wind: Codable {
        let speed: Double?
        let deg: Int?
        let gust: Double?
    }
}
