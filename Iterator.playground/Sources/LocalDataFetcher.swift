import Foundation

public protocol DataFetcher {
//    func fetchGenericJSONData<T: Decodable>(path: Any, response: @escaping (T?) -> Void)
    func fetchGenericJSONData<T: Decodable>(urlString: String, response: @escaping (T?) -> Void)
}

public class LocalDataFetcher: DataFetcher {
    
    public init() {}
    
//    public func fetchGenericJSONData<T: Decodable>(path: Any, response: @escaping (T?) -> Void) {
//        var urlString: String?
//        if path is String {
//            urlString = path as? String
//        } else if let path = path as? URL, path.isFileURL {
//            urlString = path.path
//        } else {
//            response(nil)
//        }
    
    public func fetchGenericJSONData<T: Decodable>(urlString: String, response: @escaping (T?) -> Void)  {
        
        guard let file = Bundle.main.url(forResource: urlString, withExtension: nil) else {
            print("Couldn't file \(urlString) in main bundle")
            response(nil)
            return
        }
        
        let data = try? Data(contentsOf: file)
        
        let decoded = self.decodeJSON(type: T.self, from: data)
        response(decoded)
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.HHmmss)
        guard let data = from else { return nil }
        
        do {
            let object = try decoder.decode(type.self, from: data)
            return object
        } catch {
            print("Failed to decode JSON", error.localizedDescription)
            return nil
        }
    }
}
