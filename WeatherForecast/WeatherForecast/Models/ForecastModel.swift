import Foundation

struct ForecastModel: Codable {
    let message: Int?
    let list: [List]?
    let city: City?
}

extension ForecastModel {
    struct City: Codable {
        let id: Int?
        let name: String?
        let coordinate: Coord?
        let country: String?
        let population, timezone, sunrise, sunset: Int?
        
        enum CodingKeys: String, CodingKey {
            case id, name, country, population, timezone, sunrise, sunset
            case coordinate = "coord"
        }
    }
}

extension ForecastModel {
    struct Coord: Codable {
        let lat, lon: Double?
    }
}

extension ForecastModel {
    struct List: Codable {
        let date: Int?
        let main: MainClass?
        let weather: [Weather]?
        let clouds: Clouds?
        let wind: Wind?
        let visibility: Int?
        let probabilityOfPrecipitation: Double?
        let rain: Rain?
        let system: Sys?
        let dateTxt: String?
        
        enum CodingKeys: String, CodingKey {
            case main, weather, clouds, wind, visibility, rain
            case dateTxt = "dt_txt"
            case date = "dt"
            case probabilityOfPrecipitation = "pop"
            case system = "sys"
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
        let pressure, seaLevel, groundLevel, humidity: Int?
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case seaLevel = "sea_level"
            case groundLevel = "grnd_level"
            case humidity
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
        let partOfDay: Pod?
        
        enum CodingKeys: String, CodingKey {
            case partOfDay = "pod"
        }
    }
}

extension ForecastModel {
    enum Pod: String, Codable {
        case day = "d"
        case night = "n"
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
        let degree: Int?
        let gust: Double?
        
        enum CodingKeys: String, CodingKey {
            case speed, gust
            case degree = "deg"
        }
    }
}
