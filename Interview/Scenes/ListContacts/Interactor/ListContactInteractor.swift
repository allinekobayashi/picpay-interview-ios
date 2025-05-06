import Foundation
import UIKit

enum ContactInteractorResponse {
    case success([Contact])
    case failure
}

protocol ListContactInteractor {
    func loadContacts(_ completion: @escaping (ContactInteractorResponse) -> Void)
    func loadImage(from url: URL,_ completion: @escaping (UIImage?) -> Void)
}

final class UserIdsLegacy {
    static let legacyIds = [10, 11, 12, 13]
    
    static func isLegacy(id: Int) -> Bool {
        return legacyIds.contains(id)
    }
}

final class ListContactInteractorImpl: ListContactInteractor {
    let service: ListContactService
    
    init(service: ListContactService = ListContactServiceImpl()) {
        self.service = service
    }
    
    func loadContacts(_ completion: @escaping (ContactInteractorResponse) -> Void) {
        service.fetchContacts { serviceResponse in
            switch serviceResponse {
            case let .success(rawContacts):
                let contacts = rawContacts.compactMap(self.mapContact)
                completion(.success(contacts))
            case let .failure(contactServiceError):
                switch contactServiceError {
                case .parsingURL:
                    // Log error
                    print("⚠️ Parsing URL error occurred")
                    completion(.failure)
                case .fetchingData:
                    // Log the error
                    print("⚠️ Fetching data error occurred")
                    completion(.failure)
                case .decoding:
                    print("⚠️ Network error occurred")
                    completion(.failure)
                }
            }
        }
    }
    
    func loadImage(from url: URL, _ completion: @escaping (UIImage?) -> Void) {
        service.fetchImage(from: url, completion: completion)
    }
    
    // TODO: I can also create a mapper
    func mapContact(contactResponse: ContactResponse) -> Contact {
        return Contact(
            id: contactResponse.id,
            name: contactResponse.name,
            photoURL: URL(string: contactResponse.photoURL),
            alert: defineAlert(for: contactResponse)
        )
    }
    
    func defineAlert(for contact: ContactResponse) -> Contact.AlertConfig {
        if UserIdsLegacy.isLegacy(id: contact.id) {
            return .init(title: "Atenção", message:"Você tocou no contato sorteado")
        } else {
            return .init(title: "Você tocou em", message:"\(contact.name)")
        }
    }
}
