import Foundation
import UIKit

protocol ListContactsPresenter {
    func viewDidLoad()
    func configure(with view: ListContactsView)
    func cellWillAppear(for contact: Contact, completion: @escaping (ContactCellViewModel) -> Void)
}

final class ListContactsPresenterImpl: ListContactsPresenter {
    private var interactor: ListContactInteractor
    weak var view: ListContactsView?
    
    init(interactor: ListContactInteractor = ListContactInteractorImpl()) {
        self.interactor = interactor
    }
    
    func configure(with view: ListContactsView) {
        self.view = view
    }

    func viewDidLoad() {
        view?.showLoading()
        interactor.loadContacts {  [weak self]  response in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.view?.hideLoading()
                switch response {
                case let .success(contacts):
                    self.view?.showContacts(contacts)
                case .failure:
                    self.view?.showError("Some error message")
                }
            }
        }
    }
    
    func cellWillAppear(for contact: Contact, completion: @escaping (ContactCellViewModel) -> Void) {
        let cellWithDefaultImage = ContactCellViewModel(label: contact.name, image: UIImage(systemName: "photo") ?? UIImage())
        
        guard let url = contact.photoURL else {
            completion(cellWithDefaultImage)
            return
        }
        
        interactor.loadImage(from: url) {  image in
            DispatchQueue.main.async {
                guard let image else {
                    completion(cellWithDefaultImage)
                    return
                }
                
                let cellViewModel = ContactCellViewModel(
                    label: contact.name,
                    image: image
                )
                completion(cellViewModel)
            }
        }
    }
}
