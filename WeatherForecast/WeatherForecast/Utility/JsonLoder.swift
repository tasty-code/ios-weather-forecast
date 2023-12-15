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
    
    func load<T:Decodable>(type: T, fileName: String) -> T? {
        do {
           let fileURL = try fileURL(of: fileName)
            let data = try fileData(of: fileURL)
            try checkIsJsonData(of: data)
            let decodingData = decode(weatherType: type, data: data)
            return decodingData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func data(fileName: String) -> Data? {
        do {
            let fileURL = try fileURL(of: fileName)
            let data = try fileData(of: fileURL)
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func fileURL(of fileName: String) throws -> URL {
        let testBundle = Bundle(for: JsonLoader.self)
        let filePath = testBundle.path(forResource: fileName, ofType: "json")
        guard let filePath = filePath else {
            throw JsonLoaderError.unknownFile
        }
        let fileURL = URL(fileURLWithPath: filePath)
        return fileURL
    }
    
    private func fileData(of fileURL: URL) throws -> Data {
        guard let data = try? Data(contentsOf: fileURL) else {
            throw JsonLoaderError.dataConvertFail
        }
        return data
    }
    
    private func checkIsJsonData(of data: Data) throws {
        guard let _ = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            throw JsonLoaderError.notJsonData
        }
    }
    
    func decode<T: Decodable> (weatherType: T, data: Data) -> T? {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                print(JsonLoaderError.decodingFail.description)
                return nil
            }
        }
}
