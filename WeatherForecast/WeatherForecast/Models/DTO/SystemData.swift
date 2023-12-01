import Foundation

struct SystemData: Decodable {
    
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int
}
