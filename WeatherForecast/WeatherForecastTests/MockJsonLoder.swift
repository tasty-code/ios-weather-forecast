import Foundation

private enum JsonLoaderError: Error {
    case unknownFile
    case dataConvertFail
    case notJsonData
    case decodingFail
    
    var description: Void {
        switch self {
            
        case .unknownFile:
            print("file을 찾지 못하겠습니다.")
        case .dataConvertFail:
            print("file의 내용을 data로 변환이 불가능합니다.")
        case .notJsonData:
            print("data가 json이 아닙니다.")
        case .decodingFail:
            print("디코딩에 실패하였습니다.")
        }
        
    }
}

final class JsonLoader {
    
    static func load<T:Decodable>(type: T.Type, fileName: String) -> T? {
        do {
           let fileURL = try fileURL(of: fileName)
            let data = try fileData(of: fileURL)
            try checkIsJsonData(of: data)
            let decodingData = try decode(of: data, to: type)
            return decodingData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func data(fileName: String) -> Data? {
        do {
            let fileURL = try fileURL(of: fileName)
            let data = try fileData(of: fileURL)
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private static func fileURL(of fileName: String) throws -> URL {
        let testBundle = Bundle(for: self)
        let filePath = testBundle.path(forResource: fileName, ofType: "json")
        guard let filePath = filePath else {
            throw JsonLoaderError.unknownFile
        }
        let fileURL = URL(fileURLWithPath: filePath)
        return fileURL
    }
    
    private static func fileData(of fileURL: URL) throws -> Data {
        guard let data = try? Data(contentsOf: fileURL) else {
            throw JsonLoaderError.dataConvertFail
        }
        return data
    }
    
    private static func checkIsJsonData(of data: Data) throws {
        guard let _ = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            throw JsonLoaderError.notJsonData
        }
    }
    
    private static func decode<T:Decodable>(of data: Data, to type: T.Type) throws -> T {
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            throw JsonLoaderError.decodingFail
        }
        return decodedData
    }
}
