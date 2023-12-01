import Foundation

struct Coordinate: Decodable {
    
    var longitude, latitude: Double
    
    enum CodingKeys: String, CodingKey {
        
        case longitude = "lon"
        case latitude = "lat"
    }
}
