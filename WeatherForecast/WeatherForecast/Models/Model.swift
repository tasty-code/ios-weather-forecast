struct Model {
}

extension Model {
    struct CurrentWeather: Decodable {
        let coord: Coord?
        let weather: [Weather]?
        let base: String?
        let main: Main?
        let visibility: Int?
        let wind: Wind?
        let clouds: Clouds?
        let rain: Rain?
        let snow: Snow?
        let dt: Int?
        let sys: Sys?
        let timezone: Int?
        let id: Int?
        let name: String?
        let cod: Int?
    }
    
    struct FiveDaysWeather: Decodable {
        let cod: String?
        let message: Int?
        let cnt: Int?
        let list: [List]?
        let city: City?
    }
}

extension Model.CurrentWeather {
    // MARK: - Coord
        struct Coord: Decodable {
            let lon: Double?
            let lat: Double?
        }
        
        // MARK: - Weather
        struct Weather: Decodable {
            let id: Int?
            let main: String?
            let description: String?
            let icon: String?
        }
        
        // MARK: - Main
        struct Main: Decodable {
            let temp: Double?
            let feelsLike: Double?
            let pressure: Int?
            let humidity: Int?
            let tempMin: Double?
            let tempMax: Double?
            let seaLevel: Int?
            let grndLevel: Int?
            
            enum CodingKeys: String, CodingKey {
                case temp
                case feelsLike = "feels_like"
                case pressure
                case humidity
                case tempMin = "temp_min"
                case tempMax = "temp_max"
                case seaLevel = "sea_level"
                case grndLevel = "grnd_level"
            }
        }
        
        // MARK: - Wind
        struct Wind: Decodable {
            let speed: Double?
            let gust: Double?
            let deg: Int?
        }
        
        // MARK: - Clouds
        struct Clouds: Decodable {
            let all: Int?
        }
        
        struct Rain: Decodable {
            let oneHour: Int?
            let threeHour: Int?
            
            enum CodingKeys: String, CodingKey {
                case oneHour = "1h"
                case threeHour = "3h"
            }
        }
        
        struct Snow: Decodable {
            let oneHour: Int?
            let threeHour: Int?
            
            enum CodingKeys: String, CodingKey {
                case oneHour = "1h"
                case threeHour = "3h"
            }
        }
        
        // MARK: - Sys
        struct Sys: Decodable {
            let type: Int?
            let id: Int?
            let country: String?
            let sunrise: Int?
            let sunset: Int?
        }
        
        struct List: Decodable {
            let dt: Int?
            let main: Main?
            let weather: [Weather]?
            let clouds: Clouds?
            let wind: Wind?
            let visibility: Int?
            let pop: Double?
            let sys: Sys?
            let dtTxt: String?
            let rain: Rain?
            
            enum CodingKeys: String, CodingKey {
                case dt
                case main
                case weather
                case clouds
                case wind
                case visibility
                case pop
                case sys
                case dtTxt = "dt_txt"
                case rain
            }
        }
        
    }

extension Model.FiveDaysWeather {
    // MARK: - List
    struct List: Decodable {
        let dt: Int?
        let main: Main?
        let weather: [Weather]?
        let clouds: Clouds?
        let wind: Wind?
        let visibility: Int?
        let pop: Double?
        let sys: Sys?
        let dtTxt: String?
        let rain: Rain?
        
        enum CodingKeys: String, CodingKey {
            case dt
            case main
            case weather
            case clouds
            case wind
            case visibility
            case pop
            case sys
            case dtTxt = "dt_txt"
            case rain
        }
    }
    
    // MARK: - Main
    struct Main: Decodable {
        let temp: Double?
        let feelsLike: Double?
        let pressure: Int?
        let humidity: Int?
        let tempMin: Double?
        let tempMax: Double?
        let seaLevel: Int?
        let grndLevel: Int?
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
    
    // MARK: - Weather
    struct Weather: Decodable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String?
    }
    
    // MARK: - Clouds
    struct Clouds: Decodable {
        let all: Int?
    }
    
    // MARK: - Wind
    struct Wind: Decodable {
        let speed: Double?
        let deg: Int?
        let gust: Double?
    }
    
    // MARK: - Rain
    struct Rain: Decodable {
        let threeHour: Double?
        
        enum CodingKeys: String, CodingKey {
            case threeHour = "3h"
        }
    }
    
    // MARK: - Snow
    struct Snow: Decodable {
        let threeHour: Double?
        
        enum CodingKeys: String, CodingKey {
            case threeHour = "3h"
        }
    }
    
    // MARK: - Sys
    struct Sys: Decodable {
        let pod: String?
    }
    
    // MARK: - City
    struct City: Decodable {
        let id: Int?
        let name: String?
        let coord: Coord?
        let country: String?
        let population: Int?
        let timezone: Int?
        let sunrise: Int?
        let sunset: Int?
    }
    
    // MARK: - Coord
    struct Coord: Decodable {
        let lat: Double?
        let lon: Double?
    }
}
