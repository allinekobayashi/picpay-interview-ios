import Foundation
import UIKit

struct Contact {
    struct AlertConfig {
        var title: String
        var message: String
    }
    
    var id: Int
    var name: String
    var photoURL: URL?
    var alert: AlertConfig
}
