import Foundation

struct ForecastModel: Codable {
    let message: Int?
    let list: [List]?
    let city: City?
}

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

struct Coord: Codable {
    let lat, lon: Double?
}

struct List: Codable {
    let date: Int?
    let main: MainClass?
    let weather: [ForecastWeather]?
    let clouds: ForecastClouds?
    let wind: ForecastWind?
    let visibility: Int?
    let probabilityOfPrecipitation: Double?
    let rain: Rain?
    let system: ForecastSys?
    let dateTxt: String?
    
    enum CodingKeys: String, CodingKey {
        case main, weather, clouds, wind, visibility, rain
        case dateTxt = "dt_txt"
        case date = "dt"
        case probabilityOfPrecipitation = "pop"
        case system = "sys"
    }
}

struct ForecastClouds: Codable {
    let all: Int?
}

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

struct Rain: Codable {
    let the3H: Double?
    
    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct ForecastSys: Codable {
    let partOfDay: PartOfDay?
    
    enum CodingKeys: String, CodingKey {
        case partOfDay = "pod"
    }
}

enum PartOfDay: String, Codable {
    case day = "d"
    case night = "n"
}

struct ForecastWeather: Codable {
    let id: Int?
    let main: MainEnum?
    let description, icon: String?
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

struct ForecastWind: Codable {
    let speed: Double?
    let degree: Int?
    let gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed, gust
        case degree = "deg"
    }
}
