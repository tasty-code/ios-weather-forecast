import Foundation

enum NetworkError: Error {
    
    case invalidUrl
    case invalidData
    case invalidResponse
    case invalidAPIKEYName
    
    var description: String {
        
        switch self {
            
        case .invalidUrl:
            return "잘못된 URL입니다."
        case .invalidData:
            return "잘못된 데이터입니다."
        case .invalidResponse:
            return "잘못된 응답입니다."
        case .invalidAPIKEYName:
            return "존재하지 않는 API KEY의 이름입니다."
        }
    }
}
