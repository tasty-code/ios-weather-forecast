import Foundation

enum GeoConverterError: Error {
    case failCovertToAdress
    case failCovertToLocation
    
    var description: String {
        switch self {
            
        case .failCovertToAdress:
            return "위치 -> 주소 변환에 실패했습니다"
        case .failCovertToLocation:
            return "주소 -> 위치 변환에 실패했습니다."
        }
    }
}
