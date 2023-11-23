import Foundation

enum NetworkError: Error {
    case invalidUrl
    case invalidData
    case invalidResponse
    case decodingError
    
    var description: String {
        switch self {
            
        case .invalidUrl:
            return "잘못된 URL입니다."
        case .invalidData:
            return "잘못된 데이터입니다."
        case .invalidResponse:
            return "잘못된 응답입니다."
        case .decodingError:
            return "디코딩 에러입니다."
        
        }
    }
}
