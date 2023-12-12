import Foundation

struct Clouds: Decodable {
    let cloudiness: Int
    
    enum CodingKeys: String, CodingKey {
        case cloudiness = "all"
    }
}

struct Rain: Decodable {
    
    let amountOfRainOneHour, amountOfRainThreeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case amountOfRainOneHour = "1h"
        case amountOfRainThreeHour = "3h"
    }
}

struct Wind: Decodable {
    
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Snow: Decodable {
    
    let amountOfSnowOneHour, amountOfSnowThreeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        
        case amountOfSnowOneHour = "1h"
        case amountOfSnowThreeHour = "3h"
    }
}

struct Weather: Decodable {
    
    let main: String
    let description: String
    let icon: String
}
