@testable import Interview
import UIKit
import Foundation

final class MockListContactService: ListContactService {
    var response: Interview.ContactServiceResponse?
    var lastURL: URL?
    var image: UIImage?
    
    func fetchContacts(completion: @escaping (Interview.ContactServiceResponse) -> Void) {
        completion(response!)
    }
    
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        self.lastURL = url
        completion(self.image)
    }
}
