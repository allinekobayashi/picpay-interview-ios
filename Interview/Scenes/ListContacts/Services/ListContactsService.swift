import Foundation
import UIKit

enum ServiceError {
    case parsingURL
    case fetchingData
    case decoding(Error)
}

enum ContactServiceResponse {
    case success([ContactResponse])
    case failure(ServiceError)
}

protocol ListContactService {
    func fetchContacts(completion: @escaping (ContactServiceResponse) -> Void)
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

final class ListContactServiceImpl: ListContactService {
    private let contactURL = "https://669ff1b9b132e2c136ffa741.mockapi.io/picpay/ios/interview/contacts"
    private let session: URLSession
    private let cache: ImageCache

    init(session: URLSession = .shared, cache: ImageCache = ImageCacheImpl()) {
        self.session = session
        self.cache = cache
    }
    
    func fetchContacts(completion: @escaping (ContactServiceResponse) -> Void) {
        guard let api = URL(string: contactURL) else {
            completion(.failure(.parsingURL))
            return
        }
        
        let task = session.dataTask(with: api) { (data, _, error) in
            guard let jsonData = data else {
                completion(.failure(.fetchingData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([ContactResponse].self, from: jsonData)
                
                completion(.success(decoded))
            } catch let error {
                completion(.failure(.decoding(error)))
            }
        }
        
        task.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url) {
            completion(cachedImage)
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data, let image = UIImage(data: data) else {
                //TODO: Return error
                completion(nil)
                return
            }
            
            self.cache.setObject(image, forKey: url)
            completion(image)
        }
        
        task.resume()
    }
}
